import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/extensions.dart';
import 'coins/coins_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.background,
      title: AppText.heading05(title, color: context.colors.textPrimary),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 14),
      actions: [
        if (actions != null) ...[...?actions, const SizedBox(width: 8)],
        const CoinsWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
