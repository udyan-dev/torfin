import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extensions.dart';

enum AppTextStyle {
  header,
  normal,
  small,
}

class AppText extends StatelessWidget {
  const AppText._(
    this.text, {
    this.textAlign,
    required this.appTextStyle,
    this.textOverflow,
    this.maxLine,
    this.color,
  });

  factory AppText.normal(
    String text, {
    TextOverflow? textOverflow,
    int? maxLine,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText._(
      text,
      appTextStyle: AppTextStyle.normal,
      textAlign: textAlign,
      textOverflow: textOverflow,
      maxLine: maxLine,
      color: color,
    );
  }

  factory AppText.small(
    String text, {
    TextOverflow? textOverflow,
    int? maxLine,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText._(
      text,
      appTextStyle: AppTextStyle.small,
      textAlign: textAlign,
      textOverflow: textOverflow,
      maxLine: maxLine,
      color: color,
    );
  }

  factory AppText.header(
    String text, {
    TextOverflow? textOverflow,
    int? maxLine,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText._(
      text,
      appTextStyle: AppTextStyle.header,
      textAlign: textAlign,
      textOverflow: textOverflow,
      maxLine: maxLine,
      color: color,
    );
  }

  final String text;
  final AppTextStyle appTextStyle;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final TextAlign? textAlign;
  final Color? color;

  TextStyle getTextStyle(BuildContext context) {
    TextStyle textStyle;
    switch (appTextStyle) {
      case AppTextStyle.normal:
        textStyle = TextStyle(
          color: context.textPrimary,
          fontWeight: FontWeight.normal,
        );
        break;
      case AppTextStyle.small:
        textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: context.textPrimary,
        );
        break;
      case AppTextStyle.header:
        textStyle = TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: context.textPrimary,
        );
    }

    return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = getTextStyle(context);
    return Text(
      key: ValueKey(text),
      text,
      style: color != null ? textStyle.copyWith(color: color) : textStyle,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLine,
    );
  }
}
