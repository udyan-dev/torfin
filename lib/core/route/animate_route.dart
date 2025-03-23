import 'package:flutter/material.dart';

class AnimateRoute<T> extends PageRouteBuilder<T> {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final Widget Function(BuildContext) builder;

  AnimateRoute({required this.builder})
    : super(
        pageBuilder: (context, animation, __) => builder(context),
        transitionDuration: Durations.medium2,
        reverseTransitionDuration: Durations.medium2,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );

  static Future<T?> push<T>(Widget page) async {
    return await Navigator.of(
      navigatorKey.currentContext!,
    ).push(AnimateRoute<T>(builder: (_) => page));
  }

  static Future<T?> pushReplace<T>(Widget page) async {
    return await Navigator.of(
      navigatorKey.currentContext!,
    ).pushReplacement(AnimateRoute<T>(builder: (_) => page));
  }

  static void pop<T>([T? result]) {
    Navigator.of(navigatorKey.currentContext!).pop(result);
  }
}
