import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/extensions.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
  bool useRootNavigator = false,
}) => showDialog<T>(
  context: context,
  builder: builder,
  barrierDismissible: barrierDismissible,
  barrierColor: context.colors.overlay,
  useRootNavigator: useRootNavigator,
);

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
}) => showModalBottomSheet<T>(
  context: context,
  builder: builder,
  barrierColor: context.colors.overlay,
  backgroundColor: Colors.transparent,
  shape: LinearBorder.none,
  isScrollControlled: isScrollControlled,
);

class DialogWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final Widget actions;

  const DialogWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Dialog(
      backgroundColor: colors.layer01,
      elevation: 0,
      shape: LinearBorder.none,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.heading03(title),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  AppText.bodyCompact01(subtitle!, color: colors.textSecondary),
                ],
              ],
            ),
          ),
          if (content != null) content!,
          actions,
        ],
      ),
    );
  }
}
