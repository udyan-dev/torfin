import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';

class TagWidget extends StatelessWidget {
  final Color tagColor;
  final Color tagBackgroundColor;
  final Color tagHoverColor;
  final String tagIcon;
  final String tagText;
  final VoidCallback onTap;

  const TagWidget({
    super.key,
    required this.tagText,
    required this.tagColor,
    required this.tagBackgroundColor,
    required this.tagHoverColor,
    required this.onTap,
    this.tagIcon = AppAssets.icClose,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(1000),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tagBackgroundColor,
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 7.0,
              ),
              child: AppText.label02(tagText, color: tagColor),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: tagHoverColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  tagIcon,
                  width: 16,
                  height: 16,
                  colorFilter: tagColor.colorFilter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
