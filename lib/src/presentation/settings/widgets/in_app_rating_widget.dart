import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/string_constants.dart';
import 'package:torfin/src/presentation/settings/cubit/settings_cubit.dart';
import 'package:torfin/src/presentation/settings/widgets/settings_list_tile.dart';

class InAppRatingWidget extends StatelessWidget {
  const InAppRatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      icon: AppAssets.icRating,
      title: rateTheApp,
      onTap: context.read<SettingsCubit>().rateTheApp,
    );
  }
}
