import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../shared/multi_select_screen_mixin.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bulk_operation_dialog.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/list_with_multi_select_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/magnet_loading_indicator.dart';
import '../widgets/multi_select_bar.dart';
import '../widgets/notification_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/torrent_dialog_builder.dart';
import '../widgets/torrent_item_builder.dart';
import '../widgets/torrent_list_refresh_indicator.dart';
import 'cubit/favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with MultiSelectScreenMixin {
  late final FavoriteCubit _cubit;
  late final SelectionNotifier _selection;

  @override
  SelectionNotifier get selection => _selection;

  @override
  int get torrentCount => _cubit.state.torrents.length;

  @override
  void initState() {
    super.initState();
    _cubit = di<FavoriteCubit>();
    _selection = SelectionNotifier();
    _cubit.load();
  }

  @override
  void dispose() {
    _selection.dispose();
    if (!_cubit.isClosed) _cubit.close();
    super.dispose();
  }

  Widget _buildList(BuildContext context, FavoriteState state) {
    return TorrentListRefreshIndicator(
      selection: _selection,
      onRefresh: () {
        _cubit.load(query: state.query);
        return Future.value();
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80),
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
    FavoriteState state,
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
          loadingIndicator: () => BlocBuilder<FavoriteCubit, FavoriteState>(
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
      child: BlocListener<FavoriteCubit, FavoriteState>(
        listenWhen: (p, c) => p.notification != c.notification,
        listener: (context, state) {
          if (state.notification case final n?) {
            NotificationWidget.notify(context, n);
          }
        },
        child: BlocListener<FavoriteCubit, FavoriteState>(
          listenWhen: (p, c) =>
              p.fetchingMagnetForKey != null && c.fetchingMagnetForKey == null,
          listener: (context, _) => Navigator.of(context).maybePop(),
          child: BlocListener<FavoriteCubit, FavoriteState>(
            listenWhen: (p, c) =>
                p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
            listener: (context, state) {
              if (state.notification?.type != NotificationType.error) {
                _selection.clear();
              }
            },
            child: Column(
              children: [
                const AppBarWidget(title: favorite),
                SearchBarWidget(
                  onSearch: (q) => _cubit.load(query: q),
                  onFetchSuggestions: (q) async => _cubit.load(query: q),
                ),
                Expanded(
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    buildWhen: (p, c) =>
                        p.status != c.status ||
                        p.query != c.query ||
                        p.torrents.length != c.torrents.length ||
                        !identical(p.torrents, c.torrents),
                    builder: (context, state) {
                      return ListenableBuilder(
                        listenable: _selection,
                        builder: (context, _) {
                          final child = switch (state.status) {
                            FavoriteStatus.initial => emptyBox,
                            FavoriteStatus.success =>
                              (state.torrents.isEmpty)
                                  ? EmptyStateWidget(
                                      iconColor: state.query.isEmpty
                                          ? context.colors.tagColorPurple
                                          : context.colors.supportCautionMajor,
                                      emptyState: state.emptyState,
                                      onTap: () =>
                                          _cubit.load(query: state.query),
                                    )
                                  : ListWithMultiSelectLayout(
                                      selection: _selection,
                                      multiSelectBarBuilder:
                                          _buildMultiSelectBar,
                                      listBuilder: (context) =>
                                          _buildList(context, state),
                                    ),
                            FavoriteStatus.error => EmptyStateWidget(
                              emptyState: state.emptyState,
                              iconColor: context.colors.supportError,
                              onTap: () => _cubit.load(query: state.query),
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
          icon: AppAssets.icDelete,
          onTap: () => _showRemoveDialog(context),
        ),
        MultiSelectAction(
          icon: AppAssets.icDownload,
          onTap: () => _showDownloadDialog(context),
        ),
      ],
      onClose: _selection.clear,
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showAppDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<FavoriteCubit, FavoriteState>(
          listenWhen: (p, c) =>
              p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
          listener: (context, state) {
            Navigator.of(dialogContext).maybePop();
          },
          builder: (context, state) {
            return BulkOperationDialog(
              title: areYouSureYouWantToRemoveAllSelectedTorrents,
              confirmButtonText: removeAll,
              onConfirm: state.isBulkOperationInProgress
                  ? null
                  : () => _cubit.removeMultipleFromFavorites(_selection.keys),
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
        child: BlocConsumer<FavoriteCubit, FavoriteState>(
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
