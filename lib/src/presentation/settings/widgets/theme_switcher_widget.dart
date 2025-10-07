import 'package:flutter/material.dart';

import '../../../../core/bindings/di.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/string_constants.dart';
import '../../widgets/content_switcher_widget.dart';
import '../cubit/settings_cubit.dart';

class ThemeSwitcherWidget extends StatelessWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = di<ThemeService>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeNotifier,
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
              onChanged: (item) => themeService.setTheme(item.value),
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
