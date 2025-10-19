import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../shared/notification_builders.dart';
import '../../widgets/notification_widget.dart';
import 'settings_list_tile.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      icon: AppAssets.icPolicy,
      title: privacyPolicy,
      onTap: () => _launchPrivacyPolicy(context),
    );
  }

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    try {
      await launchUrlString(privacyPolicyUrl);
    } catch (e) {
      if (context.mounted) {
        NotificationWidget.notify(
          context,
          errorNotification(privacyPolicy, e.toString()),
        );
      }
    }
  }
}
