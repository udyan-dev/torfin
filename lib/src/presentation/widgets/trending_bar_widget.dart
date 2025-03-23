import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/src/presentation/widgets/segmented_widget.dart';
import 'package:torfin/src/presentation/widgets/torrent_type_widget.dart';

import '../pages/trending/bloc/trending_cubit.dart';

class TrendingBarWidget extends StatelessWidget {
  const TrendingBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedWidget<TrendingType>(
          key: const ValueKey("TrendingType"),
          items: TrendingType.values,
          getTitle: (T) => T.title,
          onChanged: (value) {
            context.read<TrendingCubit>().getTrending(
              trendingType: TrendingType.values.elementAt(value),
            );
          },
        ),
        TorrentTypeWidget(
          key: const ValueKey("TorrentTypeWidget"),
          onChange:
              (torrentType) => context.read<TrendingCubit>().getTrending(
                torrentType: torrentType,
              ),
        ),
      ],
    );
  }
}
