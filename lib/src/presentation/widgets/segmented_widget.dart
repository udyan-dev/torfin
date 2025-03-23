import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/theme/app_style.dart';
import 'package:torfin/core/utils/app_extension.dart';

class SegmentedWidget<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T)? getTitle;
  final String Function(T)? getIcon;
  final EdgeInsets? margin;
  final double? width;
  final Function(int) onChanged;

  const SegmentedWidget({
    super.key,
    required this.items,
    this.getTitle,
    this.getIcon,
    this.margin,
    this.width,
    required this.onChanged,
  }) : assert(
         getTitle != null || getIcon != null,
         'Either getTitle or getIcon must be provided.',
       );

  @override
  State<SegmentedWidget<T>> createState() => _SegmentedWidgetState<T>();
}

class _SegmentedWidgetState<T> extends State<SegmentedWidget<T>> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: widget.width,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: context.themeColors.borderInverse),
          borderRadius: BorderRadius.circular(4),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildSegments(),
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
              indent: 8,
              endIndent: 8,
              thickness: 1,
              width: 1,
              color: context.themeColors.borderSubtle00,
            )
            : const SizedBox(width: 1);
      }
      return _buildSegment(widget.items[index ~/ 2], index ~/ 2);
    });
  }

  Widget _buildSegment(T item, int index) {
    return Expanded(
      key: ValueKey(item),
      child: InkWell(
        onTap: () {
          widget.onChanged.call(index);
          setState(() => selectedIndex = index);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
          decoration: BoxDecoration(
            color:
                selectedIndex == index
                    ? context.themeColors.layerSelectedInverse
                    : Colors.transparent,
          ),
          child: Center(
            child:
                widget.getIcon != null
                    ? SvgPicture.asset(
                      widget.getIcon!(item).toAsset,
                      colorFilter:
                          selectedIndex == index
                              ? context.themeColors.textInverse.colorFilter
                              : context.themeColors.textSecondary.colorFilter,
                    )
                    : Text(
                      widget.getTitle!(item),
                      style: AppStyle.getStyle(
                        TextStyleType.bodyCompact01,
                        color:
                            selectedIndex == index
                                ? context.themeColors.textInverse
                                : context.themeColors.textSecondary,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
