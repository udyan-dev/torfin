import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:duration/duration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_bytes/pretty_bytes.dart';

import '../../src/data/engine/engine.dart';
import '../../src/data/engine/torrent.dart';
import '../theme/app_colors.dart';
import '../utils/string_constants.dart';

class NotificationService {
  final Engine _engine;
  final _notifications = FlutterLocalNotificationsPlugin();
  Timer? _timer;

  NotificationService(this._engine);

  Future<void> init() async {
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _handleAction,
    );
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
    if (_timer?.isActive ?? false) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _notifications.cancel(1001);
  }

  Future<void> _update() async {
    try {
      final active = (await _engine.fetchTorrents())
          .where(
            (t) =>
                t.status == TorrentStatus.downloading ||
                t.status == TorrentStatus.checking ||
                t.status == TorrentStatus.queuedToDownload ||
                t.status == TorrentStatus.stopped,
          )
          .toList();

      if (active.isEmpty) {
        _notifications.cancel(1001);
      } else if (active.length == 1) {
        _showSingle(active.first);
      } else {
        _showMultiple(active);
      }
    } catch (_) {}
  }

  void _showSingle(Torrent t) {
    final progress = (t.progress * 100).clamp(0, 100).toInt();
    final isActive =
        t.status == TorrentStatus.downloading ||
        t.status == TorrentStatus.checking;
    final speed = prettyBytes(t.rateDownload.toDouble());
    final eta = t.eta < 0 || t.eta == 0x7FFFFFFF
        ? notificationInfinity
        : Duration(seconds: t.eta).pretty(abbreviated: true, delimiter: ' ');

    _notifications.show(
      1001,
      t.name,
      emptyString,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelName,
          color: AppColors.fromBrightness(
            PlatformDispatcher.instance.platformBrightness,
          ).interactive,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          subText:
              '$progress$notificationPercentSuffix$notificationSeparator$speed$notificationSpeedSuffix$notificationSeparator$eta',
          number: isActive ? 1 : 0,
          actions: [
            AndroidNotificationAction(
              '${isActive ? notificationPause.toLowerCase() : notificationResume.toLowerCase()}_${t.id}',
              isActive ? notificationPause : notificationResume,
              titleColor: AppColors.fromBrightness(
                PlatformDispatcher.instance.platformBrightness,
              ).interactive,
              cancelNotification: false,
              showsUserInterface: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiple(List<Torrent> torrents) {
    final progress =
        ((torrents.fold<double>(0, (sum, t) => sum + t.progress) /
                    torrents.length) *
                100)
            .clamp(0, 100)
            .toInt();
    final totalSpeed = torrents.fold<int>(0, (sum, t) => sum + t.rateDownload);
    final speed = prettyBytes(totalSpeed.toDouble());

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
      (max, t) => (t.eta > max && t.eta != 0x7FFFFFFF) ? t.eta : max,
    );
    final eta = maxEta < 0 || maxEta == 0x7FFFFFFF
        ? notificationInfinity
        : Duration(seconds: maxEta).pretty(abbreviated: true, delimiter: ' ');

    final contentTitleParts = <String>[];
    if (activeCount > 0) {
      final torrentWord = activeCount == 1 ? torrentSuffix : torrentsSuffix;
      contentTitleParts.add('$activeCount $notificationActive $torrentWord');
    }
    if (pausedCount > 0) {
      final torrentWord = pausedCount == 1 ? torrentSuffix : torrentsSuffix;
      contentTitleParts.add('$pausedCount $notificationPaused $torrentWord');
    }
    final contentTitle = contentTitleParts.join(notificationSeparator);

    _notifications.show(
      1001,
      contentTitle,
      eta,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelName,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          subText:
              '$progress$notificationPercentSuffix$notificationSeparator$speed$notificationSpeedSuffix$notificationSeparator$eta',
          number: activeCount,
          color: AppColors.fromBrightness(
            PlatformDispatcher.instance.platformBrightness,
          ).interactive,
          styleInformation: InboxStyleInformation(
            torrents
                .map(
                  (t) =>
                      '${t.name}$notificationSeparator${(t.progress * 100).toInt()}$notificationPercentSuffix$notificationSeparator${prettyBytes(t.rateDownload.toDouble())}$notificationSpeedSuffix',
                )
                .toList(),
            contentTitle: contentTitle,
          ),
          actions: [
            AndroidNotificationAction(
              hasActive
                  ? '${notificationPause.toLowerCase()}_all'
                  : '${notificationResume.toLowerCase()}_all',
              hasActive ? notificationPauseAll : notificationResumeAll,
              titleColor: AppColors.fromBrightness(
                PlatformDispatcher.instance.platformBrightness,
              ).interactive,
              cancelNotification: false,
              showsUserInterface: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(NotificationResponse response) async {
    final actionId = response.actionId;
    final pausePrefix = notificationPause.toLowerCase();
    final resumePrefix = notificationResume.toLowerCase();

    if (actionId == null ||
        (!actionId.startsWith('${pausePrefix}_') &&
            !actionId.startsWith('${resumePrefix}_'))) {
      return;
    }

    try {
      if (actionId == '${pausePrefix}_all' ||
          actionId == '${resumePrefix}_all') {
        final torrents = await _engine.fetchTorrents();
        final isPause = actionId == '${pausePrefix}_all';
        for (final torrent in torrents) {
          isPause ? torrent.stop() : torrent.start();
        }
      } else {
        final isPause = actionId.startsWith(pausePrefix);
        final torrentId = int.tryParse(
          actionId.replaceFirst(
            isPause ? '${pausePrefix}_' : '${resumePrefix}_',
            emptyString,
          ),
        );
        if (torrentId == null) return;

        final torrents = await _engine.fetchTorrents();
        Torrent? torrent;
        for (final t in torrents) {
          if (t.id == torrentId) {
            torrent = t;
            break;
          }
        }
        if (torrent == null) return;

        isPause ? torrent.stop() : torrent.start();
      }
      _update();
    } catch (_) {}
  }
}
