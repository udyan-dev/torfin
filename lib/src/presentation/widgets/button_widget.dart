import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final Color? backgroundColor;
  const ButtonWidget({
    super.key,
    required this.buttonText,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? context.colors.buttonPrimary,
        foregroundColor: context.colors.textOnColor,
        elevation: 0,
        shape: LinearBorder.none,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      ),
      child: AppText.bodyCompact02(
        buttonText,
        color: context.colors.textOnColor,
      ),
    );
  }
}
