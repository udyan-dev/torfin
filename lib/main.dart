import 'dart:async' show runZonedGuarded;
import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:torfin/core/theme/app_theme.dart';

import 'core/bindings/di.dart' as di;
import 'core/services/firebase_service.dart';
import 'core/utils/string_constants.dart';
import 'src/presentation/home/home_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Future.wait([
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        FirebaseService.init,
        di.init,
      ], eagerError: true);

      runApp(const MainApp());
    },
    (error, stack) => !kDebugMode
        ? FirebaseService.recordError(error, stack, fatal: true)
        : log(zone, error: error, stackTrace: stack),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
