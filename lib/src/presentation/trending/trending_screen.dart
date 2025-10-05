import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/content_switcher_widget.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/notification_widget.dart';
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

  Widget _buildList(BuildContext context, TrendingState state) {
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
          return _buildTorrentItem(context, state, torrent);
        },
        separatorBuilder: (_, i) => Divider(
          height: 1,
          thickness: 1,
          color: context.colors.borderSubtle00,
        ),
      ),
    );
  }

  Widget _buildTorrentItem(
    BuildContext context,
    TrendingState state,
    TorrentRes torrent,
  ) {
    return TorrentWidget(
      torrent: torrent,
      isFavorite: state.isFavorite(torrent),
      onSave: () => _cubit.toggleFavorite(torrent),
      onDownload: () => _cubit.downloadTorrent(torrent),
      onDialogClosed: _cubit.cancelMagnetFetch,
      dialogBuilder: (parentContext, dialogContext, t) => BlocProvider.value(
        value: _cubit,
        child: DialogWidget(
          title: t.name,
          actions: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  backgroundColor: dialogContext.colors.buttonSecondary,
                  buttonText: state.isFavorite(torrent) ? remove : save,
                  onTap: () {
                    _cubit.toggleFavorite(torrent);
                    Navigator.of(dialogContext).maybePop();
                  },
                ),
              ),
              Expanded(
                child: ButtonWidget(
                  backgroundColor: dialogContext.colors.buttonPrimary,
                  buttonText: download,
                  onTap: () {
                    _cubit.downloadTorrent(t);
                    if (t.magnet.isNotEmpty) {
                      Navigator.of(dialogContext).maybePop();
                    }
                  },
                  trailing: BlocBuilder<TrendingCubit, TrendingState>(
                    buildWhen: (p, c) =>
                        p.fetchingMagnetForKey != c.fetchingMagnetForKey,
                    builder: (context, s) {
                      return s.fetchingMagnetForKey == t.identityKey
                          ? const LoadingWidget()
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<TrendingCubit, TrendingState>(
        listenWhen: (p, c) => p.notification != c.notification,
        listener: (context, state) {
          if (state.notification case final n?) {
            NotificationWidget.notify(context, n);
          }
        },
        child: BlocListener<TrendingCubit, TrendingState>(
          listenWhen: (p, c) =>
              p.fetchingMagnetForKey != null && c.fetchingMagnetForKey == null,
          listener: (context, _) => Navigator.of(context).maybePop(),
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
                        return _buildList(context, state);
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
        ),
      ),
    );
  }
}
