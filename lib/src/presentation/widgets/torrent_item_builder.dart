import 'package:flutter/material.dart';

import '../../data/models/response/torrent/torrent_res.dart';
import '../widgets/selection_notifier.dart';
import '../widgets/torrent_widget.dart';

typedef DialogBuilderFn =
    Widget Function(
      BuildContext parentContext,
      BuildContext dialogContext,
      TorrentRes torrent,
    );

class TorrentItemBuilder extends StatelessWidget {
  final TorrentRes torrent;
  final bool isFavorite;
  final VoidCallback onSave;
  final VoidCallback onDownload;
  final VoidCallback onDialogClosed;
  final DialogBuilderFn dialogBuilder;
  final SelectionNotifier selection;

  const TorrentItemBuilder({
    super.key,
    required this.torrent,
    required this.isFavorite,
    required this.onSave,
    required this.onDownload,
    required this.onDialogClosed,
    required this.dialogBuilder,
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    final key = torrent.identityKey;
    final isSelected = selection.isSelected(key);

    return InkWell(
      onTap: selection.isActive ? () => selection.toggle(key) : null,
      onLongPress: () => selection.toggle(key),
      child: IgnorePointer(
        ignoring: selection.isActive,
        child: TorrentWidget(
          torrent: torrent,
          isFavorite: isFavorite,
          onSave: onSave,
          onDownload: onDownload,
          onDialogClosed: onDialogClosed,
          showCheckbox: selection.isActive,
          isSelected: isSelected,
          onCheckboxTap: () => selection.toggle(key),
          dialogBuilder: (parentContext, dialogContext, t) =>
              dialogBuilder(parentContext, dialogContext, t),
        ),
      ),
    );
  }
}
