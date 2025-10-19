import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../shared/multi_select_screen_mixin.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bulk_operation_dialog.dart';
import '../widgets/category_widget.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/list_with_multi_select_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/magnet_loading_indicator.dart';
import '../widgets/multi_select_bar.dart';
import '../widgets/notification_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/sort_widget.dart';
import '../widgets/status_widget.dart';
import '../widgets/torrent_dialog_builder.dart';
import '../widgets/torrent_item_builder.dart';
import '../widgets/torrent_list_refresh_indicator.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with MultiSelectScreenMixin {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  late final SelectionNotifier _selection;

  @override
  SelectionNotifier get selection => _selection;

  @override
  int get torrentCount => _cubit.state.torrents.length;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit = di<SearchCubit>();
    _selection = SelectionNotifier();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.initializeWithAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _selection.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _cubit.isClosed) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent) return;

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

    return ListWithMultiSelectLayout(
      selection: _selection,
      multiSelectBarBuilder: _buildMultiSelectBar,
      listBuilder: (context) => _buildTorrentList(context, state),
    );
  }

  Widget _buildTorrentList(BuildContext context, SearchState state) {
    if (_shouldShowShimmer(state)) {
      return const ShimmerListWidget();
    }
    return TorrentListRefreshIndicator(
      selection: _selection,
      onRefresh: () {
        _cubit.search(search: state.search, isRefresh: true);
        return Future.value();
      },
      child: _buildActualList(context, state),
    );
  }

  Widget _buildTorrentItem(
    BuildContext context,
    SearchState state,
    TorrentRes torrent,
  ) {
    return TorrentItemBuilder(
      torrent: torrent,
      isFavorite: state.isFavorite(torrent),
      onSave: () => _cubit.toggleFavorite(torrent),
      onDownload: () => _cubit.downloadTorrent(torrent),
      onDialogClosed: _cubit.cancelMagnetFetch,
      selection: _selection,
      dialogBuilder: (parentContext, dialogContext, t) => BlocProvider.value(
        value: _cubit,
        child: TorrentDialogBuilder(
          torrent: t,
          dialogContext: dialogContext,
          isFavorite: state.isFavorite,
          onToggleFavorite: _cubit.toggleFavorite,
          onDownload: _cubit.downloadTorrent,
          fetchingMagnetKey: () => state.fetchingMagnetForKey,
          coinsInfo: oneCoinRequiredToDownload,
          loadingIndicator: () => BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (p, c) =>
                p.fetchingMagnetForKey != c.fetchingMagnetForKey,
            builder: (context, s) => MagnetLoadingIndicator(
              torrentIdentityKey: t.identityKey,
              fetchingMagnetKey: () => s.fetchingMagnetForKey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActualList(BuildContext context, SearchState state) {
    final itemCount = state.torrents.length + (state.showLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
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
          child: BlocListener<SearchCubit, SearchState>(
            listenWhen: (p, c) =>
                p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
            listener: (context, state) {
              if (state.notification?.type != NotificationType.error) {
                _selection.clear();
              }
            },
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
                      p.status != c.status ||
                      p.isShimmer != c.isShimmer ||
                      p.categoriesRaw != c.categoriesRaw ||
                      p.selectedCategoryRaw != c.selectedCategoryRaw,
                  builder: (context, state) {
                    if (state.isShimmer ||
                        state.status != SearchStatus.success ||
                        state.categoriesRaw.isEmpty) {
                      return emptyBox;
                    }
                    return CategoryWidget(
                      categories: state.categoriesRaw,
                      selectedRaw: state.selectedCategoryRaw,
                      onCategoryChange: (raw) {
                        _selection.clear();
                        _cubit.search(category: raw);
                      },
                    );
                  },
                ),
                Expanded(
                  child: BlocListener<SearchCubit, SearchState>(
                    listenWhen: (p, c) =>
                        p.selectedCategoryRaw != c.selectedCategoryRaw &&
                        c.selectedCategoryRaw != null,
                    listener: (context, state) {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(0);
                      }
                    },
                    child: BlocListener<SearchCubit, SearchState>(
                      listenWhen: (p, c) =>
                          c.status == SearchStatus.success && c.canLoadMore,
                      listener: (context, state) => _checkAutoLoadMore(state),
                      child: BlocBuilder<SearchCubit, SearchState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status ||
                            previous.selectedCategoryRaw !=
                                current.selectedCategoryRaw ||
                            previous.torrents.length !=
                                current.torrents.length ||
                            previous.isShimmer != current.isShimmer ||
                            previous.isPaginating != current.isPaginating ||
                            previous.isAutoLoadingMore !=
                                current.isAutoLoadingMore ||
                            !identical(previous.torrents, current.torrents),
                        builder: (context, state) => AnimatedSwitcherWidget(
                          child: switch (state.status) {
                            SearchStatus.initial => emptyBox,
                            SearchStatus.loading => _buildTorrents(
                              context,
                              state,
                            ),
                            SearchStatus.success =>
                              state.search.isEmpty && state.torrents.isEmpty
                                  ? EmptyStateWidget(
                                      iconColor: context.colors.interactive,
                                      emptyState: const EmptyState(
                                        stateIcon: AppAssets.icStartSearch,
                                        title: searchTorrentsTitle,
                                        description: searchTorrentsDescription,
                                      ),
                                    )
                                  : _buildTorrents(context, state),
                            SearchStatus.error => EmptyStateWidget(
                              emptyState: state.emptyState,
                              iconColor: context.colors.supportError,
                              onTap: _cubit.onRetry,
                            ),
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectBar(BuildContext context) {
    return MultiSelectBar(
      selectAllValue: getSelectAllValue(),
      onSelectAllToggle: () =>
          toggleSelectAll(_cubit.state.torrents.map((t) => t.identityKey)),
      selectedCount: _selection.count,
      actions: [
        MultiSelectAction(
          icon: AppAssets.icFavorite,
          onTap: () => _showSaveDialog(context),
        ),
        MultiSelectAction(
          icon: AppAssets.icDownload,
          onTap: () => _showDownloadDialog(context),
        ),
      ],
      onClose: _selection.clear,
    );
  }

  void _showSaveDialog(BuildContext context) {
    showAppDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<SearchCubit, SearchState>(
          listenWhen: (p, c) =>
              p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
          listener: (context, state) {
            Navigator.of(dialogContext).maybePop();
          },
          builder: (context, state) {
            return BulkOperationDialog(
              title: areYouSureYouWantToSaveAllSelectedTorrents,
              confirmButtonText: saveAll,
              onConfirm: state.isBulkOperationInProgress
                  ? null
                  : () => _cubit.addMultipleToFavorites(_selection.keys),
              trailing: state.isBulkOperationInProgress
                  ? const LoadingWidget()
                  : null,
            );
          },
        ),
      ),
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showAppDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<SearchCubit, SearchState>(
          listenWhen: (p, c) =>
              p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
          listener: (context, state) {
            Navigator.of(dialogContext).maybePop();
          },
          builder: (context, state) {
            final coinsCount = _selection.count;
            final coinText = coinsCount == 1
                ? coinRequiredToDownload
                : coinsRequiredToDownload;
            return BulkOperationDialog(
              title: areYouSureYouWantToDownloadAllSelectedTorrents,
              subtitle: '$coinsCount $coinText',
              confirmButtonText: downloadAll,
              onConfirm: state.isBulkOperationInProgress
                  ? null
                  : () => _cubit.downloadMultipleTorrents(_selection.keys),
              onCancel: state.isBulkOperationInProgress
                  ? () {
                      _cubit.cancelMagnetFetch();
                      Navigator.of(dialogContext).maybePop();
                    }
                  : null,
              trailing: state.isBulkOperationInProgress
                  ? const LoadingWidget()
                  : null,
            );
          },
        ),
      ),
    );
  }
}
