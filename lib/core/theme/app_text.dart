import 'package:flutter/material.dart';
import 'package:torfin/gen/fonts.gen.dart';

class AppText extends Text {
  AppText._(
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.overflow,
    super.maxLines,
    Color? color,
  }) : super(style: (style ?? const TextStyle()).copyWith(color: color));

  factory AppText.bodyCompact01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.bodyCompact02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.body01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.body02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Code styles
  factory AppText.code01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexMono.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.code02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexMono.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Label styles
  factory AppText.label01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.label02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Helper text styles
  factory AppText.helperText01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.helperText02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Legal text styles
  factory AppText.legal01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.32,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.legal02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Heading styles
  factory AppText.heading01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w600,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading03(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 20,
        height: 28 / 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading04(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading05(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading06(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 42,
        height: 50 / 42,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.heading07(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 54,
        height: 64 / 54,
        letterSpacing: 0,
        fontWeight: FontWeight.w300,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.headingCompact01(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.16,
        fontWeight: FontWeight.w600,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.headingCompact02(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      data,
      key: key,
      style: _baseIBMPlexSans.copyWith(
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Base text styles
  static final TextStyle _baseIBMPlexSans = TextStyle(
    fontFamily: AppFont.iBMPlexSans,
    overflow: TextOverflow.ellipsis,
  );

  static final TextStyle _baseIBMPlexMono = TextStyle(
    fontFamily: AppFont.iBMPlexMono,
    overflow: TextOverflow.ellipsis,
  );
}
