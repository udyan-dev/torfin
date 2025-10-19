import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/toggle_widget.dart';
import 'cubit/settings_cubit.dart';
import 'widgets/app_version_widget.dart';
import 'widgets/in_app_rating_widget.dart';
import 'widgets/listening_port_widget.dart';
import 'widgets/max_download_widget.dart';
import 'widgets/privacy_policy_widget.dart';
import 'widgets/reset_settings_widget.dart';
import 'widgets/speed_limit_widget.dart';
import 'widgets/theme_switcher_widget.dart';

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
                builder: (context, state) => ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _buildSettingsItems(context, state).length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _buildSettingsItems(context, state)[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettingsItems(BuildContext context, SettingsState state) {
    return [
      const ThemeSwitcherWidget(),
      ToggleWidget(
        label: enableSuggestionsWhileSearching,
        leadingIcon: AppAssets.icSearchSuggestion,
        value: state.enableSuggestions,
        onChanged: context.read<SettingsCubit>().setEnableSuggestions,
      ),
      ToggleWidget(
        label: showNSFWTorrent,
        leadingIcon: AppAssets.icNSFW,
        value: state.nsfw,
        onChanged: context.read<SettingsCubit>().setNsfw,
      ),
      const SpeedLimitWidget(),
      const MaxDownloadWidget(),
      const ListeningPortWidget(),
      const ResetSettingsWidget(),
      const InAppRatingWidget(),
      const PrivacyPolicyWidget(),
      const AppVersionWidget(),
    ];
  }
}
