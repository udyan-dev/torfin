import 'package:flutter/material.dart';

class DynamicRouteBuilder<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final bool fadeTransition;

  DynamicRouteBuilder({
    required this.builder,
    this.fadeTransition = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return fadeTransition
                ? FadeTransition(opacity: animation, child: child)
                : SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(1, 0), end: Offset.zero)
                        .animate(animation),
                    child: child,
                  );
          },
        );
}

void pushPage(BuildContext context, Widget page, {bool fade = true}) {
  Navigator.of(context)
      .push(DynamicRouteBuilder(builder: (_) => page, fadeTransition: fade));
}

void popPage(BuildContext context) {
  Navigator.of(context).pop();
}
