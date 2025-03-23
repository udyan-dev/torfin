// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/theme/app_color.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/gen/assets.gen.dart';
import 'package:torfin/src/data/model/engine/engine.dart';
import 'package:torfin/src/presentation/pages/download/bloc/download_cubit.dart';
import 'package:torfin/src/presentation/widgets/icon_widget.dart';

import '../../../core/theme/app_style.dart';
import '../../../core/utils/app_utility.dart';
import '../../data/model/response/torrent/torrent_res.dart';
import '../../injection.dart';
import '../pages/home/bloc/home_cubit.dart';
import 'position_retain_physics.dart';

class ListWidget extends StatelessWidget {
  final List<TorrentRes> torrents;
  final ScrollController scrollController;

  const ListWidget({
    super.key,
    required this.torrents,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (torrents.isEmpty) {
      return Center(
        child: ListView(
          shrinkWrap: true,
          physics: const PositionRetainedScrollPhysics(),
          children: [
            SvgPicture.asset(AppAsset.svg.icEmpty.path),
            const SizedBox(height: 16),
            Text(
              textAlign: TextAlign.center,
              "No Torrents Found!",
              style: AppStyle.getStyle(TextStyleType.label01),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: torrents.length,
      itemBuilder:
          (context, index) =>
              _TorrentItemWidget(torrent: torrents[index], context: context),
      separatorBuilder: (context, index) => const DividerWidget(),
    );
  }
}

class _TorrentItemWidget extends StatelessWidget {
  final TorrentRes torrent;
  final BuildContext context;

  const _TorrentItemWidget({required this.torrent, required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(torrent),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: SvgPicture.asset(
                torrent.type.icon.path,
                width: 32,
                height: 32,
                colorFilter: context.themeColors.interactive.colorFilter,
              ),
            ),
          ),
          Flexible(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  torrent.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.getStyle(
                    TextStyleType.headingCompact01,
                    color: context.themeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoColumnWidget(
                      context: context,
                      label1: "Size",
                      value1: torrent.size,
                      label2: "Seeder",
                      value2: torrent.seeder.toString(),
                    ),
                    _InfoColumnWidget(
                      context: context,
                      label1: "Date",
                      value1: torrent.age,
                      label2: "Leecher",
                      value2: torrent.leecher.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen:
                      (_, state) =>
                          state.status == HomeStateEnum.ready ||
                          state.status == HomeStateEnum.save ||
                          state.status == HomeStateEnum.remove,
                  builder: (context, state) {
                    final isFavorite = state.favorites.any(
                      (t) => t.magnet == torrent.magnet,
                    );
                    return IconWidget(
                      icon:
                          isFavorite
                              ? AppAsset.svg.icFavoriteFilled
                              : AppAsset.svg.icFavorite,
                      color: context.themeColors.iconSecondary,
                      onTap: () async {
                        if (isFavorite) {
                          await context.read<HomeCubit>().removeTorrent(
                            torrent: torrent,
                          );
                          showSnackBar(
                            context,
                            "Removed from Favorite !",
                            SvgPicture.asset(
                              AppAsset.svg.icBan.path,
                              colorFilter:
                                  context.themeColors.supportError.colorFilter,
                            ),
                            context.isDark
                                ? di<AppColor>().gray[80]
                                : di<AppColor>().red[10],
                            context.themeColors.supportError,
                          );
                        } else {
                          await context.read<HomeCubit>().saveTorrent(
                            torrent: torrent,
                          );
                          showSnackBar(
                            context,
                            "Added to Favorite !",
                            SvgPicture.asset(
                              AppAsset.svg.icSuccess.path,
                              colorFilter:
                                  context
                                      .themeColors
                                      .supportSuccess
                                      .colorFilter,
                            ),
                            context.isDark
                                ? di<AppColor>().gray[80]
                                : di<AppColor>().green[10],
                            context.themeColors.supportSuccess,
                          );
                        }
                      },
                    );
                  },
                ),
                IconWidget(
                  icon: AppAsset.svg.icDownload,
                  color: context.themeColors.iconSecondary,
                  onTap: () async {
                    final result = await context
                        .read<DownloadCubit>()
                        .addTorrent(torrent);

                    if (result == TorrentAddedResponse.added) {
                      showSnackBar(
                        context,
                        "Downloading !",
                        SvgPicture.asset(
                          AppAsset.svg.icSuccess.path,
                          colorFilter:
                              context.themeColors.supportSuccess.colorFilter,
                        ),
                        context.isDark
                            ? di<AppColor>().gray[80]
                            : di<AppColor>().green[10],
                        context.themeColors.supportSuccess,
                      );
                    } else if (result == TorrentAddedResponse.duplicated) {
                      showSnackBar(
                        context,
                        "Already added !",
                        SvgPicture.asset(
                          AppAsset.svg.icInfo.path,
                          colorFilter:
                              context.themeColors.interactive.colorFilter,
                        ),
                        context.isDark
                            ? di<AppColor>().gray[80]
                            : di<AppColor>().blue[10],
                        context.themeColors.interactive,
                      );
                    } else if (result == TorrentAddedResponse.error) {
                      showSnackBar(
                        context,
                        "Failed to Download !",
                        SvgPicture.asset(
                          AppAsset.svg.icBan.path,
                          colorFilter:
                              context.themeColors.supportError.colorFilter,
                        ),
                        context.isDark
                            ? di<AppColor>().gray[80]
                            : di<AppColor>().red[10],
                        context.themeColors.supportError,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.themeColors.borderSubtle01,
    );
  }
}
