import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension AppThemeExtension on BuildContext {
  Brightness get _brightness => Theme.of(this).brightness;

  AppColors get colors => AppColors.fromBrightness(_brightness);
}

extension ColorExtension on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}
