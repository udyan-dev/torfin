import 'package:flutter/material.dart';

import '../../../core/utils/string_constants.dart';
import '../widgets/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppBarWidget(title: settings),
      ],
    );
  }
}
