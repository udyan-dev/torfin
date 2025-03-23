import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/gen/assets.gen.dart';

class IconWidget extends StatelessWidget {
  final SvgGenImage? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool enableSplash;
  final Widget? iconWidget;
  final double? iconSize;

  const IconWidget({
    super.key,
    this.icon,
    this.onTap,
    this.iconWidget,
    this.color,
    this.enableSplash = true,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: ValueKey(icon),
      onPressed: onTap,
      style: IconButton.styleFrom(
        highlightColor: enableSplash
            ? context.themeColors.backgroundSelectedHover
            : Colors.transparent,
        splashFactory:
            enableSplash ? InkRipple.splashFactory : NoSplash.splashFactory,
      ),
      icon: iconWidget ??
          SvgPicture.asset(
            icon!.path,
            height: iconSize ?? 24,
            width: iconSize ?? 24,
            colorFilter: color?.colorFilter ??
                context.themeColors.iconPrimary.colorFilter,
          ),
    );
  }
}
