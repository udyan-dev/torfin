import 'package:flutter/material.dart';
import 'package:torfin/gen/fonts.gen.dart';

enum TextStyleType {
  bodyCompact01,
  bodyCompact02,
  body01,
  body02,
  code01,
  code02,
  label01,
  label02,
  helperText01,
  helperText02,
  legal01,
  legal02,
  heading01,
  heading02,
  heading03,
  heading04,
  heading05,
  heading06,
  heading07,
  headingCompact01,
  headingCompact02,
  lgFluidHeading03,
  lgFluidHeading04,
  lgFluidHeading05,
  lgFluidHeading06,
  lgFluidParagraph01,
  lgFluidQuotation01,
  lgFluidQuotation02,
  lgFluidDisplay01,
  lgFluidDisplay02,
  lgFluidDisplay03,
  lgFluidDisplay04,
  maxFluidHeading03,
  maxFluidHeading04,
  maxFluidHeading05,
  maxFluidHeading06,
  maxFluidParagraph01,
  maxFluidQuotation01,
  maxFluidQuotation02,
  maxFluidDisplay01,
  maxFluidDisplay02,
  maxFluidDisplay03,
  maxFluidDisplay04,
}

class AppStyle {
  AppStyle._();

  static final _instance = _StyleCache._();

  static TextStyle getStyle(TextStyleType type, {Color? color}) {
    final baseStyle = _instance._getBaseStyle(type);
    return color != null ? baseStyle.copyWith(color: color) : baseStyle;
  }
}

class _StyleCache {
  _StyleCache._() {
    _initializeStyles();
  }

  final Map<TextStyleType, TextStyle> _styles = {};

  late final TextStyle _baseIBMPlexSans = TextStyle(
    fontFamily: AppFont.iBMPlexSans,
    overflow: TextOverflow.ellipsis,
  );
  late final TextStyle _baseIBMPlexMono = TextStyle(
    fontFamily: AppFont.iBMPlexMono,
    overflow: TextOverflow.ellipsis,
  );
  late final TextStyle _baseIBMPlexSerif = TextStyle(
    fontFamily: AppFont.iBMPlexSerif,
    overflow: TextOverflow.ellipsis,
  );

  TextStyle _getBaseStyle(TextStyleType type) => _styles[type]!;

  void _initializeStyles() {
    _styles.addAll({
      TextStyleType.bodyCompact01: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.bodyCompact02: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.body01: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.body02: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.code01: _baseIBMPlexMono.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.code02: _baseIBMPlexMono.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.label01: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.label02: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.helperText01: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.helperText02: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.legal01: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.legal02: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.heading01: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.heading02: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.heading03: _baseIBMPlexSans.copyWith(
        fontSize: 20,
        height: 28 / 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.heading04: _baseIBMPlexSans.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.heading05: _baseIBMPlexSans.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.heading06: _baseIBMPlexSans.copyWith(
        fontSize: 42,
        height: 50 / 42,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.heading07: _baseIBMPlexSans.copyWith(
        fontSize: 54,
        height: 64 / 54,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.headingCompact01: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.headingCompact02: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.lgFluidHeading03: _baseIBMPlexSans.copyWith(
        fontSize: 20,
        height: 28 / 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.lgFluidHeading04: _baseIBMPlexSans.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.lgFluidHeading05: _baseIBMPlexSans.copyWith(
        fontSize: 42,
        height: 50 / 42,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.lgFluidHeading06: _baseIBMPlexSans.copyWith(
        fontSize: 42,
        height: 50 / 42,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.lgFluidParagraph01: _baseIBMPlexSans.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.lgFluidQuotation01: _baseIBMPlexSerif.copyWith(
        fontSize: 24,
        height: 30 / 24,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.lgFluidQuotation02: _baseIBMPlexSerif.copyWith(
        fontSize: 42,
        height: 50 / 42,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.lgFluidDisplay01: _baseIBMPlexSans.copyWith(
        fontSize: 54,
        height: 64 / 54,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.lgFluidDisplay02: _baseIBMPlexSans.copyWith(
        fontSize: 54,
        height: 64 / 54,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.lgFluidDisplay03: _baseIBMPlexSans.copyWith(
        fontSize: 60,
        height: 70 / 60,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.lgFluidDisplay04: _baseIBMPlexSans.copyWith(
        fontSize: 92,
        height: 102 / 92,
        letterSpacing: -0.64,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidHeading03: _baseIBMPlexSans.copyWith(
        fontSize: 20,
        height: 28 / 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      TextStyleType.maxFluidHeading04: _baseIBMPlexSans.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidHeading05: _baseIBMPlexSans.copyWith(
        fontSize: 60,
        height: 70 / 60,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidHeading06: _baseIBMPlexSans.copyWith(
        fontSize: 60,
        height: 70 / 60,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.maxFluidParagraph01: _baseIBMPlexSans.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidQuotation01: _baseIBMPlexSerif.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidQuotation02: _baseIBMPlexSerif.copyWith(
        fontSize: 60,
        height: 70 / 60,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidDisplay01: _baseIBMPlexSans.copyWith(
        fontSize: 76,
        height: 86 / 76,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidDisplay02: _baseIBMPlexSans.copyWith(
        fontSize: 76,
        height: 86 / 76,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      TextStyleType.maxFluidDisplay03: _baseIBMPlexSans.copyWith(
        fontSize: 84,
        height: 94 / 84,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      TextStyleType.maxFluidDisplay04: _baseIBMPlexSans.copyWith(
        fontSize: 154,
        height: 164 / 154,
        letterSpacing: -0.96,
        fontWeight: FontWeight.w300,
      ),
    });
  }
}
