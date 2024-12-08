import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_colors.dart';

extension ColorFilterExtension on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension ColorExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get iconActive => isDark ? AppColors.blueB : AppColors.primary;

  Color get iconInActive => isDark ? AppColors.white.s40 : AppColors.black.s40;

  Color get textPrimary => isDark ? AppColors.appWhite : AppColors.appBlack;

  Color get purple => isDark ? AppColors.purpleB : AppColors.purpleA;

  Color get bg => isDark ? AppColors.appBlack : AppColors.appWhite;
}

extension StylesExtension on Color {
  TextStyle get appBar => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: this,
      );

  TextStyle get tabBar => TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: this,
      );
}
