import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

sealed class AppThemes {
  static get lightTheme => ThemeData(
        fontFamily: 'gg',
        colorScheme: const ColorScheme.light(),
        scaffoldBackgroundColor: AppColors.appWhite,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.appWhite,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.purpleA,
              systemNavigationBarDividerColor: AppColors.purpleA,
              systemNavigationBarIconBrightness: Brightness.dark,
            )),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: AppColors.purpleA,
          type: BottomNavigationBarType.fixed,
        ),
      );

  static get darkTheme => ThemeData(
        fontFamily: 'gg',
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: AppColors.appBlack,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.appBlack,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.purpleB,
              systemNavigationBarDividerColor: AppColors.purpleB,
              systemNavigationBarIconBrightness: Brightness.dark,
            )),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: AppColors.purpleB,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
