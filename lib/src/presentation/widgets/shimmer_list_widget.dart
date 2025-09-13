import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';

import 'dialog_widget.dart';
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
        itemBuilder: (context, index) => TorrentWidget(
          torrent: const TorrentRes(),
          isLoading: true,
          dialogBuilder: (parentContext, dialogContext, torrent) =>
              DialogWidget(
                title: torrent.name,
                actions: const SizedBox.shrink(),
              ),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: context.colors.borderSubtle00,
        ),
      ),
    );
  }
}
