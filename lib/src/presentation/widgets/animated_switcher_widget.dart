import 'package:flutter/material.dart';

class AnimatedSwitcherWidget extends StatelessWidget {
  final Widget child;
  const AnimatedSwitcherWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (widget, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        final slide = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: widget),
        );
      },
      child: child,
    );
  }
}
