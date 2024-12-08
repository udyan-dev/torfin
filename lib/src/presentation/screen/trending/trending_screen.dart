import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/app_extensions.dart';

import '../../widgets/app_bar_widget.dart';
import '../../widgets/custom_tab_indicator.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final List<String> _tabs = ["Today", "This Week", "This Month"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        key: ValueKey('_trending_app_bar_'),
        title: 'Trending',
        action: IconButton(
            onPressed: () {}, icon: SvgPicture.asset(AppAssets.sortDesc)),
      ),
      body: DefaultTabController(
        key: ValueKey(_tabs),
        length: _tabs.length,
        child: Column(
          children: [
            RepaintBoundary(
              key: ValueKey('_tab_bar_'),
              child: TabBar(
                  indicator: CustomTabIndicator(color: context.textPrimary),
                  labelStyle: context.textPrimary.tabBar,
                  unselectedLabelStyle: context.iconInActive.tabBar,
                  tabs: _tabs
                      .map((item) => Tab(
                            key: ValueKey(item),
                            text: item,
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
