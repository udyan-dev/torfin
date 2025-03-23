import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/theme/app_style.dart';
import '../../../core/utils/app_constant.dart';

class TorrentTypeWidget extends StatelessWidget {
  final Function(TorrentType) onChange;

  const TorrentTypeWidget({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DefaultTabController(
        length: TorrentType.values.length,
        child: SizedBox(
          height: kMinInteractiveDimension,
          child: TabBar(
            dividerColor: context.themeColors.borderSubtle01,
            padding: EdgeInsets.zero,
            indicatorWeight: 2,
            dividerHeight: 1,
            indicatorColor: context.themeColors.borderInteractive,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: AppStyle.getStyle(
              TextStyleType.headingCompact01,
              color: context.themeColors.textPrimary,
            ),
            unselectedLabelStyle: AppStyle.getStyle(
              TextStyleType.bodyCompact01,
              color: context.themeColors.textSecondary,
            ),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs:
                TorrentType.values
                    .map((type) => Tab(key: ValueKey(type), text: type.title))
                    .toList(),
            onTap:
                (value) => onChange.call(TorrentType.values.elementAt(value)),
          ),
        ),
      ),
    );
  }
}
