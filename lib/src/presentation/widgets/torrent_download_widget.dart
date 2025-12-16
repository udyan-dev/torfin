import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_bytes/pretty_bytes.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/engine/torrent.dart';
import '../download/cubit/download_cubit.dart';
import 'checkbox_widget.dart';
import 'dialog_widget.dart';
import 'torrent_details_widget.dart';

class TorrentDownloadWidget extends StatelessWidget {
  final Torrent torrent;
  final bool showCheckbox;
  final bool isSelected;
  final VoidCallback? onCheckboxTap;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TorrentDownloadWidget({
    super.key,
    required this.torrent,
    this.showCheckbox = false,
    this.isSelected = false,
    this.onCheckboxTap,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.background,
      child: InkWell(
        onTap:
            onTap ??
            () {
              showAppBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<DownloadCubit>(),
                  child: TorrentDetailsWidget(torrent: torrent),
                ),
              );
            },
        onLongPress: onLongPress,
        child: IgnorePointer(
          ignoring: showCheckbox,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              spacing: 16,
              children: [
                if (showCheckbox)
                  InkWell(
                    onTap: onCheckboxTap,
                    child: CheckBoxWidget(
                      value: isSelected,
                      side: BorderSide(color: colors.iconPrimary),
                      activeColor: colors.iconPrimary,
                      onChanged: (_) => onCheckboxTap?.call(),
                    ),
                  ),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    if (torrent.errorString.isNotEmpty) {
                      if (context.mounted) {
                        context.read<DownloadCubit>().retryTorrent(
                          torrent,
                          context,
                        );
                      }
                    } else {
                      torrent.status == TorrentStatus.stopped
                          ? torrent.start()
                          : torrent.stop();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: torrent.progress,
                        constraints: const BoxConstraints.tightFor(
                          width: kMinInteractiveDimension,
                          height: kMinInteractiveDimension,
                        ),
                        backgroundColor: colors.borderSubtle00,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.interactive,
                        ),
                      ),
                      SvgPicture.asset(
                        torrent.errorString.isNotEmpty
                            ? AppAssets.icReset
                            : torrent.status == TorrentStatus.stopped
                            ? AppAssets.icContinue
                            : (torrent.status == TorrentStatus.seeding ||
                                  torrent.progress == 1)
                            ? AppAssets.icComplete
                            : (torrent.status == TorrentStatus.downloading ||
                                  torrent.status == TorrentStatus.checking)
                            ? AppAssets.icStop
                            : AppAssets.icQueue,
                        width: 20,
                        height: 20,
                        colorFilter: colors.iconPrimary.colorFilter,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      AppText.headingCompact01(
                        torrent.files.isEmpty
                            ? gettingTorrentMetadata
                            : torrent.name,
                        textAlign: TextAlign.start,
                        color: colors.textPrimary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          AppText.label01(
                            '${(torrent.progress * 100).toStringAsFixed(1)} %',
                            color: colors.textSecondary,
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              SvgPicture.asset(
                                AppAssets.icSize,
                                width: 16,
                                height: 16,
                                colorFilter: colors.tagColorMagenta.colorFilter,
                              ),
                              AppText.label01(
                                prettyBytes(torrent.size.toDouble()),
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              SvgPicture.asset(
                                AppAssets.icChevronDown,
                                width: 16,
                                height: 16,
                                colorFilter: colors.supportSuccess.colorFilter,
                              ),
                              AppText.label01(
                                '${prettyBytes(torrent.rateDownload.toDouble())}/s',
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              SvgPicture.asset(
                                AppAssets.icChevronUp,
                                width: 16,
                                height: 16,
                                colorFilter:
                                    colors.supportCautionMajor.colorFilter,
                              ),
                              AppText.label01(
                                '${prettyBytes(torrent.rateUpload.toDouble())}/s',
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (torrent.errorString.isNotEmpty)
                        AppText.label01(
                          torrent.errorString,
                          color: colors.supportError,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
