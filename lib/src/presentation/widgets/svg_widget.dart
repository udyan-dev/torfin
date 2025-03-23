import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/app_extension.dart';

class SvgWidget extends StatelessWidget {
  final String assetPath;
  final Color? color;
  final double? width;
  final double? height;

  const SvgWidget({
    super.key,
    required this.assetPath,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: color?.colorFilter,
    );
  }
}
