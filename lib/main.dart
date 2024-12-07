import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:torfin/core/router/dynamic_route.dart';
import 'package:torfin/core/theme/app_themes.dart';
import 'package:torfin/src/injection.dart';

import 'firebase_options.dart';
import 'src/presentation/screen/network/network_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) async {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails, fatal: true);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await inject();
  unawaited(MobileAds.instance.initialize());
  runApp(const MyApp(
    key: ValueKey("my_app"),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey("_torfin_"),
      title: 'Torfin',
      navigatorKey: DynamicRouteWidget.navigatorKey,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const NetworkScreen(
        key: ValueKey("_network_screen_"),
      ),
    );
  }
}
