import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import 'button_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final EmptyState emptyState;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool center;

  const EmptyStateWidget({
    super.key,
    required this.emptyState,
    this.iconColor,
    this.onTap,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            emptyState.stateIcon,
            alignment: Alignment.centerLeft,
            colorFilter:
                iconColor?.colorFilter ??
                context.colors.iconPrimary.colorFilter,
          ),
          const SizedBox(height: 32),
          AppText.heading03(emptyState.title),
          const SizedBox(height: 16),
          AppText.bodyCompact02(emptyState.description),
          if (emptyState.buttonText.isNotEmpty) ...[
            const SizedBox(height: 32),
            ButtonWidget(onTap: onTap, buttonText: emptyState.buttonText),
          ],
        ],
      ),
    );
  }
}
