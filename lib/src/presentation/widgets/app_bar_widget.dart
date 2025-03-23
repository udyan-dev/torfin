import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/theme/app_style.dart';

class AppBarWidget extends StatelessWidget {
  final Widget? actionWidget;

  const AppBarWidget({super.key, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kMinInteractiveDimension,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: context.themeColors.background,
      backgroundColor: context.themeColors.background,
      clipBehavior: Clip.hardEdge,
      title: Text(
        "TORFIN",
        style: AppStyle.getStyle(
          TextStyleType.headingCompact01,
          color: context.themeColors.textPrimary,
        ).copyWith(fontSize: 18),
      ),
      actions: [if (actionWidget != null) actionWidget!],
    );
  }
}
