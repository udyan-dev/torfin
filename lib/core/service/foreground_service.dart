import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:torfin/core/service/engine_service.dart';

import '../../src/injection.dart';

// Notification response handler
void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  if (notificationResponse.actionId == 'exit') {
    // Close BitTorrent engine and stop foreground service
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.stopForegroundService();
    di<EngineService>().stop();
    // Exit the app
    SystemNavigator.pop();
  }
}

// Initialize FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Create and start the foreground service
Future<void> createForegroundService() async {
  // Request runtime notifications permission (if needed)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  // Initialize notification settings
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  // Ensure any previous foreground service is stopped and channel is deleted
  final androidPlugin =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
  await androidPlugin?.stopForegroundService();
  await androidPlugin?.deleteNotificationChannel('torfin_service');

  // Define notification details for the foreground service
  const androidNotificationDetails = AndroidNotificationDetails(
    'torfin_service',
    'Torfin',
    channelDescription:
        'This channel is used for foreground service notifications.',
    importance: Importance.defaultImportance,
    silent: true,
    ongoing: true,
    actions: [
      AndroidNotificationAction('exit', 'Exit', showsUserInterface: true),
    ],
  );

  // Start the foreground service
  await androidPlugin?.startForegroundService(
    1,
    'Torfin',
    'Running in the background...',
    notificationDetails: androidNotificationDetails,
  );
}
