import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_colors.dart';

sealed class AppThemes {
  static get buildTheme => ThemeData(
        fontFamily: 'gg',
        fontFamilyFallback: ['gg'],
        scaffoldBackgroundColor: AppColors.grayLightest,
      );
}
