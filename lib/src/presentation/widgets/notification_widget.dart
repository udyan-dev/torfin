import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/string_constants.dart';

enum NotificationType {
  favoriteAdded,
  favoriteRemoved;

  String get icon {
    switch (this) {
      case NotificationType.favoriteAdded:
        return AppAssets.icCheckmark;
      case NotificationType.favoriteRemoved:
        return AppAssets.icError;
    }
  }

  Color bgColor(BuildContext context) {
    switch (this) {
      case NotificationType.favoriteAdded:
        return context.colors.notificationBackgroundSuccess;
      case NotificationType.favoriteRemoved:
        return context.colors.notificationBackgroundError;
    }
  }

  Color iconColor(BuildContext context) {
    switch (this) {
      case NotificationType.favoriteAdded:
        return context.colors.supportSuccess;
      case NotificationType.favoriteRemoved:
        return context.colors.supportError;
    }
  }
}

class AppNotification {
  const AppNotification({
    required this.type,
    required this.message,
    this.title,
    this.onAction,
  });

  final NotificationType type;
  final String message;
  final String? title;
  final VoidCallback? onAction;
}

class NotificationWidget {
  static void notify(BuildContext context, AppNotification notification) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: notification.type.bgColor(context),
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      shape: LinearBorder.none,
      margin: const EdgeInsets.all(16.0),
      content: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 3, color: notification.type.iconColor(context)),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                notification.type.icon,
                width: 20,
                height: 20,
                colorFilter: notification.type.iconColor(context).colorFilter,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.headingCompact01(
                      notification.title ?? emptyString,
                      color: context.colors.textPrimary,
                    ),
                    AppText.bodyCompact01(
                      notification.message,
                      color: context.colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            InkWell(
              onTap: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  AppAssets.icClose,
                  width: 20,
                  height: 20,
                  colorFilter: context.colors.iconPrimary.colorFilter,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
