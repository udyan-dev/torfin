import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';
import 'package:torfin/src/presentation/widgets/shimmer.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/empty_state/empty_state.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/sort_widget.dart';
import '../widgets/status_widget.dart';
import '../widgets/torrent_widget.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ScrollController _scrollController;
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchCubit = di<SearchCubit>();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (!_searchCubit.isClosed) {
      _searchCubit.close();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _searchCubit.isClosed) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 100) return;

    final state = _searchCubit.state;
    if (state.canLoadMore && !state.isPaginating && !state.isAutoLoadingMore) {
      _searchCubit.loadMore();
    }
  }

  void _checkAutoLoadMore(SearchState state) {
    if (!state.canLoadMore ||
        state.torrents.isEmpty ||
        state.isPaginating ||
        state.isAutoLoadingMore) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchCubit.isClosed || !_scrollController.hasClients) return;

      final position = _scrollController.position;
      if (position.maxScrollExtent <= 0 && state.canLoadMore) {
        _searchCubit.loadMore();
      }
    });
  }

  bool _shouldShowShimmer(SearchState state) =>
      state.isShimmer ||
      (state.torrents.isEmpty && state.status == SearchStatus.loading);

  Widget _buildTorrents(BuildContext context, SearchState state) {
    if (state.isEmpty) {
      return EmptyStateWidget(
        iconColor: context.colors.supportCautionMajor,
        emptyState: const EmptyState(
          stateIcon: AppAssets.icNoResultFound,
          title: noResultsFoundTitle,
          description: noResultsFoundDescription,
          buttonText: retry,
        ),
        onTap: () => _searchCubit.onRetry(),
      );
    }

    return _buildTorrentList(context, state);
  }

  Widget _buildTorrentList(BuildContext context, SearchState state) {
    if (_shouldShowShimmer(state)) {
      return _buildShimmerList(context);
    }
    return RefreshIndicator(
      color: context.colors.interactive,
      backgroundColor: context.colors.background,
      onRefresh: () {
        _searchCubit.search(search: state.search, isRefresh: true);
        return Future.value();
      },
      child: _buildActualList(context, state),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 25,
        itemBuilder: (context, index) => const TorrentWidget(isLoading: true),
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: context.colors.borderSubtle00,
        ),
      ),
    );
  }

  Widget _buildActualList(BuildContext context, SearchState state) {
    final itemCount = state.torrents.length + (state.showLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == state.torrents.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: StatusWidget(
              type: StatusType.loading,
              statusMessage: loadingMore,
            ),
          );
        }
        return TorrentWidget(torrent: state.torrents[index]);
      },
      separatorBuilder: (context, index) {
        if (index == state.torrents.length - 1 && state.showLoadingMore) {
          return const SizedBox.shrink();
        }
        return Divider(
          height: 1,
          thickness: 1,
          color: context.colors.borderSubtle00,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Column(
        children: [
          AppBarWidget(
            title: search,
            actions: [
              SortWidget(
                onSort: (sortType) => _searchCubit.search(sortType: sortType),
              ),
            ],
          ),
          SearchBarWidget(
            onSearch: (searchText) => _searchCubit.search(search: searchText),
            onFetchSuggestions: (query) => _searchCubit.fetchSuggestions(query),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (p, c) =>
                p.categoriesRaw != c.categoriesRaw ||
                p.selectedCategoryRaw != c.selectedCategoryRaw,
            builder: (context, state) {
              return CategoryWidget(
                categories: state.categoriesRaw,
                selectedRaw: state.selectedCategoryRaw,
                onCategoryChange: (raw) => _searchCubit.search(category: raw),
              );
            },
          ),
          Expanded(
            child: BlocListener<SearchCubit, SearchState>(
              listenWhen: (p, c) =>
                  c.status == SearchStatus.success && c.canLoadMore,
              listener: (context, state) => _checkAutoLoadMore(state),
              child: BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.selectedCategoryRaw !=
                        current.selectedCategoryRaw ||
                    previous.torrents.length != current.torrents.length ||
                    previous.isShimmer != current.isShimmer ||
                    previous.isPaginating != current.isPaginating ||
                    previous.isAutoLoadingMore != current.isAutoLoadingMore ||
                    !identical(previous.torrents, current.torrents),
                builder: (context, state) {
                  switch (state.status) {
                    case SearchStatus.initial:
                      return EmptyStateWidget(
                        iconColor: context.colors.interactive,
                        emptyState: const EmptyState(
                          stateIcon: AppAssets.icStartSearch,
                          title: searchTorrentsTitle,
                          description: searchTorrentsDescription,
                        ),
                      );
                    case SearchStatus.loading:
                    case SearchStatus.success:
                      return _buildTorrents(context, state);
                    case SearchStatus.error:
                      return EmptyStateWidget(
                        emptyState: state.emptyState,
                        iconColor: context.colors.supportError,
                        onTap: _searchCubit.onRetry,
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
