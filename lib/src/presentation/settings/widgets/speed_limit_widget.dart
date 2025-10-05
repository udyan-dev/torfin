import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/theme/app_styles.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/extensions.dart';
import 'package:torfin/core/utils/string_constants.dart';
import 'package:torfin/src/data/engine/session.dart';
import 'package:torfin/src/presentation/settings/cubit/settings_cubit.dart';
import 'package:torfin/src/presentation/settings/widgets/numeric_input_dialog.dart';
import 'package:torfin/src/presentation/widgets/toggle_widget.dart';

class SpeedLimitWidget extends StatelessWidget {
  const SpeedLimitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleWidget(
            label: enableSpeedLimits,
            description: streamingMightNotWorkCorrectly,
            leadingIcon: AppAssets.icMeter,
            value: state.enableSpeedLimits,
            onChanged: (v) => _updateSpeedLimitEnabled(context, v),
          ),
          AnimatedOpacity(
            opacity: state.enableSpeedLimits ? 1 : 0.5,
            duration: Durations.medium2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  _SpeedLimitTile(
                    icon: AppAssets.icChevronDown,
                    title: downloadSpeedLimit,
                    value: state.downloadSpeedLimit,
                    dialogTitle: downloadSpeedKbps,
                    enabled: state.enableSpeedLimits,
                    onUpdate: (value) => _updateDownloadSpeed(context, value),
                  ),
                  _SpeedLimitTile(
                    icon: AppAssets.icChevronUp,
                    title: uploadSpeedLimit,
                    value: state.uploadSpeedLimit,
                    dialogTitle: uploadSpeedKbps,
                    enabled: state.enableSpeedLimits,
                    onUpdate: (value) => _updateUploadSpeed(context, value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateSpeedLimitEnabled(BuildContext context, bool enabled) {
    context.read<SettingsCubit>().updateSession(
      SessionBase(speedLimitDownEnabled: enabled, speedLimitUpEnabled: enabled),
    );
  }

  void _updateDownloadSpeed(BuildContext context, int speed) {
    context.read<SettingsCubit>().updateSession(
      SessionBase(speedLimitDown: speed),
    );
  }

  void _updateUploadSpeed(BuildContext context, int speed) {
    context.read<SettingsCubit>().updateSession(
      SessionBase(speedLimitUp: speed),
    );
  }
}

class _SpeedLimitTile extends StatelessWidget {
  const _SpeedLimitTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.dialogTitle,
    required this.enabled,
    required this.onUpdate,
  });

  final String icon;
  final String title;
  final String value;
  final String dialogTitle;
  final bool enabled;
  final ValueChanged<int> onUpdate;

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
      title: AppText.label02(title),
      subtitle: AppText.label01('$value $speedUnitKBps'),
      trailing: enabled
          ? SvgPicture.asset(
              AppAssets.icEdit,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            )
          : null,
      onTap: enabled ? () => _showDialog(context) : null,
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final result = await NumericInputDialog.show(
      context,
      title: dialogTitle,
      currentValue: value,
    );

    if (result != null && context.mounted) {
      onUpdate(result);
    }
  }
}
