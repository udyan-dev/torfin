import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/engine/session.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/content_switcher_widget.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/toggle_widget.dart';
import 'cubit/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = di<SettingsCubit>();
    _cubit.initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (p, c) => p.notification != c.notification,
        listener: (context, state) {
          if (state.notification case final n?) {
            NotificationWidget.notify(context, n);
          }
        },
        child: Column(
          spacing: 16,
          children: [
            const AppBarWidget(title: settings),
            Expanded(
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return ListView.separated(
                    itemCount: _buildSettingsItems(context, state).length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) =>
                        _buildSettingsItems(context, state)[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettingsItems(BuildContext context, SettingsState state) {
    return [
      const _ThemeSwitcherWidget(),
      ToggleWidget(
        label: enableSuggestionsWhileSearching,
        leadingIcon: AppAssets.icSearchSuggestion,
        value: state.enableSuggestions,
        onChanged: (v) => context.read<SettingsCubit>().setEnableSuggestions(v),
      ),
      ToggleWidget(
        label: showNSFWTorrent,
        leadingIcon: AppAssets.icNSFW,
        value: state.nsfw,
        onChanged: (v) => context.read<SettingsCubit>().setNsfw(v),
      ),
      const _SpeedLimitWidget(),
      const _MaxDownloadWidget(),
      const _ResetSettingsWidget(),
      const _InAppRatingWidget(),
    ];
  }
}

class _ThemeSwitcherWidget extends StatelessWidget {
  const _ThemeSwitcherWidget();

  ThemeService get _themeService => di<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeService.themeNotifier,
      builder: (context, themeMode, child) {
        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (child != null) child,
            ContentSwitcherWidget<ThemeEnum>(
              enableBgColor: false,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              items: ThemeEnum.values,
              getItemLabel: (item) => item.title,
              selectedItem: ThemeEnum.values.firstWhere(
                (e) => e.value == themeMode,
                orElse: () => ThemeEnum.system,
              ),
              onChanged: (item) => _themeService.setTheme(item.value),
            ),
          ],
        );
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: AppText.bodyCompact02(chooseYourTheme),
      ),
    );
  }
}

class _SpeedLimitWidget extends StatelessWidget {
  const _SpeedLimitWidget();

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
                  _buildSpeedLimitTile(
                    context,
                    icon: AppAssets.icChevronDown,
                    title: downloadSpeedLimit,
                    value: state.downloadSpeedLimit,
                    dialogTitle: downloadSpeedKbps,
                    enabled: state.enableSpeedLimits,
                    onUpdate: (value) => _updateDownloadSpeed(context, value),
                  ),
                  _buildSpeedLimitTile(
                    context,
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

  Widget _buildSpeedLimitTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required String dialogTitle,
    required bool enabled,
    required ValueChanged<int> onUpdate,
  }) {
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
      subtitle: AppText.label01('$value KBps'),
      trailing: enabled
          ? SvgPicture.asset(
              AppAssets.icEdit,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            )
          : null,
      onTap: enabled
          ? () => _showSpeedLimitDialog(context, dialogTitle, value, onUpdate)
          : null,
    );
  }

  Future<void> _showSpeedLimitDialog(
    BuildContext context,
    String title,
    String currentValue,
    ValueChanged<int> onUpdate,
  ) async {
    String inputValue = currentValue;
    bool isValid = _validateSpeedLimit(currentValue) == null;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DialogWidget(
          title: title,
          content: TextFieldWidget(
            hintText: enterANumber,
            initialValue: currentValue,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            integerOnly: true,
            keyboardType: TextInputType.number,
            validator: _validateSpeedLimit,
            onChange: (value) => inputValue = value,
            onValidationChanged: (valid) => setState(() => isValid = valid),
          ),
          actions: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  backgroundColor: context.colors.buttonSecondary,
                  buttonText: cancel,
                  onTap: Navigator.of(context).pop,
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: isValid ? 1.0 : 0.5,
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonPrimary,
                    buttonText: apply,
                    onTap: isValid
                        ? () => Navigator.of(context).pop(inputValue)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result?.isNotEmpty == true && context.mounted) {
      final speedLimit = int.tryParse(result ?? '');
      if (speedLimit != null) onUpdate(speedLimit);
    }
  }

  String? _validateSpeedLimit(String? value) {
    if (value?.isEmpty != false) return '';
    final intValue = int.tryParse(value ?? '');
    return (intValue != null && intValue > 0) ? null : '';
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

class _MaxDownloadWidget extends StatelessWidget {
  const _MaxDownloadWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -4),
        horizontalTitleGap: 8,
        leading: SvgPicture.asset(
          AppAssets.icDownloadMax,
          width: 20,
          height: 20,
          colorFilter: context.colors.iconPrimary.colorFilter,
        ),
        title: const AppText.bodyCompact02(maximumActiveDownloads),
        subtitle: AppText.label02(state.downloadQueueSize),
        trailing: SvgPicture.asset(
          AppAssets.icEdit,
          width: 20,
          height: 20,
          colorFilter: context.colors.iconPrimary.colorFilter,
        ),
        onTap: () => _showMaxDownloadDialog(
          context,
          maxDownloads,
          state.downloadQueueSize,
          (value) => _updateDownloadQueueSize(context, value),
        ),
      ),
    );
  }

  Future<void> _showMaxDownloadDialog(
    BuildContext context,
    String title,
    String currentValue,
    ValueChanged<int> onUpdate,
  ) async {
    String inputValue = currentValue;
    bool isValid = _validateMaxDownload(currentValue) == null;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DialogWidget(
          title: title,
          content: TextFieldWidget(
            hintText: enterANumber,
            initialValue: currentValue,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            integerOnly: true,
            keyboardType: TextInputType.number,
            validator: _validateMaxDownload,
            onChange: (value) => inputValue = value,
            onValidationChanged: (valid) => setState(() => isValid = valid),
          ),
          actions: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  backgroundColor: context.colors.buttonSecondary,
                  buttonText: cancel,
                  onTap: Navigator.of(context).pop,
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: isValid ? 1.0 : 0.5,
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonPrimary,
                    buttonText: apply,
                    onTap: isValid
                        ? () => Navigator.of(context).pop(inputValue)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result?.isNotEmpty == true && context.mounted) {
      final maxDownload = int.tryParse(result ?? '');
      if (maxDownload != null) onUpdate(maxDownload);
    }
  }

  String? _validateMaxDownload(String? value) {
    if (value?.isEmpty != false) return '';
    final intValue = int.tryParse(value ?? '');
    return (intValue != null && intValue > 0) ? null : '';
  }

  void _updateDownloadQueueSize(BuildContext context, int size) {
    context.read<SettingsCubit>().updateSession(
      SessionBase(downloadQueueSize: size),
    );
  }
}

class _ResetSettingsWidget extends StatelessWidget {
  const _ResetSettingsWidget();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      horizontalTitleGap: 8,
      leading: SvgPicture.asset(
        AppAssets.icReset,
        width: 20,
        height: 20,
        colorFilter: context.colors.iconPrimary.colorFilter,
      ),
      title: const AppText.bodyCompact02(resetTorrentSettings),
      onTap: () => _showResetConfirmationDialog(context),
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
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

class _InAppRatingWidget extends StatelessWidget {
  const _InAppRatingWidget();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      horizontalTitleGap: 8,
      leading: SvgPicture.asset(
        AppAssets.icRating,
        width: 20,
        height: 20,
        colorFilter: context.colors.iconPrimary.colorFilter,
      ),
      title: const AppText.bodyCompact02(rateTheApp),
      onTap: context.read<SettingsCubit>().rateTheApp,
    );
  }
}
