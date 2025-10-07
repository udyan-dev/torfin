import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import 'checkbox_widget.dart';
import 'icon_widget.dart';

class MultiSelectBar extends StatelessWidget {
  final bool? selectAllValue;
  final VoidCallback onSelectAllToggle;
  final List<MultiSelectAction> actions;
  final VoidCallback onClose;

  const MultiSelectBar({
    super.key,
    required this.selectAllValue,
    required this.onSelectAllToggle,
    required this.actions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 4.0,
          top: 4.0,
          bottom: 4.0,
        ),
        child: Row(
          spacing: 8,
          children: [
            InkWell(
              onTap: onSelectAllToggle,
              child: Row(
                spacing: 16,
                children: [
                  CheckBoxWidget(
                    tristate: true,
                    onChanged: (_) => onSelectAllToggle(),
                    side: BorderSide(color: context.colors.iconPrimary),
                    activeColor: context.colors.iconPrimary,
                    value: selectAllValue,
                  ),
                  AppText.headingCompact01(
                    selectAll,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            const Spacer(),
            for (final action in actions)
              IconWidget(icon: action.icon, onTap: action.onTap),
            IconWidget(icon: AppAssets.icClose, onTap: onClose),
          ],
        ),
      ),
    );
  }
}

class MultiSelectAction {
  final String icon;
  final VoidCallback onTap;

  const MultiSelectAction({required this.icon, required this.onTap});
}
