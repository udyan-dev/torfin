import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/gen/assets.gen.dart';
import 'package:torfin/src/presentation/widgets/svg_widget.dart';

import '../../../gen/fonts.gen.dart';
import '../pages/home/bloc/home_cubit.dart';
import 'top_indicator.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: ColoredBox(
        color: context.themeColors.background,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (_, state) => state.status == HomeStateEnum.indexChanged,
          builder: (context, state) {
            return TabBar(
              onTap:
                  (index) => context.read<HomeCubit>().onNavigationTap(index),
              labelColor: context.themeColors.textPrimary,
              unselectedLabelColor: context.themeColors.textOnColorDisabled,
              labelStyle: const TextStyle(
                letterSpacing: 0.32,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: AppFont.iBMPlexSans,
              ),
              unselectedLabelStyle: const TextStyle(
                letterSpacing: 0.32,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: AppFont.iBMPlexSans,
              ),
              indicator: TopIndicatorDecoration(
                indicatorHeight: 3,
                indicatorColor: context.themeColors.borderInteractive,
              ),
              labelPadding: const EdgeInsets.only(top: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              dividerHeight: 0,
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              tabs: [
                _TabItem(
                  label: "Trending",
                  icon: AppAsset.svg.icTrending,
                  index: 0,
                ),
                _TabItem(
                  label: "Search",
                  icon: AppAsset.svg.icSearch,
                  index: 1,
                ),
                _TabItem(
                  label: "Favorite",
                  icon: AppAsset.svg.icFavorite,
                  index: 2,
                ),
                _TabItem(
                  label: "Downloads",
                  icon: AppAsset.svg.icDownload,
                  index: 3,
                ),
                _TabItem(
                  label: "Settings",
                  icon: AppAsset.svg.icSetting,
                  index: 4,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final SvgGenImage icon;
  final int index;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    final isSelected = tabController.index == index;

    return Tab(
      key: ValueKey(label),
      child: Column(
        children: [
          _buildIcon(context, icon, isSelected),
          _buildLabel(context, label),
        ],
      ),
    );
  }

  SvgWidget _buildIcon(
    BuildContext context,
    SvgGenImage icon,
    bool isSelected,
  ) {
    return SvgWidget(
      assetPath: icon.path,
      color:
          isSelected
              ? context.themeColors.iconPrimary
              : context.themeColors.iconOnColorDisabled,
      width: 20,
      height: 20,
    );
  }

  Text _buildLabel(BuildContext context, String label) {
    return Text(label);
  }
}
