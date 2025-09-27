import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/torrent_download_widget.dart';
import 'cubit/download_cubit.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late final DownloadCubit _downloadCubit;

  @override
  void initState() {
    super.initState();
    _downloadCubit = di<DownloadCubit>();
  }

  @override
  void dispose() {
    _downloadCubit.close();
    super.dispose();
  }

  Widget _buildTorrentList(DownloadState state) => ListView.separated(
    itemCount: state.torrents.length,
    itemBuilder: (_, i) => TorrentDownloadWidget(torrent: state.torrents[i]),
    separatorBuilder: (context, _) =>
        Divider(height: 1, thickness: 1, color: context.colors.borderSubtle00),
  );

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
              builder: (context, state) => AnimatedSwitcherWidget(
                child: switch (state.status) {
                  DownloadStatus.initial => emptyBox,
                  DownloadStatus.success =>
                    state.torrents.isEmpty
                        ? EmptyStateWidget(
                            iconColor: context.colors.supportSuccess,
                            emptyState: _getEmptyStateForCategory(
                              state.selectedCategoryRaw,
                            ),
                          )
                        : _buildTorrentList(state),
                  DownloadStatus.error => EmptyStateWidget(
                    iconColor: context.colors.supportError,
                    emptyState: const EmptyState(
                      stateIcon: AppAssets.icAddDownload,
                      title: somethingWentWrong,
                    ),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
