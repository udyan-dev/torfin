import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/content_switcher_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/sort_widget.dart';
import '../widgets/torrent_widget.dart';
import 'cubit/trending_cubit.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  late final TrendingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = di<TrendingCubit>();
    _cubit.trending(type: TrendingType.day, isRefresh: true);
  }

  @override
  void dispose() {
    if (!_cubit.isClosed) _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Column(
        children: [
          AppBarWidget(
            title: trending,
            actions: [
              SortWidget(
                onSort: (sortType) => _cubit.trending(sortType: sortType),
              ),
            ],
          ),
          ContentSwitcherWidget<TrendingType>(
            items: TrendingType.values,
            getItemLabel: (item) => item.title,
            onChanged: (item) => _cubit.trending(type: item),
          ),
          BlocBuilder<TrendingCubit, TrendingState>(
            buildWhen: (p, c) =>
                p.status != c.status ||
                p.isShimmer != c.isShimmer ||
                p.categoriesRaw != c.categoriesRaw ||
                p.selectedCategoryRaw != c.selectedCategoryRaw,
            builder: (context, state) {
              if (state.isShimmer ||
                  state.status != TrendingStatus.success ||
                  state.categoriesRaw.isEmpty) {
                return emptyBox;
              }
              return CategoryWidget(
                categories: state.categoriesRaw,
                selectedRaw: state.selectedCategoryRaw,
                onCategoryChange: (raw) => _cubit.trending(category: raw),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<TrendingCubit, TrendingState>(
              buildWhen: (p, c) =>
                  p.status != c.status ||
                  p.selectedCategoryRaw != c.selectedCategoryRaw ||
                  p.torrents.length != c.torrents.length ||
                  p.isShimmer != c.isShimmer ||
                  !identical(p.torrents, c.torrents),
              builder: (context, state) {
                switch (state.status) {
                  case TrendingStatus.initial:
                  case TrendingStatus.loading:
                    return const ShimmerListWidget();
                  case TrendingStatus.success:
                    if (state.isEmpty) {
                      return EmptyStateWidget(
                        iconColor: context.colors.supportCautionMajor,
                        emptyState: const EmptyState(
                          stateIcon: AppAssets.icNoResultFound,
                          title: noResultsFoundTitle,
                          description: noResultsFoundDescription,
                          buttonText: retry,
                        ),
                        onTap: () => _cubit.trending(isRefresh: true),
                      );
                    }
                    return RefreshIndicator(
                      color: context.colors.interactive,
                      backgroundColor: context.colors.background,
                      onRefresh: () {
                        _cubit.trending(isRefresh: true);
                        return Future.value();
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.torrents.length,
                        itemBuilder: (context, index) {
                          final torrent = state.torrents[index];
                          return TorrentWidget(
                            torrent: torrent,
                            isFavorite: state.isFavorite(torrent),
                            onSave: () => _cubit.toggleFavorite(torrent),
                          );
                        },
                        separatorBuilder: (_, i) => Divider(
                          height: 1,
                          thickness: 1,
                          color: context.colors.borderSubtle00,
                        ),
                      ),
                    );
                  case TrendingStatus.error:
                    return EmptyStateWidget(
                      emptyState: state.emptyState,
                      iconColor: context.colors.supportError,
                      onTap: () => _cubit.trending(isRefresh: true),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
