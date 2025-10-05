import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/theme/app_styles.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/extensions.dart';
import 'package:torfin/core/utils/string_constants.dart';
import 'package:torfin/src/presentation/settings/cubit/settings_cubit.dart';
import 'package:torfin/src/presentation/settings/widgets/settings_list_tile.dart';
import 'package:torfin/src/presentation/widgets/button_widget.dart';
import 'package:torfin/src/presentation/widgets/dialog_widget.dart';

class ResetSettingsWidget extends StatelessWidget {
  const ResetSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      icon: AppAssets.icReset,
      title: resetTorrentSettings,
      onTap: () => _showConfirmationDialog(context),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DialogWidget(
        title: resetTorrentSettings,
        content: const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: AppText.bodyCompact02(areYouSureResetSettings),
        ),
        actions: Row(
          children: [
            Expanded(
              child: ButtonWidget(
                backgroundColor: context.colors.buttonSecondary,
                buttonText: cancel,
                onTap: () => Navigator.of(context).pop(false),
              ),
            ),
            Expanded(
              child: ButtonWidget(
                backgroundColor: context.colors.buttonPrimary,
                buttonText: yes,
                onTap: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<SettingsCubit>().resetTorrentSettings();
    }
  }
}
