import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_bytes/pretty_bytes.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../data/engine/torrent.dart';
import '../download/cubit/download_cubit.dart';
import 'torrent_details_widget.dart';

class TorrentDownloadWidget extends StatelessWidget {
  final Torrent torrent;
  const TorrentDownloadWidget({super.key, required this.torrent});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierColor: context.colors.overlay,
          backgroundColor: Colors.transparent,
          shape: LinearBorder.none,
          builder: (_) => BlocProvider.value(
            value: context.read<DownloadCubit>(),
            child: TorrentDetailsWidget(torrent: torrent),
          ),
        );
      },
      child: ColoredBox(
        color: colors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            spacing: 16,
            children: [
              InkWell(
                onTap: () async {
                  torrent.status == TorrentStatus.stopped
                      ? torrent.start()
                      : torrent.stop();
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
                      torrent.status == TorrentStatus.stopped
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
                  spacing: 4,
                  children: [
                    AppText.headingCompact01(
                      torrent.name,
                      textAlign: TextAlign.start,
                      color: colors.textPrimary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      spacing: 8,
                      children: [
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
