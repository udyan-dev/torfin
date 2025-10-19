import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';
import 'selection_notifier.dart';

typedef RefreshCallbackFn = Future<void> Function();

class TorrentListRefreshIndicator extends StatelessWidget {
  final SelectionNotifier selection;
  final RefreshCallbackFn onRefresh;
  final Widget child;

  const TorrentListRefreshIndicator({
    super.key,
    required this.selection,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.interactive,
      backgroundColor: context.colors.background,
      onRefresh: () {
        if (selection.isActive) {
          return Future.value();
        }
        return onRefresh();
      },
      child: child,
    );
  }
}
