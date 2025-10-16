import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bulk_operation_dialog.dart';
import '../widgets/category_widget.dart';
import '../widgets/checkbox_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/multi_select_bar.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/torrent_download_widget.dart';
import '../widgets/dialog_widget.dart';
import '../shared/notification_builders.dart';
import '../widgets/notification_widget.dart';

import 'cubit/download_cubit.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late final DownloadCubit _downloadCubit;
  late final SelectionNotifier _selection;

  @override
  void initState() {
    super.initState();
    _downloadCubit = di<DownloadCubit>();
    _selection = SelectionNotifier();
  }

  @override
  void dispose() {
    _downloadCubit.close();
    _selection.dispose();
    super.dispose();
  }

  void _selectAll() {
    final state = _downloadCubit.state;
    final allKeys = state.torrents.map((t) => t.id.toString()).toSet();
    _selection.addAll(allKeys);
  }

  bool? _getSelectAllValue() {
    final state = _downloadCubit.state;
    if (state.torrents.isEmpty) return false;
    final allKeys = state.torrents.map((t) => t.id.toString()).toSet();
    final selectedCount = _selection.keys.where(allKeys.contains).length;
    if (selectedCount == 0) return false;
    if (selectedCount == allKeys.length) return true;
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

  Widget _buildTorrentItem(
    BuildContext context,
    DownloadState state,
    int index,
  ) {
    final torrent = state.torrents[index];
    final key = torrent.id.toString();
    final isSelected = _selection.isSelected(key);

    return TorrentDownloadWidget(
      torrent: torrent,
      showCheckbox: _selection.isActive,
      isSelected: isSelected,
      onCheckboxTap: () => _selection.toggle(key),
      onTap: _selection.isActive ? () => _selection.toggle(key) : null,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _selection.toggle(key);
      },
    );
  }

  Widget _buildTorrentList(DownloadState state) => ListView.separated(
    itemCount: state.torrents.length,
    itemBuilder: (_, i) => _buildTorrentItem(context, state, i),
    separatorBuilder: (context, _) =>
        Divider(height: 1, thickness: 1, color: context.colors.borderSubtle00),
  );

  Widget _buildMultiSelectBar(BuildContext context) {
    return MultiSelectBar(
      selectAllValue: _getSelectAllValue(),
      onSelectAllToggle: _toggleSelectAll,
      selectedCount: _selection.count,
      actions: [
        MultiSelectAction(
          icon: AppAssets.icDelete,
          onTap: () => _showDeleteDialog(context),
        ),
      ],
      onClose: _selection.clear,
    );
  }

  Widget _buildKeepFilesCheckbox(
    BuildContext context,
    ValueNotifier<bool> keepFiles,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: keepFiles,
      builder: (context, checked, _) => Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Row(
          spacing: 8,
          children: [
            CheckBoxWidget(
              value: checked,
              side: BorderSide(color: context.colors.iconPrimary),
              activeColor: context.colors.iconPrimary,
              onChanged: (v) => keepFiles.value = v ?? false,
            ),
            AppText.bodyCompact01(
              keepFilesAndRemoveTorrentOnly,
              color: context.colors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final keepFiles = ValueNotifier<bool>(false);
    var toDeleteCount = 0;
    showAppDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: _downloadCubit,
        child: BlocConsumer<DownloadCubit, DownloadState>(
          listenWhen: (p, c) =>
              p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
          listener: (context, state) {
            Navigator.of(dialogContext).maybePop();
            NotificationWidget.notify(
              dialogContext,
              bulkDeleteSuccessNotification(toDeleteCount),
            );
          },
          builder: (context, state) {
            return BulkOperationDialog(
              title: areYouSureYouWantToDeleteAllSelectedTorrents,
              confirmButtonText: delete,
              onConfirm: state.isBulkOperationInProgress
                  ? null
                  : () {
                      final ids = _selection.keys
                          .map((k) => int.tryParse(k))
                          .whereType<int>()
                          .toSet();
                      toDeleteCount = ids.length;
                      _downloadCubit.removeMultipleTorrents(
                        ids,
                        keepFiles.value,
                      );
                    },
              trailing: state.isBulkOperationInProgress
                  ? const LoadingWidget()
                  : null,
              content: _buildKeepFilesCheckbox(context, keepFiles),
            );
          },
        ),
      ),
    );
  }

  EmptyState _getEmptyStateForCategory(String? categoryRaw) =>
      switch (categoryRaw) {
        allTitle => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: noDownloadsYet,
          description: startDownloadingTorrents,
        ),
        downloadingTitle => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: nothingDownloading,
        ),
        completedTitle => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: nothingCompleted,
        ),
        queuedTitle => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: nothingQueued,
        ),
        stoppedTitle => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: nothingStopped,
        ),
        _ => const EmptyState(
          stateIcon: AppAssets.icAddDownload,
          title: noDownloadsYet,
          description: startDownloadingTorrents,
        ),
      };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _downloadCubit..initialize(),
      child: BlocListener<DownloadCubit, DownloadState>(
        listenWhen: (p, c) =>
            p.isBulkOperationInProgress && !c.isBulkOperationInProgress,
        listener: (context, state) {
          _selection.clear();
        },
        child: Column(
          children: [
            const AppBarWidget(title: downloads),
            BlocBuilder<DownloadCubit, DownloadState>(
              builder: (context, state) {
                return CategoryWidget(
                  categories: TorrentDownloadStatus.values
                      .map((e) => e.title)
                      .toList(),
                  selectedRaw: state.selectedCategoryRaw,
                  onCategoryChange: (String? raw) {
                    context.read<DownloadCubit>().setFilterRaw(raw);
                  },
                );
              },
            ),
            Expanded(
              child: BlocBuilder<DownloadCubit, DownloadState>(
                builder: (context, state) {
                  return ListenableBuilder(
                    listenable: _selection,
                    builder: (context, _) {
                      final child = switch (state.status) {
                        DownloadStatus.initial => emptyBox,
                        DownloadStatus.success =>
                          state.torrents.isEmpty
                              ? EmptyStateWidget(
                                  iconColor: context.colors.supportSuccess,
                                  emptyState: _getEmptyStateForCategory(
                                    state.selectedCategoryRaw,
                                  ),
                                )
                              : Column(
                                  children: [
                                    if (_selection.isActive)
                                      _buildMultiSelectBar(context),
                                    Expanded(child: _buildTorrentList(state)),
                                  ],
                                ),
                        DownloadStatus.error => EmptyStateWidget(
                          iconColor: context.colors.supportError,
                          emptyState: const EmptyState(
                            stateIcon: AppAssets.icAddDownload,
                            title: somethingWentWrong,
                          ),
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
    );
  }
}
