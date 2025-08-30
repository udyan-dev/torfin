import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import 'shimmer.dart';
import 'torrent_widget.dart';

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
