import 'package:flutter/material.dart';

import '../widgets/selection_notifier.dart';

typedef ListBuilderFn = Widget Function(BuildContext context);
typedef MultiSelectBarBuilderFn = Widget Function(BuildContext context);

class ListWithMultiSelectLayout extends StatelessWidget {
  final SelectionNotifier selection;
  final ListBuilderFn listBuilder;
  final MultiSelectBarBuilderFn? multiSelectBarBuilder;

  const ListWithMultiSelectLayout({
    super.key,
    required this.selection,
    required this.listBuilder,
    this.multiSelectBarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: selection,
      builder: (context, _) {
        return Column(
          children: [
            if (selection.isActive && multiSelectBarBuilder != null)
              multiSelectBarBuilder!(context),
            Expanded(child: listBuilder(context)),
          ],
        );
      },
    );
  }
}
