import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_colors.dart';

extension ColorFilterExtension on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension ColorExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get iconActive => isDark ? AppColors.appBlack : AppColors.appWhite;

  Color get iconInActive => isDark ? AppColors.white.s40 : AppColors.black.s40;

  Color get textPrimary => isDark ? AppColors.white.s80 : AppColors.black.s80;

  Color get purple => isDark ? AppColors.purpleB : AppColors.purpleA;
}

extension StylesExtension on Color {
  TextStyle get appBar => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: this,
      );
}
