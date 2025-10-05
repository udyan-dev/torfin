import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/string_constants.dart';
import 'package:torfin/src/presentation/settings/widgets/settings_list_tile.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsListTile(
      icon: AppAssets.icLogo,
      title: appVersion,
      subtitle: appVersionNumber,
    );
  }
}
