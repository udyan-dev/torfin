import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  final AppColors _colors;

  const AppStyles._(this._colors);

  factory AppStyles.fromColors(AppColors colors) => AppStyles._(colors);

  // Utility Styles

  AppTextStyle get code01 => AppTextStyle._(
    GoogleFonts.ibmPlexMono(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.32,
    ),
    _colors,
  );

  AppTextStyle get code02 => AppTextStyle._(
    GoogleFonts.ibmPlexMono(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.32,
    ),
    _colors,
  );

  AppTextStyle get label01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.32,
    ),
    _colors,
  );

  AppTextStyle get label02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get helperText01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.32,
    ),
    _colors,
  );

  AppTextStyle get helperText02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get legal01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.32,
    ),
    _colors,
  );

  AppTextStyle get legal02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  // Body Styles

  AppTextStyle get bodyCompact01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get bodyCompact02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get body01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get body02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    _colors,
  );

  // Fixed Heading Styles

  AppTextStyle get headingCompact01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get headingCompact02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading01 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.16,
    ),
    _colors,
  );

  AppTextStyle get heading02 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading03 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading04 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading05 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading06 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 42,
      height: 50 / 42,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
    ),
    _colors,
  );

  AppTextStyle get heading07 => AppTextStyle._(
    GoogleFonts.ibmPlexSans(
      fontSize: 54,
      height: 64 / 54,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
    ),
    _colors,
  );
}

class AppTextStyle extends TextStyle {
  final AppColors colors;

  AppTextStyle._(TextStyle baseStyle, this.colors)
    : super(
        inherit: baseStyle.inherit,
        color: colors.textPrimary,
        backgroundColor: baseStyle.backgroundColor,
        fontSize: baseStyle.fontSize,
        fontWeight: baseStyle.fontWeight,
        fontStyle: baseStyle.fontStyle,
        letterSpacing: baseStyle.letterSpacing,
        wordSpacing: baseStyle.wordSpacing,
        textBaseline: baseStyle.textBaseline,
        height: baseStyle.height,
        leadingDistribution: baseStyle.leadingDistribution,
        locale: baseStyle.locale,
        foreground: baseStyle.foreground,
        background: baseStyle.background,
        shadows: baseStyle.shadows,
        fontFeatures: baseStyle.fontFeatures,
        fontVariations: baseStyle.fontVariations,
        decoration: baseStyle.decoration,
        decorationColor: baseStyle.decorationColor,
        decorationStyle: baseStyle.decorationStyle,
        decorationThickness: baseStyle.decorationThickness,
        debugLabel: baseStyle.debugLabel,
        fontFamily: baseStyle.fontFamily,
        fontFamilyFallback: baseStyle.fontFamilyFallback,
        overflow: baseStyle.overflow,
      );
}
