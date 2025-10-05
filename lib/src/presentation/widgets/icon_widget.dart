import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  final Color backgroundColor;

  const IconWidget({
    super.key,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: LinearBorder.none,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(14),
      ),
      child: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: context.colors.iconOnColor.colorFilter,
      ),
    );
  }
}
