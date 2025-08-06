import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

class BodyWidget extends StatelessWidget {
  final Widget child;

  const BodyWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(color: context.colors.layer01, child: child),
    );
  }
}
