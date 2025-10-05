import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/app_assets.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showEditIcon = false,
    this.onTap,
    super.key,
  });

  final String icon;
  final String title;
  final String? subtitle;
  final bool showEditIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      horizontalTitleGap: 8,
      leading: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: context.colors.iconPrimary.colorFilter,
      ),
      title: AppText.bodyCompact02(title),
      subtitle: subtitle != null ? AppText.label02(subtitle!) : null,
      trailing: showEditIcon
          ? SvgPicture.asset(
              AppAssets.icEdit,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            )
          : null,
      onTap: onTap,
    );
  }
}
