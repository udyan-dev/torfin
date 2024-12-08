import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_text.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;

  const AppBarWidget({
    super.key,
    required this.title,
    required this.action,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey(title),
      child: AppBar(
        title: AppText.header(title),
        actions: [if (action != null) action!],
      ),
    );
  }
}
