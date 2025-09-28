import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/theme/app_styles.dart';

class ContentSwitcherWidget<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String Function(T) getItemLabel;
  final T? selectedItem;
  final bool enableBgColor;
  final EdgeInsets padding;

  const ContentSwitcherWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.getItemLabel,
    this.selectedItem,
    this.enableBgColor = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  State<ContentSwitcherWidget<T>> createState() =>
      _ContentSwitcherWidgetState<T>();
}

class _ContentSwitcherWidgetState<T> extends State<ContentSwitcherWidget<T>> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(ContentSwitcherWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      _updateSelectedIndex();
    }
  }

  void _updateSelectedIndex() {
    if (widget.items.isNotEmpty) {
      selectedIndex = widget.selectedItem != null
          ? widget.items
                .indexOf(widget.selectedItem as T)
                .clamp(0, widget.items.length - 1)
          : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return ColoredBox(
      color: widget.enableBgColor
          ? context.colors.background
          : Colors.transparent,
      child: Padding(
        padding: widget.padding,
        child: IntrinsicHeight(
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.borderInverse),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildSegments(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSegments() {
    final itemCount = widget.items.length;

    return List.generate(itemCount * 2 - 1, (index) {
      if (index.isOdd) {
        final prevIndex = index ~/ 2;
        final nextIndex = prevIndex + 1;
        return (prevIndex != selectedIndex && nextIndex != selectedIndex)
            ? VerticalDivider(
                indent: 12,
                endIndent: 12,
                thickness: 1,
                width: 1,
                color: context.colors.textDisabled,
              )
            : const SizedBox(width: 1);
      }
      return _buildSegment(
        widget.getItemLabel(widget.items[index ~/ 2]),
        index ~/ 2,
      );
    });
  }

  Widget _buildSegment(String item, int index) {
    final selected = selectedIndex == index;
    return Expanded(
      key: ValueKey(index),
      child: InkWell(
        onTap: () {
          widget.onChanged(widget.items[index]);
          setState(() => selectedIndex = index);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: selected
                ? context.colors.layerSelectedInverse
                : Colors.transparent,
          ),
          child: AppText.bodyCompact01(
            item,
            textAlign: TextAlign.start,
            color: selected
                ? context.colors.textInverse
                : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
