import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show kDebugMode, PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

import 'core/bindings/di.dart';
import 'core/services/background_download_service.dart';
import 'core/services/consent_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'src/data/engine/engine.dart';
import 'src/presentation/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterForegroundTask.initCommunicationPort();

  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) {
      FirebaseService.recordError(error, stack, fatal: true);
    }
    return true;
  };

  await Future.wait([
    ConsentService.initialize(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    FirebaseService.init,
    initDI(),
  ], eagerError: true);

  unawaited(MobileAds.instance.initialize());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onPause: _handleBackgrounding,
      onDetach: _handleBackgrounding,
      onResume: () => di<NotificationService>().start(),
    );
  }

  void _handleBackgrounding() {
    di<NotificationService>().stop(cancelNotification: false);
    BackgroundDownloadService.stopHeartbeat();
    unawaited(_saveStateBeforeExit());
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _saveStateBeforeExit() async {
    try {
      await di<Engine>().saveTorrentsResumeStatus();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: di<ThemeService>().themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeAnimationDuration: Duration.zero,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: UpgradeAlert(
            showLater: false,
            showIgnore: false,
            upgrader: Upgrader(durationUntilAlertAgain: Duration.zero),
            child: const WithForegroundTask(child: HomeScreen()),
          ),
        );
      },
    );
  }
}
