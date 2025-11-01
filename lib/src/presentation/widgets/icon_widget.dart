import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const IconWidget({super.key, required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          colorFilter:
              iconColor?.colorFilter ?? context.colors.iconPrimary.colorFilter,
        ),
      ),
    );
  }
}
