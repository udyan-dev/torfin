import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bulk_operation_dialog.dart';
import '../widgets/button_widget.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/multi_select_bar.dart';
import '../widgets/notification_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/torrent_widget.dart';
import 'cubit/favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late final FavoriteCubit _cubit;
  late final SelectionNotifier _selection;

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
    return RefreshIndicator(
      color: context.colors.interactive,
      backgroundColor: context.colors.background,
      onRefresh: () {
        if (_selection.isActive) {
          return Future.value();
        }
        _cubit.load(query: state.query);
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
    FavoriteState state,
    TorrentRes torrent,
  ) {
    final key = torrent.identityKey;
    final isSelected = _selection.isSelected(key);

    return InkWell(
      onTap: _selection.isActive ? () => _selection.toggle(key) : null,
      onLongPress: () => _selection.toggle(key),
      child: IgnorePointer(
        ignoring: _selection.isActive,
        child: TorrentWidget(
          torrent: torrent,
          isFavorite: state.isFavorite(torrent),
          onSave: () => _cubit.toggleFavorite(torrent),
          onDownload: () => _cubit.downloadTorrent(torrent),
          onDialogClosed: _cubit.cancelMagnetFetch,
          showCheckbox: _selection.isActive,
          isSelected: isSelected,
          onCheckboxTap: () => _selection.toggle(key),
          dialogBuilder: (parentContext, dialogContext, t) =>
              _buildDialog(t, dialogContext, state, torrent),
        ),
      ),
    );
  }

  Widget _buildDialog(
    TorrentRes t,
    BuildContext dialogContext,
    FavoriteState state,
    TorrentRes torrent,
  ) {
    return BlocProvider.value(
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
                trailing: BlocBuilder<FavoriteCubit, FavoriteState>(
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
    );
  }

  void _selectAll() {
    final keys = _cubit.state.torrents.map((t) => t.identityKey);
    _selection.addAll(keys);
  }

  bool? _getSelectAllValue() {
    final totalCount = _cubit.state.torrents.length;
    final selectedCount = _selection.count;
    if (selectedCount == 0) return false;
    if (selectedCount == totalCount) return true;
    return null;
  }

  void _toggleSelectAll() {
    final value = _getSelectAllValue();
    if (value == true) {
      _selection.clear();
    } else {
      _selectAll();
    }
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
                                  : Column(
                                      children: [
                                        if (_selection.isActive)
                                          _buildMultiSelectBar(context),
                                        Expanded(
                                          child: _buildList(context, state),
                                        ),
                                      ],
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
      selectAllValue: _getSelectAllValue(),
      onSelectAllToggle: _toggleSelectAll,
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
            return BulkOperationDialog(
              title: areYouSureYouWantToDownloadAllSelectedTorrents,
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
