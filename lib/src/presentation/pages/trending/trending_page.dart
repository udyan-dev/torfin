import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/src/presentation/widgets/list_widget.dart';

import '../../widgets/app_bar_widget.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/sort_widget.dart';
import '../../widgets/trending_bar_widget.dart';
import 'bloc/trending_cubit.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _onInit();
  }

  _onInit() async => await context.read<TrendingCubit>().getTrending();

  @override
  void dispose() {
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
        const TrendingBarWidget(),
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
          context.read<TrendingCubit>().getTrending();
        },
        child: BlocBuilder<TrendingCubit, TrendingState>(
          buildWhen:
              (previous, current) =>
                  previous.status != current.status ||
                  previous.torrents != current.torrents,
          builder: (context, state) {
            if (state.status == TrendingStateEnum.ready) {
              return RepaintBoundary(
                child: ListWidget(
                  key: ValueKey(state.torrents.hashCode),
                  torrents: state.torrents,
                  scrollController: _scrollController,
                ),
              );
            } else if (state.status == TrendingStateEnum.loading) {
              return AppConstant.circularProgress;
            } else if (state.status == TrendingStateEnum.failure) {
              return const ExceptionWidget();
            }
            return AppConstant.empty;
          },
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return BlocBuilder<TrendingCubit, TrendingState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SortWidget(
          selectedFilter: state.sortType,
          onSort: (sortType) {
            context.read<TrendingCubit>().getTrending(sortType: sortType);
          },
        );
      },
    );
  }
}
