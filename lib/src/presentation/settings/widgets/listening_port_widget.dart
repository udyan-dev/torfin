import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/session.dart';
import '../cubit/settings_cubit.dart';
import 'numeric_input_dialog.dart';
import 'settings_list_tile.dart';

class ListeningPortWidget extends StatelessWidget {
  const ListeningPortWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsListTile(
        icon: AppAssets.icListeningPort,
        title: listeningPort,
        subtitle: state.peerPort,
        showEditIcon: true,
        onTap: () => _showDialog(context, state.peerPort),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, String currentValue) async {
    final result = await NumericInputDialog.show(
      context,
      title: incomingPort,
      currentValue: currentValue,
    );

    if (result != null && context.mounted) {
      context.read<SettingsCubit>().updateSession(
        SessionBase(peerPort: result),
      );
    }
  }
}
