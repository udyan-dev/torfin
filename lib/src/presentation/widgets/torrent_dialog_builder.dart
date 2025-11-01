import 'package:flutter/material.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import 'button_widget.dart';
import 'dialog_widget.dart';
import 'icon_widget.dart';
import 'loading_widget.dart';

typedef IsFavoriteFn = bool Function(TorrentRes torrent);
typedef OnToggleFavoriteFn = void Function(TorrentRes torrent);
typedef OnDownloadFn = void Function(TorrentRes torrent);
typedef OnShareFn =
    void Function(TorrentRes torrent, BuildContext dialogContext);
typedef FetchingMagnetKeyFn = String? Function();

class TorrentDialogBuilder extends StatelessWidget {
  final TorrentRes torrent;
  final BuildContext dialogContext;
  final IsFavoriteFn isFavorite;
  final OnToggleFavoriteFn onToggleFavorite;
  final OnDownloadFn onDownload;
  final OnShareFn onShare;
  final FetchingMagnetKeyFn fetchingMagnetKey;
  final Widget Function()? loadingIndicator;
  final String? coinsInfo;

  const TorrentDialogBuilder({
    super.key,
    required this.torrent,
    required this.dialogContext,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onDownload,
    required this.onShare,
    required this.fetchingMagnetKey,
    this.loadingIndicator,
    this.coinsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: torrent.name,
      subtitle: coinsInfo,
      trailing: IconWidget(
        icon: AppAssets.icShare,
        onTap: () => onShare(torrent, dialogContext),
      ),
      actions: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              backgroundColor: dialogContext.colors.buttonSecondary,
              buttonText: isFavorite(torrent) ? remove : save,
              onTap: () {
                onToggleFavorite(torrent);
                Navigator.of(dialogContext).maybePop();
              },
            ),
          ),
          Expanded(
            child: ButtonWidget(
              backgroundColor: dialogContext.colors.buttonPrimary,
              buttonText: download,
              onTap: () {
                onDownload(torrent);
                if (torrent.magnet.isNotEmpty) {
                  Navigator.of(dialogContext).maybePop();
                }
              },
              trailing: _buildLoadingIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (loadingIndicator != null) {
      return loadingIndicator!();
    }
    final currentFetchingKey = fetchingMagnetKey();
    return currentFetchingKey == torrent.identityKey
        ? const LoadingWidget()
        : const SizedBox.shrink();
  }
}
