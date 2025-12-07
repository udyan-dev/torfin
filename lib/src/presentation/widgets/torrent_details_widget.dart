import 'package:collection/collection.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:pretty_bytes/pretty_bytes.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/engine/torrent.dart';
import '../download/cubit/download_cubit.dart';
import '../shared/notification_builders.dart';
import 'button_widget.dart';
import 'checkbox_widget.dart';
import 'dialog_widget.dart';
import 'icon_widget.dart';
import 'notification_widget.dart';

class TorrentDetailsWidget extends StatefulWidget {
  final Torrent torrent;

  const TorrentDetailsWidget({super.key, required this.torrent});

  @override
  State<TorrentDetailsWidget> createState() => _TorrentDetailsWidgetState();
}

class _TorrentDetailsWidgetState extends State<TorrentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ColoredBox(
          color: context.colors.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TorrentDetailsHeaderWidget(torrent: widget.torrent),
              Flexible(
                child: TabBarView(
                  children: [
                    _FilesTabWidget(torrent: widget.torrent),
                    _DetailsTabWidget(torrent: widget.torrent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilesTabWidget extends StatelessWidget {
  final Torrent torrent;

  const _FilesTabWidget({required this.torrent});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DownloadCubit, DownloadState, Torrent?>(
      selector: (state) =>
          state.torrents.firstWhereOrNull((t) => t.id == torrent.id),
      builder: (context, liveTorrent) {
        final t = liveTorrent ?? torrent;
        final areAllFilesWanted = t.files.every((f) => f.wanted);
        final areAllFilesSkipped = t.files.none((f) => f.wanted);
        final globalWantedState = areAllFilesWanted
            ? true
            : areAllFilesSkipped
            ? false
            : null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () async {
                  await t.toggleAllFilesWanted(!areAllFilesWanted);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText.headingCompact01(selectAll),
                    CheckBoxWidget(
                      value: globalWantedState,
                      side: BorderSide(color: context.colors.iconPrimary),
                      activeColor: context.colors.iconPrimary,
                      tristate: true,
                      onChanged: (value) async {
                        await t.toggleAllFilesWanted(value ?? false);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                itemCount: t.files.length,
                itemBuilder: (context, index) {
                  final file = t.files[index];
                  // final completed = file.bytesCompleted == file.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 13.0,
                    ),
                    child: Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppText.bodyCompact01(
                            file.name,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        IconWidget(
                          icon: AppAssets.icOpen,
                          iconColor: context.colors.iconPrimary,
                          onTap: () async {
                            final result = await OpenFilex.open(
                              path.join(torrent.location, file.name),
                              type: lookupMimeType(file.name),
                            );
                            if (result.type != ResultType.done &&
                                context.mounted) {
                              Navigator.of(context).pop();
                              if (context.mounted) {
                                NotificationWidget.notify(
                                  context,
                                  errorNotification(
                                    failedToOpenFile,
                                    result.message,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        CheckBoxWidget(
                          value: file.wanted,
                          side: BorderSide(color: context.colors.iconPrimary),
                          activeColor: context.colors.iconPrimary,
                          onChanged: (value) async {
                            if (file.bytesCompleted != file.length) {
                              await t.toggleFileWanted(index, !file.wanted);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.borderSubtle00,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailsTabWidget extends StatelessWidget {
  final Torrent torrent;

  const _DetailsTabWidget({required this.torrent});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DownloadCubit, DownloadState, Torrent?>(
      selector: (state) =>
          state.torrents.firstWhereOrNull((t) => t.id == torrent.id),
      builder: (context, liveTorrent) {
        final t = liveTorrent ?? torrent;
        return ListView(
          children: [
            _DetailTabItemWidget(label: nameLabel, value: t.name),
            _DetailTabItemWidget(label: idLabel, value: t.id.toString()),
            _DetailTabItemWidget(
              label: labelsLabel,
              value: (t.labels == null || t.labels!.isEmpty)
                  ? dash
                  : t.labels!.join(commaSeparator),
            ),
            _DetailTabItemWidget(
              label: statusLabel,
              value: t.status.toString().split('.').last,
            ),
            _DetailTabItemWidget(
              label: progressLabel,
              value: '${(t.progress * 100).toStringAsFixed(1)}$percentSuffix',
            ),
            _DetailTabItemWidget(
              label: size,
              value: prettyBytes(t.size.toDouble()),
            ),
            _DetailTabItemWidget(
              label: downloadedLabel,
              value: prettyBytes(t.downloadedEver.toDouble()),
            ),
            _DetailTabItemWidget(
              label: uploadedLabel,
              value: prettyBytes(t.uploadedEver.toDouble()),
            ),
            _DetailTabItemWidget(
              label: downloadRateLabel,
              value:
                  '${prettyBytes(t.rateDownload.toDouble())}$perSecondSuffix',
            ),
            _DetailTabItemWidget(
              label: uploadRateLabel,
              value: '${prettyBytes(t.rateUpload.toDouble())}$perSecondSuffix',
            ),
            _DetailTabItemWidget(
              label: remainingTimeLabel,
              value: Duration(
                seconds: t.eta,
              ).pretty(abbreviated: true, delimiter: ' '),
            ),
            _DetailTabItemWidget(label: locationLabel, value: t.location),
            _DetailTabItemWidget(
              label: privateLabel,
              value: t.isPrivate ? yesLabel : noLabel,
            ),
            _DetailTabItemWidget(
              label: addedDateLabel,
              value: DateTime.fromMillisecondsSinceEpoch(
                t.addedDate * 1000,
              ).toString(),
            ),
            _DetailTabItemWidget(
              label: creatorLabel,
              value: t.creator == emptyString ? dash : t.creator,
            ),
            _DetailTabItemWidget(
              label: commentLabel,
              value: t.comment == emptyString ? dash : t.comment,
            ),
            _DetailTabItemWidget(
              label: peersConnectedLabel,
              value: t.peersConnected.toString(),
            ),
            _DetailTabItemWidget(
              label: sequentialDownloadLabel,
              value: t.sequentialDownload ? yesLabel : noLabel,
            ),
            _DetailTabItemWidget(
              label: fileCountLabel,
              value: t.files.length.toString(),
            ),
            _DetailTabItemWidget(
              label: pieceCountLabel,
              value: t.pieceCount.toString(),
            ),
            _DetailTabItemWidget(
              label: pieceSizeLabel,
              value: prettyBytes(t.pieceSize.toDouble()),
            ),
            _DetailTabItemWidget(
              label: piecesLabel,
              value: '${t.pieces.where((e) => e).length}/${t.pieces.length}',
            ),
            _DetailTabItemWidget(
              label: error,
              value: t.errorString.isEmpty ? dash : t.errorString,
            ),
          ],
        );
      },
    );
  }
}

class _DetailTabItemWidget extends StatelessWidget {
  final String label;
  final String value;

  const _DetailTabItemWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.headingCompact01(label),
          AppText.bodyCompact01(value, color: context.colors.textPrimary),
        ],
      ),
    );
  }
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

Future<bool?> _showTorrentDeleteDialog(
  BuildContext context,
  Torrent torrent,
) async {
  final keepFiles = ValueNotifier<bool>(false);
  final result = await showDialog<bool>(
    barrierDismissible: false,
    barrierColor: context.colors.overlay,
    context: context,
    builder: (dialogContext) => DialogWidget(
      title: deleteConfirmationMessage,
      content: _buildKeepFilesCheckbox(dialogContext, keepFiles),
      actions: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              backgroundColor: dialogContext.colors.buttonSecondary,
              buttonText: cancel,
              onTap: () => Navigator.of(dialogContext).pop(false),
            ),
          ),
          Expanded(
            child: ButtonWidget(
              backgroundColor: dialogContext.colors.buttonPrimary,
              buttonText: delete,
              onTap: () async {
                final withData = !keepFiles.value;
                await torrent.remove(withData);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
  keepFiles.dispose();
  return result;
}

class _TorrentDetailsHeaderWidget extends StatelessWidget {
  final Torrent torrent;
  const _TorrentDetailsHeaderWidget({required this.torrent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBar.secondary(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          splashFactory: NoSplash.splashFactory,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: context.colors.borderInteractive,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          dividerColor: context.colors.borderSubtle01,
          dividerHeight: 1,
          labelStyle: TextStyle(
            fontFamily: ibmPlexSans,
            fontSize: 14,
            height: 18 / 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.16,
            color: context.colors.textPrimary,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: ibmPlexSans,
            fontSize: 14,
            height: 18 / 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.16,
            color: context.colors.textSecondary,
          ),
          indicator: ShapeDecoration(
            shape: Border(
              bottom: BorderSide(
                color: context.colors.borderInteractive,
                width: 3,
              ),
            ),
          ),
          tabs: const [files, details].map((menu) => Tab(text: menu)).toList(),
        ),
        Positioned(
          right: 96,
          top: 14,
          child: BlocSelector<DownloadCubit, DownloadState, Torrent?>(
            selector: (state) =>
                state.torrents.firstWhereOrNull((t) => t.id == torrent.id),
            builder: (context, liveTorrent) {
              final t = liveTorrent ?? torrent;
              final status = t.status;
              final String asset = status == TorrentStatus.stopped
                  ? AppAssets.icContinue
                  : (status == TorrentStatus.seeding || t.progress == 1)
                  ? AppAssets.icComplete
                  : (status == TorrentStatus.downloading ||
                        status == TorrentStatus.checking)
                  ? AppAssets.icStop
                  : AppAssets.icQueue;
              return InkWell(
                onTap: () async {
                  status == TorrentStatus.stopped ? t.start() : t.stop();
                },
                child: SvgPicture.asset(
                  asset,
                  width: 20,
                  height: 20,
                  colorFilter: context.colors.iconPrimary.colorFilter,
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 56,
          top: 14,
          child: InkWell(
            onTap: () async {
              await context.read<DownloadCubit>().shareTorrent(
                torrent,
                context,
              );
            },
            child: SvgPicture.asset(
              AppAssets.icShare,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 14,
          child: InkWell(
            onTap: () async {
              final confirmed = await _showTorrentDeleteDialog(
                context,
                torrent,
              );
              if (context.mounted && confirmed == true) {
                Navigator.of(context).pop();
              }
            },
            child: SvgPicture.asset(
              AppAssets.icDelete,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            ),
          ),
        ),
      ],
    );
  }
}
