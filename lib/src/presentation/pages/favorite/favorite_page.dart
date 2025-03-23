import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/src/presentation/pages/favorite/bloc/favorite_cubit.dart';

import '../../../../core/theme/app_style.dart';
import '../../../../core/utils/app_constant.dart';
import '../../../../gen/assets.gen.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/list_widget.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/torrent_type_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _onInit();
  }

  _onInit() async => await context.read<FavoriteCubit>().getAllFavorites();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppBarWidget(key: ValueKey("AppBarWidget")),
        SearchWidget(
          key: ValueKey("SearchWidget"),
          onSearch: (value) {
            context.read<FavoriteCubit>().getAllFavorites(search: value);
          },
        ),
        TorrentTypeWidget(
          key: const ValueKey("TorrentTypeWidget"),
          onChange: (torrentType) {
            context.read<FavoriteCubit>().getAllFavorites(
              torrentType: torrentType,
            );
          },
        ),
        _buildList(context),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: context.themeColors.iconPrimary,
        backgroundColor: context.themeColors.background,
        onRefresh: () async {
          context.read<FavoriteCubit>().getAllFavorites();
        },
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          buildWhen:
              (previous, current) => previous.torrents != current.torrents,
          builder: (context, state) {
            if (state.torrents.isEmpty &&
                state.status == FavoriteStateEnum.ready) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAsset.svg.icEmpty.path),
                    Text(
                      "Add your Favorite Torrents !",
                      style: AppStyle.getStyle(TextStyleType.label01),
                    ),
                  ],
                ),
              );
            }
            if (state.status == FavoriteStateEnum.ready) {
              return RepaintBoundary(
                child: ListWidget(
                  key: ValueKey(state.torrents.hashCode),
                  scrollController: _scrollController,
                  torrents: state.torrents,
                ),
              );
            } else if (state.status == FavoriteStateEnum.loading) {
              return AppConstant.circularProgress;
            } else if (state.status == FavoriteStateEnum.failure) {
              return const ExceptionWidget();
            }
            return AppConstant.empty;
          },
        ),
      ),
    );
  }
}
