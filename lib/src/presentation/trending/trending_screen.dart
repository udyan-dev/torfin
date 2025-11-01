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
import '../widgets/content_switcher_widget.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/list_with_multi_select_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/magnet_loading_indicator.dart';
import '../widgets/multi_select_bar.dart';
import '../widgets/notification_widget.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/sort_widget.dart';
import '../widgets/torrent_dialog_builder.dart';
import '../widgets/torrent_item_builder.dart';
import '../widgets/torrent_list_refresh_indicator.dart';
import 'cubit/trending_cubit.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen>
    with MultiSelectScreenMixin {
  late final TrendingCubit _cubit;
  late final SelectionNotifier _selection;

  @override
  SelectionNotifier get selection => _selection;

  @override
  int get torrentCount => _cubit.state.torrents.length;

  @override
  void initState() {
    super.initState();
    _cubit = di<TrendingCubit>();
    _selection = SelectionNotifier();
    _cubit.trending(type: TrendingType.day, isRefresh: true);
  }

  @override
  void dispose() {
    _selection.dispose();
    if (!_cubit.isClosed) _cubit.close();
    super.dispose();
  }

  Widget _buildList(BuildContext context, TrendingState state) {
    return TorrentListRefreshIndicator(
      selection: _selection,
      onRefresh: () {
        _cubit.trending(isRefresh: true);
        return Future.value();
      },
      child: ListView.separated(
        key: ValueKey(state.selectedCategoryRaw),
        padding: const EdgeInsets.only(bottom: 80),
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
    return TorrentItemBuilder(
      torrent: torrent,
      isFavorite: state.isFavorite(torrent),
      onSave: () => _cubit.toggleFavorite(torrent),
      onDownload: () => _cubit.downloadTorrent(torrent, context),
      onDialogClosed: _cubit.cancelMagnetFetch,
      selection: _selection,
      dialogBuilder: (parentContext, dialogContext, t) => BlocProvider.value(
        value: _cubit,
        child: TorrentDialogBuilder(
          torrent: t,
          dialogContext: dialogContext,
          isFavorite: state.isFavorite,
          onToggleFavorite: _cubit.toggleFavorite,
          onDownload: (torrent) =>
              _cubit.downloadTorrent(torrent, dialogContext),
          onShare: (torrent, dialogContext) =>
              _cubit.shareTorrent(torrent, dialogContext),
          fetchingMagnetKey: () => state.fetchingMagnetForKey,
          coinsInfo: oneCoinRequiredToDownload,
          loadingIndicator: () => BlocBuilder<TrendingCubit, TrendingState>(
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
          child: BlocListener<TrendingCubit, TrendingState>(
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
                  onChanged: (item) {
                    _selection.clear();
                    _cubit.trending(type: item);
                  },
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
                      onCategoryChange: (raw) {
                        _selection.clear();
                        _cubit.trending(category: raw);
                      },
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
                      return ListenableBuilder(
                        listenable: _selection,
                        builder: (context, _) {
                          final child = switch (state.status) {
                            TrendingStatus.initial ||
                            TrendingStatus.loading => const ShimmerListWidget(),
                            TrendingStatus.success =>
                              state.isEmpty
                                  ? EmptyStateWidget(
                                      iconColor:
                                          context.colors.supportCautionMajor,
                                      emptyState: const EmptyState(
                                        stateIcon: AppAssets.icNoResultFound,
                                        title: noResultsFoundTitle,
                                        description: noResultsFoundDescription,
                                        buttonText: retry,
                                      ),
                                      onTap: () =>
                                          _cubit.trending(isRefresh: true),
                                    )
                                  : ListWithMultiSelectLayout(
                                      selection: _selection,
                                      multiSelectBarBuilder:
                                          _buildMultiSelectBar,
                                      listBuilder: (context) =>
                                          _buildList(context, state),
                                    ),
                            TrendingStatus.error => EmptyStateWidget(
                              emptyState: state.emptyState,
                              iconColor: context.colors.supportError,
                              onTap: () => _cubit.trending(isRefresh: true),
                            ),
                          };
                          return AnimatedSwitcherWidget(child: child);
                        },
                      );
                    },
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
        child: BlocConsumer<TrendingCubit, TrendingState>(
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
        child: BlocConsumer<TrendingCubit, TrendingState>(
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
