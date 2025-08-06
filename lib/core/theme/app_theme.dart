import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_colors.dart';

import '../utils/string_constants.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.fromBrightness(
      Brightness.light,
    ).background,
    tabBarTheme: TabBarThemeData(
      dividerHeight: 0,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      splashFactory: NoSplash.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.fromBrightness(
        Brightness.light,
      ).borderInteractive,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      indicator: ShapeDecoration(
        shape: Border(
          top: BorderSide(
            color: AppColors.fromBrightness(Brightness.light).borderInteractive,
            width: 3,
          ),
        ),
      ),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0.0),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      backgroundColor: WidgetStatePropertyAll(
        AppColors.fromBrightness(Brightness.light).field01,
      ),
      surfaceTintColor: WidgetStatePropertyAll(
        AppColors.fromBrightness(Brightness.light).fieldHover01,
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: ibmPlexSans,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.fromBrightness(Brightness.light).textPrimary,
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: ibmPlexSans,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.fromBrightness(Brightness.light).textPlaceholder,
        ),
      ),
      shape: WidgetStatePropertyAll(
        LinearBorder.bottom(
          side: BorderSide(
            color: AppColors.fromBrightness(Brightness.light).borderStrong01,
          ),
        ),
      ),
    ),
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.fromBrightness(
      Brightness.dark,
    ).background,
    tabBarTheme: TabBarThemeData(
      dividerHeight: 0,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      splashFactory: NoSplash.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.fromBrightness(
        Brightness.dark,
      ).borderInteractive,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      indicator: ShapeDecoration(
        shape: Border(
          top: BorderSide(
            color: AppColors.fromBrightness(Brightness.dark).borderInteractive,
            width: 3,
          ),
        ),
      ),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0.0),
      backgroundColor: WidgetStatePropertyAll(
        AppColors.fromBrightness(Brightness.dark).field01,
      ),
      surfaceTintColor: WidgetStatePropertyAll(
        AppColors.fromBrightness(Brightness.light).fieldHover01,
      ),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: ibmPlexSans,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.fromBrightness(Brightness.dark).textPrimary,
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: ibmPlexSans,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.fromBrightness(Brightness.dark).textPlaceholder,
        ),
      ),
      shape: WidgetStatePropertyAll(
        LinearBorder.bottom(
          side: BorderSide(
            color: AppColors.fromBrightness(Brightness.dark).borderStrong01,
          ),
        ),
      ),
    ),
  );
}
