import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../../core/theme/app_style.dart';
import '../../../../core/utils/app_constant.dart';
import '../../../../gen/assets.gen.dart';
import '../../../data/model/engine/torrent.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/download_item_widget.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/list_widget.dart';
import 'bloc/download_cubit.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _onInit();
  }

  _onInit() async {
    final cubit = context.read<DownloadCubit>();
    await cubit.loadSettings();
    await cubit.fetchTorrents();
    if (cubit.state.torrents.isNotEmpty) {
      cubit.startAutoRefresh();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        AppBarWidget(key: const ValueKey("AppBarWidget")),
        _buildList(context),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: BlocConsumer<DownloadCubit, DownloadState>(
        listenWhen:
            (previous, current) =>
                previous.torrents.isEmpty != current.torrents.isEmpty,
        listener: (context, state) {
          if (state.torrents.isNotEmpty) {
            context.read<DownloadCubit>().startAutoRefresh();
          } else {
            context.read<DownloadCubit>().stopAutoRefresh();
          }
        },
        buildWhen: (previous, current) {
          return previous.status != current.status ||
              previous.displayedTorrents != current.displayedTorrents ||
              previous.torrents.length != current.torrents.length;
        },
        builder: (context, state) {
          if (state.status == DownloadStateEnum.ready &&
              state.torrents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAsset.svg.icEmpty.path),
                  Text(
                    "No Downloads yet!",
                    style: AppStyle.getStyle(TextStyleType.label01),
                  ),
                ],
              ),
            );
          } else if (state.status == DownloadStateEnum.ready) {
            // Group torrents by their status, and separate those with errors
            final Map<TorrentStatus, List<Torrent>> groupedTorrents = {};
            final List<Torrent> failedTorrents = [];

            for (var torrent in state.torrents) {
              if (torrent.errorString.isNotEmpty) {
                failedTorrents.add(torrent); // Add to failure section
              } else {
                groupedTorrents
                    .putIfAbsent(torrent.status, () => [])
                    .add(torrent);
              }
            }

            // Sort the groups by status (optional)
            final sortedGroups =
                groupedTorrents.entries.toList()
                  ..sort((a, b) => a.key.index.compareTo(b.key.index));

            // Add the failure section if there are any failed torrents
            if (failedTorrents.isNotEmpty) {
              sortedGroups.insert(
                0,
                MapEntry(TorrentStatus.stopped, failedTorrents),
              );
            }

            return ListView(
              controller: _scrollController,
              children:
                  sortedGroups.map((entry) {
                    final status = entry.key;
                    final torrents = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.themeColors.backgroundSelected,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            _getStatusSectionTitle(status, torrents.first),
                            style: AppStyle.getStyle(
                              TextStyleType.heading01,
                              color: context.themeColors.textPrimary,
                            ),
                          ),
                        ),
                        ...torrents.map((torrent) {
                          final percent = (torrent.progress) * 100;
                          return DownloadItemWidget(
                            key: ValueKey('torrent-${torrent.hashCode}'),
                            torrent: torrent,
                            percent: percent,
                            downloadCubit: context.read<DownloadCubit>(),
                          );
                        }),
                        const DividerWidget(),
                      ],
                    );
                  }).toList(),
            );
          } else if (state.status == DownloadStateEnum.failure) {
            return const ExceptionWidget();
          }

          return const Center(child: AppConstant.empty);
        },
      ),
    );
  }

  String _getStatusSectionTitle(TorrentStatus status, Torrent torrent) {
    if (torrent.errorString.isNotEmpty) {
      return 'Failed';
    }

    switch (status) {
      case TorrentStatus.downloading:
        return 'Downloading';
      case TorrentStatus.seeding:
        return 'Seeding';
      case TorrentStatus.stopped:
        return 'Paused';
      case TorrentStatus.checking:
        return 'Checking';
      case TorrentStatus.queuedToCheck:
        return 'Queued to Check';
      case TorrentStatus.queuedToDownload:
        return 'Queued to Download';
      case TorrentStatus.queuedToSeed:
        return 'Queued to Seed';
    }
  }
}
