import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extension.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.square,
        backgroundColor: context.themeColors.borderSubtle01,
        color: context.themeColors.interactive,
      ),
    );
  }
}
