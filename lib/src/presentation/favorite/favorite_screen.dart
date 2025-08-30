import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/string_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/torrent_widget.dart';
import 'cubit/favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late final FavoriteCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = di<FavoriteCubit>();
    _cubit.load();
  }

  @override
  void dispose() {
    if (!_cubit.isClosed) _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Column(
        children: [
          const AppBarWidget(title: favorite),
          SearchBarWidget(
            onSearch: (q) => _cubit.load(query: q),
            onFetchSuggestions: (q) async => _cubit.load(query: q),
          ),
          Expanded(
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              buildWhen: (p, c) =>
                  p.status != c.status ||
                  p.isShimmer != c.isShimmer ||
                  p.query != c.query ||
                  p.torrents.length != c.torrents.length ||
                  !identical(p.torrents, c.torrents),
              builder: (context, state) {
                switch (state.status) {
                  case FavoriteStatus.initial:
                  case FavoriteStatus.loading:
                    return const ShimmerListWidget();
                  case FavoriteStatus.success:
                    if (state.torrents.isEmpty) {
                      return EmptyStateWidget(
                        iconColor: state.query.isEmpty
                            ? context.colors.tagColorPurple
                            : context.colors.supportCautionMajor,
                        emptyState: state.emptyState,
                        onTap: () => _cubit.load(query: state.query),
                      );
                    }
                    return RefreshIndicator(
                      color: context.colors.interactive,
                      backgroundColor: context.colors.background,
                      onRefresh: () {
                        _cubit.load(query: state.query);
                        return Future.value();
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.torrents.length,
                        itemBuilder: (context, index) {
                          final torrent = state.torrents[index];
                          return TorrentWidget(
                            torrent: torrent,
                            isFavorite: state.isFavorite(torrent),
                            onSave: () => _cubit.toggleFavorite(torrent),
                          );
                        },
                        separatorBuilder: (_, i) => Divider(
                          height: 1,
                          thickness: 1,
                          color: context.colors.borderSubtle00,
                        ),
                      ),
                    );
                  case FavoriteStatus.error:
                    return EmptyStateWidget(
                      emptyState: state.emptyState,
                      iconColor: context.colors.supportError,
                      onTap: () => _cubit.load(query: state.query),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
