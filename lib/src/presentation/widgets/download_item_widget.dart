import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/gen/assets.gen.dart';
import 'package:torfin/src/presentation/widgets/icon_widget.dart';

import '../../../core/theme/app_style.dart';
import '../../data/model/engine/torrent.dart';
import '../pages/download/bloc/download_cubit.dart';

class DownloadItemWidget extends StatelessWidget {
  final Torrent torrent;
  final double percent;
  final DownloadCubit downloadCubit;

  const DownloadItemWidget({
    super.key,
    required this.torrent,
    required this.percent,
    required this.downloadCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          const SizedBox(width: 4),
          _getStatusIcon(context),
          const SizedBox(width: 4),
          Flexible(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  torrent.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.getStyle(
                    TextStyleType.headingCompact01,
                    color: context.themeColors.textPrimary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoColumnWidget(
                      context: context,
                      label1: "Size",
                      value1: _formatSize(torrent.size),
                      label2: "Status",
                      value2: _getTorrentStatusText(),
                    ),
                    _InfoColumnWidget(
                      context: context,
                      label1: "Speed",
                      value1: _formatSpeed(torrent.rateDownload),
                      label2: "Time",
                      value2: _formatETA(torrent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconWidget(
                icon:
                    torrent.status == TorrentStatus.stopped
                        ? AppAsset.svg.icPlay
                        : AppAsset.svg.icPause,
                onTap: () {
                  if (torrent.status == TorrentStatus.stopped) {
                    torrent.start();
                  } else {
                    torrent.stop();
                  }
                },
              ),
              IconWidget(
                icon: AppAsset.svg.icDelete,
                onTap: () {
                  _showDeleteMenu(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleDeleteOption(BuildContext context, DeleteOption option) {
    switch (option) {
      case DeleteOption.keepFile:
        downloadCubit.removeTorrent(torrent, false);
        break;
      case DeleteOption.deleteFiles:
        downloadCubit.removeTorrent(torrent, true);
        break;
    }
  }

  void _showDeleteMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // Calculate the position for the menu
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        offset, // Top-left corner of the delete button
        offset.translate(
          renderBox.size.width,
          renderBox.size.height,
        ), // Bottom-right corner of the delete button
      ),
      Rect.zero, // Screen bounds
    );

    showMenu<DeleteOption>(
      context: context,
      initialValue: null,
      clipBehavior: Clip.hardEdge,
      color: context.themeColors.layer01,
      menuPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: const LinearBorder(),
      elevation: 2,
      position: position,
      items:
          DeleteOption.values.map<PopupMenuItem<DeleteOption>>((option) {
            return PopupMenuItem<DeleteOption>(
              value: option,
              key: ValueKey(option),
              onTap: () {
                _handleDeleteOption(context, option);
              },
              child: Text(
                option.title,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.getStyle(
                  TextStyleType.bodyCompact01,
                  color: context.themeColors.textPrimary,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _getStatusIcon(BuildContext context) {
    if (torrent.errorString.isNotEmpty) {
      Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: torrent.progress,
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            backgroundColor: context.themeColors.borderSubtle00,
            valueColor: AlwaysStoppedAnimation(_getProgressColor(context)),
          ),
          IconWidget(
            icon: AppAsset.svg.icBan,
            color: context.themeColors.supportError,
          ),
        ],
      );
    }

    SvgGenImage icon;
    Color iconColor;

    switch (torrent.status) {
      case TorrentStatus.stopped:
        icon = AppAsset.svg.icPause;
        iconColor = context.themeColors.iconSecondary;
        break;
      case TorrentStatus.checking:
      case TorrentStatus.queuedToCheck:
        icon = AppAsset.svg.icRefresh;
        iconColor = context.themeColors.supportWarning;
        break;
      case TorrentStatus.queuedToDownload:
      case TorrentStatus.queuedToSeed:
        icon = AppAsset.svg.icQueue;
        iconColor = context.themeColors.supportInfo;
        break;
      case TorrentStatus.downloading:
        icon = AppAsset.svg.icDownload;
        iconColor = context.themeColors.supportSuccess;
        break;
      case TorrentStatus.seeding:
        icon = AppAsset.svg.icUpload;
        iconColor = context.themeColors.iconInteractive;
        break;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: torrent.progress,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          backgroundColor: context.themeColors.borderSubtle00,
          valueColor: AlwaysStoppedAnimation(_getProgressColor(context)),
        ),
        IconWidget(icon: icon, color: iconColor),
      ],
    );
  }

  Color _getProgressColor(BuildContext context) {
    if (torrent.errorString.isNotEmpty) {
      return context.themeColors.supportError;
    }

    return switch (torrent.status) {
      TorrentStatus.stopped => context.themeColors.iconSecondary,
      TorrentStatus.queuedToCheck => context.themeColors.supportWarning,
      TorrentStatus.checking => context.themeColors.supportWarning,
      TorrentStatus.queuedToDownload => context.themeColors.supportInfo,
      TorrentStatus.queuedToSeed => context.themeColors.supportInfo,
      TorrentStatus.downloading => context.themeColors.supportSuccess,
      TorrentStatus.seeding => context.themeColors.iconInteractive,
    };
  }

  String _getTorrentStatusText() {
    if (torrent.errorString.isNotEmpty) {
      return 'Failed';
    }

    return switch (torrent.status) {
      TorrentStatus.stopped => 'Paused',
      TorrentStatus.queuedToCheck => 'Queued to check',
      TorrentStatus.checking => 'Checking',
      TorrentStatus.queuedToDownload => 'Queued to download',
      TorrentStatus.queuedToSeed => 'Queued to seed',
      TorrentStatus.downloading => '${percent.floor()}%',
      TorrentStatus.seeding => 'Seeding',
    };
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond == 0) return '0 KB/s';
    if (bytesPerSecond < 1024) return '$bytesPerSecond B/s';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  String _formatETA(Torrent torrent) {
    // If download is complete or paused
    if (torrent.progress >= 1.0 || torrent.status == TorrentStatus.stopped) {
      return '--';
    }

    // If not downloading or speed is 0
    if (torrent.status != TorrentStatus.downloading ||
        torrent.rateDownload == 0) {
      return '∞';
    }

    // Calculate ETA
    final remainingBytes = (torrent.size * (1.0 - torrent.progress)).toInt();
    final secondsRemaining = remainingBytes / torrent.rateDownload;

    if (secondsRemaining < 60) {
      return '${secondsRemaining.ceil()}s';
    } else if (secondsRemaining < 3600) {
      return '${(secondsRemaining / 60).ceil()}m';
    } else if (secondsRemaining < 86400) {
      return '${(secondsRemaining / 3600).ceil()}h';
    } else {
      return '${(secondsRemaining / 86400).ceil()}d';
    }
  }
}

class _InfoColumnWidget extends StatelessWidget {
  final BuildContext context;
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const _InfoColumnWidget({
    required this.context,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _InfoTextWidget(label: label1, value: value1, context: context),
        _InfoTextWidget(label: label2, value: value2, context: context),
      ],
    );
  }
}

class _InfoTextWidget extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _InfoTextWidget({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$label: $value",
      style: AppStyle.getStyle(
        TextStyleType.label01,
        color: context.themeColors.textPrimary,
      ),
    );
  }
}

extension DeleteOptionExtension on DeleteOption {
  String get title {
    switch (this) {
      case DeleteOption.keepFile:
        return 'Keep Files';
      case DeleteOption.deleteFiles:
        return 'Delete Files';
    }
  }
}

enum DeleteOption { keepFile, deleteFiles }
