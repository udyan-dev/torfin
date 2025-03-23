import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../../core/theme/app_style.dart';
import '../../../../core/utils/app_constant.dart';
import '../../../../gen/assets.gen.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/list_widget.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/sort_widget.dart';
import '../../widgets/torrent_type_widget.dart';
import 'bloc/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final ScrollController _scrollController;
  bool _hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _onInit();
  }

  void _onInit() {
    context.read<SearchCubit>().clear();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_hasReachedEnd) {
      _hasReachedEnd = true;
      context.read<SearchCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget(
          key: const ValueKey("AppBarWidget"),
          actionWidget: _buildAction(context),
        ),
        SearchWidget(
          key: ValueKey("SearchWidget"),
          showSuggestions: true,
          onSearch: (value) {
            context.read<SearchCubit>().search(search: value, page: 0);
          },
          fetchSuggestions:
              (query) async => await context
                  .read<SearchCubit>()
                  .fetchSuggestions(query: query),
        ),
        TorrentTypeWidget(
          key: const ValueKey("TorrentTypeWidget"),
          onChange: (torrentType) {
            _hasReachedEnd = false;
            context.read<SearchCubit>().search(
              search: context.read<SearchCubit>().state.search,
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
          _hasReachedEnd = false; // Reset flag on refresh
          context.read<SearchCubit>().search(
            search: context.read<SearchCubit>().state.search,
            page: 0,
          );
        },
        child: BlocListener<SearchCubit, SearchState>(
          listener: (context, state) {
            // Reset _hasReachedEnd when pagination is successful and more data is available
            if (state.status == SearchStateEnum.ready && state.hasMore) {
              _hasReachedEnd = false;
            }
          },
          child: BlocBuilder<SearchCubit, SearchState>(
            buildWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.torrents != current.torrents,
            builder: (context, state) {
              if (state.search.isEmpty &&
                  state.status == SearchStateEnum.ready) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAsset.svg.icSearchPage.path),
                      Text(
                        "Start Searching !",
                        style: AppStyle.getStyle(TextStyleType.label01),
                      ),
                    ],
                  ),
                );
              }
              if (state.status == SearchStateEnum.ready ||
                  state.status == SearchStateEnum.pagination) {
                return RepaintBoundary(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListWidget(
                          scrollController: _scrollController,
                          torrents: state.torrents,
                        ),
                      ),
                      if (state.status == SearchStateEnum.pagination) ...const [
                        AppConstant.circularProgress,
                        SizedBox(height: 16),
                      ],
                    ],
                  ),
                );
              } else if (state.status == SearchStateEnum.loading) {
                return AppConstant.circularProgress;
              } else if (state.status == SearchStateEnum.failure) {
                return const ExceptionWidget();
              }
              return AppConstant.empty;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SortWidget(
          selectedFilter: state.sortType,
          onSort: (sortType) {
            _hasReachedEnd = false; // Reset flag on new search
            context.read<SearchCubit>().search(
              search: context.read<SearchCubit>().state.search,
              sortType: sortType,
            );
          },
        );
      },
    );
  }
}
