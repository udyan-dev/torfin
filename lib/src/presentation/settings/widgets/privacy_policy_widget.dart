import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/string_constants.dart';
import 'package:torfin/src/presentation/settings/widgets/settings_list_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      icon: AppAssets.icPolicy,
      title: privacyPolicy,
      onTap: _launchPrivacyPolicy,
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    if (await canLaunchUrlString(privacyPolicyUrl)) {
      await launchUrlString(privacyPolicyUrl);
    }
  }
}
