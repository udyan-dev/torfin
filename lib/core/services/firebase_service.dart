import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:firebase_performance/firebase_performance.dart'
    show FirebasePerformance;
import 'package:flutter/cupertino.dart' show FlutterError;
import 'package:flutter/foundation.dart' show PlatformDispatcher, kDebugMode;

import '../../firebase_options.dart';

sealed class FirebaseService {
  static Future<void> get init {
    return Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        )
        .then((_) {
          if (!kDebugMode) {
            return Future.wait([
              FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
                true,
              ),
              FirebasePerformance.instance.setPerformanceCollectionEnabled(
                true,
              ),
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true),
            ]);
          }
          return Future.value();
        })
        .then((_) {
          if (!kDebugMode) {
            FlutterError.onError =
                FirebaseCrashlytics.instance.recordFlutterError;
            PlatformDispatcher.instance.onError = (error, stack) {
              FirebaseCrashlytics.instance.recordError(
                error,
                stack,
                fatal: true,
              );
              return true;
            };
          }
        });
  }

  static Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) {
    return FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  }
}
