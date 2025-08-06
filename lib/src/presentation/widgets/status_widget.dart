import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import 'loading_widget.dart';

enum StatusType {
  loading(''),
  error(AppAssets.icError),
  warning(AppAssets.icCaution),
  success(AppAssets.icCheckmark);

  const StatusType(this.icon);

  final String icon;

  Color getStatusColor(AppColors colors) => switch (this) {
    StatusType.error => colors.statusRed,
    StatusType.warning => colors.statusOrange,
    StatusType.success => colors.statusGreen,
    StatusType.loading => colors.statusBlue,
  };
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    this.type = StatusType.success,
    this.statusMessage = '',
  });

  final StatusType type;
  final String statusMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          type == StatusType.loading
              ? const LoadingWidget()
              : SvgPicture.asset(
                  type.icon,
                  width: 16.0,
                  height: 16.0,
                  colorFilter: type.getStatusColor(context.colors).colorFilter,
                ),
          if (statusMessage.isNotEmpty)
            AppText.label01(statusMessage, color: context.colors.textSecondary),
        ],
      ),
    );
  }
}
