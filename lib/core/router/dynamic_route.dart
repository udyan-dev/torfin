import 'package:flutter/material.dart';
import 'package:torfin/src/injection.dart';

class DynamicRouteWidget<T> extends PageRouteBuilder<T> {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final Widget Function(BuildContext) builder;
  final Duration duration;

  DynamicRouteWidget({
    required this.builder,
    this.duration = Durations.medium2,
  }) : super(
          pageBuilder: (context, animation, __) => builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetTween = Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease));

            final fadeTween = Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.ease));

            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );

  static Future<T?> push<T>(Widget page) {
    return Navigator.of(navigationContext)
        .push(DynamicRouteWidget<T>(builder: (_) => page));
  }

  static Future<T?> pushReplace<T>(Widget page) {
    return Navigator.of(navigationContext)
        .pushReplacement(DynamicRouteWidget<T>(builder: (_) => page));
  }

  static void pop<T>([T? result]) {
    Navigator.of(navigationContext).pop(result);
  }
}
