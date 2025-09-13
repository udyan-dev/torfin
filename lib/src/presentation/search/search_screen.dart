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
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/sort_widget.dart';
import '../widgets/status_widget.dart';
import '../widgets/torrent_widget.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit = di<SearchCubit>();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (!_cubit.isClosed) {
      _cubit.close();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _cubit.isClosed) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 100) return;

    final state = _cubit.state;
    if (state.canLoadMore && !state.isPaginating && !state.isAutoLoadingMore) {
      _cubit.loadMore();
    }
  }

  void _checkAutoLoadMore(SearchState state) {
    if (!state.canLoadMore ||
        state.torrents.isEmpty ||
        state.isPaginating ||
        state.isAutoLoadingMore) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cubit.isClosed || !_scrollController.hasClients) return;

      final position = _scrollController.position;
      if (position.maxScrollExtent <= 0 && state.canLoadMore) {
        _cubit.loadMore();
      }
    });
  }

  bool _shouldShowShimmer(SearchState state) =>
      state.isShimmer ||
      (state.torrents.isEmpty && state.status == SearchStatus.loading);

  Widget _buildTorrents(BuildContext context, SearchState state) {
    if (state.isEmpty) {
      return EmptyStateWidget(
        iconColor: context.colors.supportCautionMajor,
        emptyState: const EmptyState(
          stateIcon: AppAssets.icNoResultFound,
          title: noResultsFoundTitle,
          description: noResultsFoundDescription,
          buttonText: retry,
        ),
        onTap: _cubit.onRetry,
      );
    }

    return _buildTorrentList(context, state);
  }

  Widget _buildTorrentList(BuildContext context, SearchState state) {
    if (_shouldShowShimmer(state)) {
      return const ShimmerListWidget();
    }
    return RefreshIndicator(
      color: context.colors.interactive,
      backgroundColor: context.colors.background,
      onRefresh: () {
        _cubit.search(search: state.search, isRefresh: true);
        return Future.value();
      },
      child: _buildActualList(context, state),
    );
  }

  Widget _buildTorrentItem(BuildContext context, SearchState state,
      TorrentRes torrent) {
    return TorrentWidget(
      torrent: torrent,
      isFavorite: state.isFavorite(torrent),
      onSave: () => _cubit.toggleFavorite(torrent),
      onDownload: () => _cubit.downloadTorrent(torrent),
      onDialogClosed: _cubit.cancelMagnetFetch,
      dialogBuilder: (parentContext, dialogContext, t) =>
          BlocProvider.value(
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
                      trailing: BlocBuilder<SearchCubit, SearchState>(
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

  Widget _buildActualList(BuildContext context, SearchState state) {
    final itemCount = state.torrents.length + (state.showLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == state.torrents.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: StatusWidget(
              type: StatusType.loading,
              statusMessage: loadingMore,
            ),
          );
        }
        final torrent = state.torrents[index];
        return _buildTorrentItem(context, state, torrent);
      },
      separatorBuilder: (context, index) {
        if (index == state.torrents.length - 1 && state.showLoadingMore) {
          return emptyBox;
        }
        return Divider(
          height: 1,
          thickness: 1,
          color: context.colors.borderSubtle00,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SearchCubit, SearchState>(
        listenWhen: (p, c) => p.notification != c.notification,
        listener: (context, state) {
          if (state.notification case final n?) {
            NotificationWidget.notify(context, n);
          }
        },
        child: BlocListener<SearchCubit, SearchState>(
          listenWhen: (p, c) =>
          p.fetchingMagnetForKey != null && c.fetchingMagnetForKey == null,
          listener: (context, _) => Navigator.of(context).maybePop(),
          child: Column(
            children: [
              AppBarWidget(
                title: search,
                actions: [
                  SortWidget(
                    onSort: (sortType) => _cubit.search(sortType: sortType),
                  ),
                ],
              ),
              SearchBarWidget(
                onSearch: (searchText) => _cubit.search(search: searchText),
                onFetchSuggestions: (query) => _cubit.fetchSuggestions(query),
              ),
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (p, c) =>
                p.categoriesRaw != c.categoriesRaw ||
                    p.selectedCategoryRaw != c.selectedCategoryRaw,
                builder: (context, state) {
                  return CategoryWidget(
                    categories: state.categoriesRaw,
                    selectedRaw: state.selectedCategoryRaw,
                    onCategoryChange: (raw) => _cubit.search(category: raw),
                  );
                },
              ),
              Expanded(
                child: BlocListener<SearchCubit, SearchState>(
                  listenWhen: (p, c) =>
                  c.status == SearchStatus.success && c.canLoadMore,
                  listener: (context, state) => _checkAutoLoadMore(state),
                  child: BlocBuilder<SearchCubit, SearchState>(
                    buildWhen: (previous, current) =>
                    previous.status != current.status ||
                        previous.selectedCategoryRaw !=
                            current.selectedCategoryRaw ||
                        previous.torrents.length != current.torrents.length ||
                        previous.isShimmer != current.isShimmer ||
                        previous.isPaginating != current.isPaginating ||
                        previous.isAutoLoadingMore !=
                            current.isAutoLoadingMore ||
                        !identical(previous.torrents, current.torrents),
                    builder: (context, state) {
                      switch (state.status) {
                        case SearchStatus.initial:
                          return EmptyStateWidget(
                            iconColor: context.colors.interactive,
                            emptyState: const EmptyState(
                              stateIcon: AppAssets.icStartSearch,
                              title: searchTorrentsTitle,
                              description: searchTorrentsDescription,
                            ),
                          );
                        case SearchStatus.loading:
                        case SearchStatus.success:
                          return _buildTorrents(context, state);
                        case SearchStatus.error:
                          return EmptyStateWidget(
                            emptyState: state.emptyState,
                            iconColor: context.colors.supportError,
                            onTap: _cubit.onRetry,
                          );
                      }
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
}
