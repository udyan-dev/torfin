import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

extension ThemeContextExtension on BuildContext {
  ThemeColor get themeColors =>
      Theme.of(this).extension<ThemeColor>() ??
      (isDark ? ThemeColor.dark : ThemeColor.light);

  bool get isDark =>
      Theme.of(this).brightness == Brightness.dark ? true : false;
}

extension ColorFilterExtension on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension AssetExtension on String {
  String get toAsset =>
      toLowerCase().contains("assets/") ? this : "assets/$this";
}
