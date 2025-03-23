import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/theme/app_style.dart';
import '../../../core/utils/app_utility.dart';
import '../../../gen/assets.gen.dart';
import 'icon_widget.dart';

class SortWidget extends StatelessWidget {
  final SortType selectedFilter;
  final Function(SortType) onSort;

  const SortWidget({
    super.key,
    required this.onSort,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return IconWidget(
      icon: AppAsset.svg.icFilter,
      onTap: () => _showFilter(context),
    );
  }

  void _showFilter(BuildContext context) {
    showMenu<SortType>(
      context: context,
      initialValue: selectedFilter,
      clipBehavior: Clip.hardEdge,
      color: context.themeColors.layer01,
      menuPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: const LinearBorder(),
      elevation: 2,
      position: RelativeRect.fromLTRB(double.infinity, 0, 0, 0),
      items:
          SortType.values.map<PopupMenuItem<SortType>>((type) {
            return PopupMenuItem<SortType>(
              value: type,
              key: ValueKey(type),
              onTap: () {
                onSort.call(type);
              },
              child: SizedBox(
                width: getSize(context).width * 0.25,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    if (selectedFilter == type)
                      SvgPicture.asset(
                        AppAsset.svg.icCheck.path,
                        width: 16,
                        height: 16,
                        colorFilter:
                            context.themeColors.iconPrimary.colorFilter,
                      )
                    else
                      const SizedBox(width: 16, height: 16),
                    Text(
                      type.title,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.getStyle(
                        TextStyleType.bodyCompact01,
                        color: context.themeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
