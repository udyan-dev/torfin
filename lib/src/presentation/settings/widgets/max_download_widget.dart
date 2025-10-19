import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/session.dart';
import '../cubit/settings_cubit.dart';
import 'numeric_input_dialog.dart';
import 'settings_list_tile.dart';

class MaxDownloadWidget extends StatelessWidget {
  const MaxDownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsListTile(
        icon: AppAssets.icDownloadMax,
        title: maximumActiveDownloads,
        subtitle: state.downloadQueueSize,
        showEditIcon: true,
        onTap: () => _showDialog(context, state.downloadQueueSize),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, String currentValue) async {
    final result = await NumericInputDialog.show(
      context,
      title: maxDownloads,
      currentValue: currentValue,
    );

    if (result != null && context.mounted) {
      context.read<SettingsCubit>().updateSession(
        SessionBase(downloadQueueSize: result),
      );
    }
  }
}
