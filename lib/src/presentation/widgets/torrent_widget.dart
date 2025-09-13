import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/extensions.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import 'shimmer.dart';

class TorrentWidget extends StatelessWidget {
  final bool isLoading;
  final bool isFavorite;
  final TorrentRes torrent;
  final VoidCallback? onSave;
  final VoidCallback? onDownload;
  final VoidCallback? onDialogClosed;
  final Widget Function(
    BuildContext parentContext,
    BuildContext dialogContext,
    TorrentRes torrent,
  )
  dialogBuilder;

  const TorrentWidget({
    super.key,
    required this.torrent,
    this.isLoading = false,
    this.isFavorite = false,
    this.onSave,
    this.onDownload,
    this.onDialogClosed,
    required this.dialogBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.background,
      child: InkWell(
        onTap: () {
          final parentContext = context;
          showDialog(
            barrierColor: colors.overlay,
            context: parentContext,
            useRootNavigator: false,
            builder: (dialogContext) =>
                dialogBuilder(parentContext, dialogContext, torrent),
          ).whenComplete(() {
            onDialogClosed?.call();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading
                  ? const _ShimmerLine(height: 14)
                  : AppText.headingCompact01(
                      torrent.name,
                      textAlign: TextAlign.center,
                      color: colors.textPrimary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLoading ? 24.0 : 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: isLoading
                            ? CrossAxisAlignment.stretch
                            : CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          isLoading
                              ? const _ShimmerLine(height: 12)
                              : _InfoWidget(
                                  iconAsset: AppAssets.icTime,
                                  text: "$age : ${torrent.age}",
                                  textColor: colors.tagColorCyan,
                                ),
                          isLoading
                              ? const _ShimmerLine(height: 12)
                              : _InfoWidget(
                                  iconAsset: AppAssets.icSize,
                                  text: "$size : ${torrent.size}",
                                  textColor: colors.tagColorPurple,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLoading ? 24.0 : 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: isLoading
                            ? CrossAxisAlignment.stretch
                            : CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          isLoading
                              ? const _ShimmerLine(height: 12)
                              : _InfoWidget(
                                  iconAsset: AppAssets.icArrowDown,
                                  text: "$seeder : ${torrent.seeder}",
                                  textColor: colors.tagColorGreen,
                                ),
                          isLoading
                              ? const _ShimmerLine(height: 12)
                              : _InfoWidget(
                                  iconAsset: AppAssets.icArrowUp,
                                  text: "$leecher : ${torrent.leecher}",
                                  textColor: colors.tagColorRed,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final line = ColoredBox(
      color: context.colors.skeletonBackground,
      child: SizedBox(height: height),
    );
    final child = ShimmerLoading(isLoading: true, child: line);
    return child;
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.iconAsset,
    required this.text,
    required this.textColor,
  });

  final String iconAsset;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      iconAsset,
      colorFilter: textColor.colorFilter,
    );
    final label = AppText.label01(
      text,
      color: textColor,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [icon, label],
    );
  }
}
