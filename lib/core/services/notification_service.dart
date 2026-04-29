import 'dart:async' show Timer, unawaited;
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:duration/duration.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_bytes/pretty_bytes.dart';

import '../../src/data/engine/engine.dart';
import '../../src/data/engine/torrent.dart';
import '../../src/domain/usecases/add_torrent_use_case.dart';
import '../theme/app_colors.dart';
import '../utils/string_constants.dart';
import 'background_download_service.dart';

const _kNotificationId = 1001;
const _kMaxEta = 0x7FFFFFFF;
const _kInsufficientCoinsIdKey = 'insufficientCoinsId';
const _kInsufficientCoinsTimeKey = 'insufficientCoinsTime';
const _kInsufficientCoinsDuration = 3000;

class _InsufficientCoinsMarker {
  const _InsufficientCoinsMarker(this.id);

  final int id;
}

class NotificationService {
  final Engine _engine;
  AddTorrentUseCase? _addTorrentUseCase;
  final _notifications = FlutterLocalNotificationsPlugin();
  final _storage = const FlutterSecureStorage();
  Timer? _timer;
  bool _isUpdating = false;
  bool _isListeningTaskData = false;
  int? initialTabIndex;
  void Function(int)? onNavigateToTab;

  NotificationService(this._engine);

  void setAddTorrentUseCase(AddTorrentUseCase useCase) {
    _addTorrentUseCase = useCase;
  }

  Future<void> init() async {
    await _notifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        unawaited(_handleAction(response));
      },
    );
    final launchDetails = await _notifications
        .getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      initialTabIndex = 2;
    }
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            notificationChannelId,
            notificationChannelName,
            importance: Importance.low,
            playSound: false,
            enableVibration: false,
            showBadge: false,
          ),
        );
  }

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;
    final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdk < 33) return true;
    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited;
  }

  void start() {
    if (!(_timer?.isActive ?? false)) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => unawaited(_update()),
      );
    }
    if (!_isListeningTaskData) {
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
      _isListeningTaskData = true;
    }
  }

  void stop({bool cancelNotification = true}) {
    _timer?.cancel();
    _timer = null;
    if (cancelNotification) {
      _notifications.cancel(id: _kNotificationId);
    }
  }

  void dispose() {
    stop();
    if (_isListeningTaskData) {
      FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
      _isListeningTaskData = false;
    }
  }

  void _onTaskData(Object data) {
    if (data is! String) return;
    if (data == 'open_downloads') {
      onNavigateToTab?.call(2);
      return;
    }
    unawaited(_processAction(data));
  }

  Future<void> _processAction(String action) async {
    try {
      final torrents = await _engine.fetchTorrents(mode: TorrentFetchMode.list);
      switch (action) {
        case 'pause':
          for (final t in torrents) {
            if (t.status == TorrentStatus.downloading ||
                t.status == TorrentStatus.checking) {
              t.stop();
            }
          }
        case 'resume':
          for (final t in torrents) {
            if (t.status == TorrentStatus.stopped) {
              t.start();
            }
          }
        case 'stop':
          for (final t in torrents) {
            t.stop();
          }
          await BackgroundDownloadService.stop();
          unawaited(_notifications.cancel(id: _kNotificationId));
      }
      unawaited(_update());
    } catch (_) {}
  }

  Future<void> _update() async {
    if (_isUpdating) return;
    _isUpdating = true;
    try {
      final active = (await _engine.fetchTorrents(mode: TorrentFetchMode.list))
          .where(
            (t) =>
                t.status == TorrentStatus.downloading ||
                t.status == TorrentStatus.checking ||
                t.status == TorrentStatus.queuedToDownload ||
                t.status == TorrentStatus.stopped,
          )
          .toList();
      if (active.isEmpty) {
        _notifications.cancel(id: _kNotificationId);
        await BackgroundDownloadService.stop();
      } else {
        await BackgroundDownloadService.start();
        active.length == 1
            ? await _showSingle(active.first)
            : await _showMultiple(active);
      }
    } catch (_) {
    } finally {
      _isUpdating = false;
    }
  }

  String _formatEta(int eta) => eta < 0 || eta == _kMaxEta
      ? notificationInfinity
      : Duration(seconds: eta).pretty(abbreviated: true, delimiter: ' ');

  String _formatSubText(int progress, String speed, String eta) =>
      '$progress$notificationPercentSuffix$notificationSeparator$speed$notificationSpeedSuffix$notificationSeparator$eta';

  Future<_InsufficientCoinsMarker?> _readInsufficientCoinsMarker() async {
    final idStr = await _storage.read(key: _kInsufficientCoinsIdKey);
    final timeStr = await _storage.read(key: _kInsufficientCoinsTimeKey);
    if (idStr == null || timeStr == null) return null;
    final id = int.tryParse(idStr);
    final time = int.tryParse(timeStr);
    if (id == null || time == null) return null;
    final elapsed = DateTime.now().millisecondsSinceEpoch - time;
    if (elapsed >= _kInsufficientCoinsDuration) {
      await _storage.delete(key: _kInsufficientCoinsIdKey);
      await _storage.delete(key: _kInsufficientCoinsTimeKey);
      return null;
    }
    return _InsufficientCoinsMarker(id);
  }

  String _torrentTitle(Torrent t, _InsufficientCoinsMarker? marker) {
    if (marker?.id == t.id) return insufficientCoins;
    return t.errorString.isNotEmpty
        ? t.errorString
        : t.files.isEmpty
        ? gettingTorrentMetadata
        : t.name;
  }

  Future<void> _showSingle(Torrent t) async {
    final progress = (t.progress * 100).clamp(0, 100).toInt();
    final isActive =
        t.status == TorrentStatus.downloading ||
        t.status == TorrentStatus.checking;
    final speed = prettyBytes(t.rateDownload.toDouble());
    final eta = _formatEta(t.eta);
    final colors = AppColors.fromBrightness(
      PlatformDispatcher.instance.platformBrightness,
    );
    final marker = await _readInsufficientCoinsMarker();
    final title = _torrentTitle(t, marker);
    final hasError = t.errorString.isNotEmpty || title == insufficientCoins;

    _notifications.show(
      id: _kNotificationId,
      title: title,
      body: emptyString,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelName,
          color: hasError ? colors.supportError : colors.interactive,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          subText: _formatSubText(progress, speed, eta),
          number: isActive ? 1 : 0,
          actions: [
            AndroidNotificationAction(
              hasError
                  ? 'retry_${t.id}'
                  : '${isActive ? 'pause' : 'resume'}_${t.id}',
              hasError
                  ? retry
                  : isActive
                  ? notificationPause
                  : notificationResume,
              titleColor: hasError ? colors.supportError : colors.interactive,
              cancelNotification: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMultiple(List<Torrent> torrents) async {
    final progress =
        ((torrents.fold<double>(0, (s, t) => s + t.progress) /
                    torrents.length) *
                100)
            .clamp(0, 100)
            .toInt();
    final speed = prettyBytes(
      torrents.fold<int>(0, (s, t) => s + t.rateDownload).toDouble(),
    );
    final activeCount = torrents
        .where(
          (t) =>
              t.status == TorrentStatus.downloading ||
              t.status == TorrentStatus.checking,
        )
        .length;
    final pausedCount = torrents
        .where((t) => t.status == TorrentStatus.stopped)
        .length;
    final hasActive = activeCount > 0;
    final maxEta = torrents.fold<int>(
      -1,
      (m, t) => (t.eta > m && t.eta != _kMaxEta) ? t.eta : m,
    );
    final eta = _formatEta(maxEta);
    final color = AppColors.fromBrightness(
      PlatformDispatcher.instance.platformBrightness,
    ).interactive;
    final title = [
      if (activeCount > 0)
        '$activeCount $notificationActive ${activeCount == 1 ? torrentSuffix : torrentsSuffix}',
      if (pausedCount > 0)
        '$pausedCount $notificationPaused ${pausedCount == 1 ? torrentSuffix : torrentsSuffix}',
    ].join(notificationSeparator);

    final inboxLines = <String>[];
    final marker = await _readInsufficientCoinsMarker();
    for (final t in torrents) {
      final tTitle = _torrentTitle(t, marker);
      final tProgress = (t.progress * 100).toInt();
      final tSpeed = prettyBytes(t.rateDownload.toDouble());
      inboxLines.add(
        '$tTitle$notificationSeparator$tProgress$notificationPercentSuffix$notificationSeparator$tSpeed$notificationSpeedSuffix',
      );
    }

    _notifications.show(
      id: _kNotificationId,
      title: title,
      body: eta,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelName,
          color: color,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          number: activeCount,
          subText: _formatSubText(progress, speed, eta),
          styleInformation: InboxStyleInformation(
            inboxLines,
            contentTitle: title,
          ),
          actions: [
            AndroidNotificationAction(
              '${hasActive ? 'pause' : 'resume'}_all',
              hasActive ? notificationPauseAll : notificationResumeAll,
              titleColor: color,
              cancelNotification: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(NotificationResponse response) async {
    final actionId = response.actionId;
    if (actionId == null || actionId.isEmpty) {
      onNavigateToTab?.call(2);
      return;
    }
    if (actionId == 'cancel') {
      final torrents = await _engine.fetchTorrents(mode: TorrentFetchMode.list);
      for (final t in torrents) {
        t.stop();
      }
      await BackgroundDownloadService.stop();
      _notifications.cancel(id: _kNotificationId);
      return;
    }
    try {
      final torrents = await _engine.fetchTorrents();
      if (actionId.startsWith('retry_')) {
        final id = int.tryParse(actionId.substring(6));
        if (id == null) return;
        final t = torrents.cast<Torrent?>().firstWhere(
          (t) => t?.id == id,
          orElse: () => null,
        );
        if (t == null) return;
        final magnetLink = t.magnetLink;
        // Check coins before removing
        final hasCoins = await _addTorrentUseCase?.hasCoins() ?? false;
        if (!hasCoins) {
          await _storage.write(key: _kInsufficientCoinsIdKey, value: '$id');
          await _storage.write(
            key: _kInsufficientCoinsTimeKey,
            value: '${DateTime.now().millisecondsSinceEpoch}',
          );
          unawaited(_update());
          return;
        }
        await _storage.delete(key: _kInsufficientCoinsIdKey);
        await _storage.delete(key: _kInsufficientCoinsTimeKey);
        await t.remove(true);
        await _addTorrentUseCase?.call(
          AddTorrentUseCaseParams(magnetLink: magnetLink),
          cancelToken: CancelToken(),
        );
      } else if (actionId == 'pause_all' || actionId == 'resume_all') {
        final isPause = actionId == 'pause_all';
        for (final t in torrents) {
          isPause ? t.stop() : t.start();
        }
      } else if (actionId.startsWith('pause_') ||
          actionId.startsWith('resume_')) {
        final isPause = actionId.startsWith('pause');
        final id = int.tryParse(actionId.substring(isPause ? 6 : 7));
        if (id == null) return;
        final t = torrents.cast<Torrent?>().firstWhere(
          (t) => t?.id == id,
          orElse: () => null,
        );
        if (t == null) return;
        isPause ? t.stop() : t.start();
      }
      unawaited(_update());
    } catch (_) {}
  }
}
