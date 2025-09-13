import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/bindings/di.dart';
import '../../../core/utils/string_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/torrent_download_widget.dart';
import 'cubit/download_cubit.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late final DownloadCubit _downloadCubit;

  @override
  void initState() {
    super.initState();
    _downloadCubit = di<DownloadCubit>();
  }

  @override
  void dispose() {
    _downloadCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _downloadCubit..initialize(),
      child: Column(
        children: [
          const AppBarWidget(title: downloads),
          BlocBuilder<DownloadCubit, DownloadState>(
            builder: (context, state) {
              return CategoryWidget(
                categories: TorrentDownloadStatus.values
                    .map((e) => e.title)
                    .toList(),
                selectedRaw: state.selectedCategoryRaw,
                onCategoryChange: (String? raw) {
                  context.read<DownloadCubit>().setFilterRaw(raw);
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<DownloadCubit, DownloadState>(
              builder: (context, state) {
                return ListView.separated(
                  itemCount: state.torrents.length,
                  itemBuilder: (context, index) {
                    final t = state.torrents[index];
                    return TorrentDownloadWidget(torrent: t);
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: context.colors.borderSubtle00,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
