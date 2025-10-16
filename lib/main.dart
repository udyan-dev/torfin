import 'dart:async' show runZonedGuarded, unawaited;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/bindings/di.dart';
import 'core/services/firebase_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'src/presentation/home/home_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
          home: const HomeScreen(),
        );
      },
    );
  }
}
