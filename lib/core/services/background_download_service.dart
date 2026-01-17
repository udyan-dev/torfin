import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:duration/duration.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_torrent/flutter_torrent.dart' as torrent;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_bytes/pretty_bytes.dart';

import '../theme/app_colors.dart';
import '../utils/string_constants.dart';

const _kHeartbeat = 'heartbeat';
const _kHeartbeatTimeout = 3;
const _kNotificationId = 1001;
const _kMaxEta = 0x7FFFFFFF;
const _kCoinsTimestampKey = 'coinsTimestamp';
const _kInsufficientCoinsIdKey = 'insufficientCoinsId';
const _kInsufficientCoinsTimeKey = 'insufficientCoinsTime';
const _kInsufficientCoinsDuration = 3000; // 3 seconds in milliseconds
const _kTorrentGetRequest =
    '{"method":"torrent-get","arguments":{"fields":["id","name","status","percentDone","rateDownload","eta","files","errorString","magnetLink"]}}';

class BackgroundDownloadService {
  static bool _initialized = false;
  static Timer? _heartbeatTimer;

  static Future<void> init() async {
    if (_initialized || !Platform.isAndroid) return;
    _initialized = true;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: notificationChannelId,
        channelName: notificationChannelName,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
      ),
    );
  }

  static Future<bool> get isRunning => FlutterForegroundTask.isRunningService;

  static Future<void> start() async {
    if (!Platform.isAndroid) return;
    if (await isRunning) {
      _startHeartbeat();
      return;
    }
    await FlutterForegroundTask.startService(
      serviceId: _kNotificationId,
      notificationTitle: foregroundNotificationTitle,
      notificationText: foregroundNotificationBody,
      callback: _taskCallback,
    );
    _startHeartbeat();
  }

  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    FlutterForegroundTask.sendDataToTask(_kHeartbeat);
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => FlutterForegroundTask.sendDataToTask(_kHeartbeat),
    );
  }

  static void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  static Future<void> stop() async {
    if (!Platform.isAndroid) return;
    stopHeartbeat();
    if (await isRunning) await FlutterForegroundTask.stopService();
  }
}

@pragma('vm:entry-point')
void _taskCallback() => FlutterForegroundTask.setTaskHandler(_TaskHandler());

@pragma('vm:entry-point')
Future<void> _onNotificationAction(NotificationResponse response) async {
  final action = response.actionId;
  if (action == null) return;

  if (action == 'cancel') {
    torrent.request('{"method":"torrent-stop","arguments":{}}');
    FlutterForegroundTask.sendDataToTask('stop_task');
    FlutterForegroundTask.stopService();
  } else if (action.startsWith('retry_')) {
    await _handleRetry(action);
  } else if (action.startsWith('pause')) {
    final id = action == 'pause_all' ? null : int.tryParse(action.substring(6));
    final args = id == null
        ? <String, Object>{}
        : <String, Object>{
            'ids': [id],
          };
    torrent.request(jsonEncode({'method': 'torrent-stop', 'arguments': args}));
  } else if (action.startsWith('resume')) {
    final id = action == 'resume_all'
        ? null
        : int.tryParse(action.substring(7));
    final args = id == null
        ? <String, Object>{}
        : <String, Object>{
            'ids': [id],
          };
    torrent.request(jsonEncode({'method': 'torrent-start', 'arguments': args}));
  }
}

Future<void> _handleRetry(String action) async {
  final id = int.tryParse(action.substring(6));
  if (id == null) return;
  // Check coins
  const storage = FlutterSecureStorage();
  final coinsStr = await storage.read(key: coinsKey);
  final coins = int.tryParse(coinsStr ?? '') ?? initialCoins;
  if (coins <= 0) {
    await storage.write(key: _kInsufficientCoinsIdKey, value: '$id');
    await storage.write(
      key: _kInsufficientCoinsTimeKey,
      value: '${DateTime.now().millisecondsSinceEpoch}',
    );
    return;
  }
  // Get magnetLink before removing
  final res = torrent.request(
    '{"method":"torrent-get","arguments":{"ids":[$id],"fields":["magnetLink"]}}',
  );
  final data = jsonDecode(res) as Map<String, dynamic>;
  final torrents =
      (data['arguments'] as Map<String, dynamic>)['torrents'] as List;
  if (torrents.isEmpty) return;
  final firstTorrent = torrents[0] as Map<String, dynamic>;
  final magnetLink = firstTorrent['magnetLink'] as String?;
  if (magnetLink == null || magnetLink.isEmpty) return;
  // Remove and re-add
  torrent.request(
    '{"method":"torrent-remove","arguments":{"ids":[$id],"delete-local-data":true}}',
  );
  final addRes = torrent.request(
    jsonEncode({
      'method': 'torrent-add',
      'arguments': {'filename': magnetLink},
    }),
  );
  // Deduct coin only if added successfully
  final addData = jsonDecode(addRes) as Map<String, dynamic>;
  if (addData['result'] == 'success') {
    final args = addData['arguments'] as Map<String, dynamic>?;
    if (args != null && args['torrent-added'] != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await storage.write(key: coinsKey, value: '${coins - 1}');
      await storage.write(key: _kCoinsTimestampKey, value: '$timestamp');
    }
  }
}

class _TaskHandler extends TaskHandler {
  DateTime _lastHeartbeat = DateTime.now();
  late final FlutterLocalNotificationsPlugin _notifications;
  bool _isStopping = false;

  bool get _isMainAlive =>
      DateTime.now().difference(_lastHeartbeat).inSeconds < _kHeartbeatTimeout;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _lastHeartbeat = DateTime.now();
    _notifications = FlutterLocalNotificationsPlugin();
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _onNotificationAction,
      onDidReceiveBackgroundNotificationResponse: _onNotificationAction,
    );
    if (starter == TaskStarter.system) {
      final dir = p.join(
        (await getApplicationSupportDirectory()).path,
        'transmission',
      );
      torrent.initSession(dir, 'transmission');
    }
  }

  @override
  void onReceiveData(Object data) {
    if (data == _kHeartbeat) {
      _lastHeartbeat = DateTime.now();
    } else if (data == 'stop_task') {
      _isStopping = true;
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (_isStopping) return;
    if (!_isMainAlive) _updateNotification();
  }

  Future<void> _updateNotification() async {
    final response = torrent.request(_kTorrentGetRequest);
    final data = jsonDecode(response) as Map<String, dynamic>;
    if (data['result'] != 'success') return;

    final args = data['arguments'] as Map<String, dynamic>;
    final allTorrents = args['torrents'] as List<dynamic>;
    final torrents = allTorrents
        .cast<Map<String, dynamic>>()
        .where((t) => t['status'] == 4 || t['status'] == 2 || t['status'] == 0)
        .toList();

    if (torrents.isEmpty) {
      _notifications.cancel(_kNotificationId);
      FlutterForegroundTask.stopService();
      return;
    }

    torrents.length == 1
        ? await _showSingle(torrents.first)
        : await _showMultiple(torrents);
  }

  String _formatEta(int eta) => eta < 0 || eta == _kMaxEta
      ? notificationInfinity
      : Duration(seconds: eta).pretty(abbreviated: true, delimiter: ' ');

  String _formatSubText(int progress, String speed, String eta) =>
      '$progress$notificationPercentSuffix$notificationSeparator$speed$notificationSpeedSuffix$notificationSeparator$eta';

  Future<String> _torrentTitle(Map<String, dynamic> t) async {
    final id = t['id'] as int;
    const storage = FlutterSecureStorage();
    final insufficientIdStr = await storage.read(key: _kInsufficientCoinsIdKey);
    final insufficientTimeStr = await storage.read(
      key: _kInsufficientCoinsTimeKey,
    );
    if (insufficientIdStr != null && insufficientTimeStr != null) {
      final insufficientId = int.tryParse(insufficientIdStr);
      final insufficientTime = int.tryParse(insufficientTimeStr);
      if (insufficientId == id && insufficientTime != null) {
        final elapsed =
            DateTime.now().millisecondsSinceEpoch - insufficientTime;
        if (elapsed < _kInsufficientCoinsDuration) {
          return insufficientCoins;
        }
        await storage.delete(key: _kInsufficientCoinsIdKey);
        await storage.delete(key: _kInsufficientCoinsTimeKey);
      }
    }
    final errorString = t['errorString'] as String? ?? '';
    if (errorString.isNotEmpty) return errorString;
    final files = t['files'] as List<dynamic>?;
    return (files == null || files.isEmpty)
        ? gettingTorrentMetadata
        : t['name'] as String;
  }

  Future<void> _showSingle(Map<String, dynamic> t) async {
    final progress = ((t['percentDone'] as num) * 100).clamp(0, 100).toInt();
    final isActive = t['status'] == 4 || t['status'] == 2;
    final speed = prettyBytes((t['rateDownload'] as int).toDouble());
    final eta = _formatEta(t['eta'] as int? ?? -1);
    final colors = AppColors.fromBrightness(
      PlatformDispatcher.instance.platformBrightness,
    );
    final id = t['id'] as int;
    final errorString = t['errorString'] as String? ?? '';
    final title = await _torrentTitle(t);
    final hasError = errorString.isNotEmpty || title == insufficientCoins;

    _notifications.show(
      _kNotificationId,
      title,
      emptyString,
      NotificationDetails(
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
          actions: [
            AndroidNotificationAction(
              hasError ? 'retry_$id' : '${isActive ? 'pause' : 'resume'}_$id',
              hasError
                  ? retry
                  : isActive
                  ? notificationPause
                  : notificationResume,
              titleColor: hasError ? colors.supportError : colors.interactive,
              cancelNotification: false,
            ),
            AndroidNotificationAction(
              'cancel',
              cancel,
              titleColor: colors.interactive,
              cancelNotification: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMultiple(List<Map<String, dynamic>> torrents) async {
    final progress =
        ((torrents.fold<double>(0, (s, t) => s + (t['percentDone'] as num)) /
                    torrents.length) *
                100)
            .clamp(0, 100)
            .toInt();
    final speed = prettyBytes(
      torrents
          .fold<int>(0, (s, t) => s + (t['rateDownload'] as int))
          .toDouble(),
    );
    final activeCount = torrents
        .where((t) => t['status'] == 4 || t['status'] == 2)
        .length;
    final pausedCount = torrents.where((t) => t['status'] == 0).length;
    final hasActive = activeCount > 0;
    final maxEta = torrents.fold<int>(-1, (m, t) {
      final e = t['eta'] as int? ?? -1;
      return (e > m && e != _kMaxEta) ? e : m;
    });
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
    for (final t in torrents) {
      final tTitle = await _torrentTitle(t);
      final tProgress = ((t['percentDone'] as num) * 100).toInt();
      final tSpeed = prettyBytes((t['rateDownload'] as int).toDouble());
      inboxLines.add(
        '$tTitle$notificationSeparator$tProgress$notificationPercentSuffix$notificationSeparator$tSpeed$notificationSpeedSuffix',
      );
    }

    _notifications.show(
      _kNotificationId,
      title,
      eta,
      NotificationDetails(
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
              hasActive ? 'pause_all' : 'resume_all',
              hasActive ? notificationPauseAll : notificationResumeAll,
              titleColor: color,
              cancelNotification: false,
            ),
            AndroidNotificationAction(
              'cancel',
              cancel,
              titleColor: color,
              cancelNotification: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onNotificationButtonPressed(String id) =>
      FlutterForegroundTask.sendDataToMain(id);

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
    FlutterForegroundTask.sendDataToMain('open_downloads');
  }

  @override
  void onNotificationDismissed() {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    try {
      await _notifications.cancel(_kNotificationId);
    } catch (_) {}
  }
}
