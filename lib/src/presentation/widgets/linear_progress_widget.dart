import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extension.dart';

class LinearProgressWidget extends StatelessWidget {
  const LinearProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(4),
      color: context.themeColors.interactive,
      backgroundColor: Colors.transparent,
    );
  }
}
