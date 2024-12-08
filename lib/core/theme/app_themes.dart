import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

sealed class AppThemes {
  static get lightTheme => ThemeData(
        fontFamily: 'gg',
        colorScheme: const ColorScheme.light(),
        scaffoldBackgroundColor: AppColors.white.s80,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        tabBarTheme: const TabBarTheme(
          splashFactory: NoSplash.splashFactory,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.appWhite,
              systemNavigationBarDividerColor: AppColors.appWhite,
              systemNavigationBarIconBrightness: Brightness.dark,
            )),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: AppColors.appWhite,
          type: BottomNavigationBarType.fixed,
        ),
      );

  static get darkTheme => ThemeData(
        fontFamily: 'gg',
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: AppColors.black.s40,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        tabBarTheme: const TabBarTheme(
          splashFactory: NoSplash.splashFactory,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.appBlack,
              systemNavigationBarDividerColor: AppColors.appBlack,
              systemNavigationBarIconBrightness: Brightness.dark,
            )),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: AppColors.appBlack,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
