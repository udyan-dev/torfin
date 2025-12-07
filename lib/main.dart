import 'dart:async' show runZonedGuarded, unawaited;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/bindings/di.dart';
import 'core/services/background_download_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'src/data/engine/engine.dart';
import 'src/presentation/home/home_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterForegroundTask.initCommunicationPort();
      unawaited(MobileAds.instance.initialize());
      await Future.wait([
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        FirebaseService.init,
        initDI,
      ], eagerError: true);

      runApp(const MainApp());
    },
    (error, stack) => !kDebugMode
        ? FirebaseService.recordError(error, stack, fatal: true)
        : null,
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        BackgroundDownloadService.stopHeartbeat();
        _saveStateBeforeExit();
        break;
      case AppLifecycleState.resumed:
        di<NotificationService>().start();
        break;
      default:
        break;
    }
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
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeAnimationDuration: Duration.zero,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const WithForegroundTask(child: HomeScreen()),
        );
      },
    );
  }
}
