import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../core/utils/string_constants.dart';

class CategoryWidget extends StatelessWidget {
  final List<String> categories;
  final String? selectedRaw;
  final Function(String? categoryRaw) onCategoryChange;

  const CategoryWidget({
    super.key,
    required this.categories,
    required this.selectedRaw,
    required this.onCategoryChange,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = categories;
    if (tabs.isEmpty) return const SizedBox.shrink();

    final idx = selectedRaw == null ? 0 : tabs.indexOf(selectedRaw!);
    final initialIndex = idx < 0 ? 0 : idx;

    return DefaultTabController(
      key: ValueKey<String>('${tabs.join("|")}::${selectedRaw ?? ""}'),
      length: tabs.length,
      initialIndex: initialIndex,
      child: ColoredBox(
        color: context.colors.background,
        child: TabBar.secondary(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          splashFactory: NoSplash.splashFactory,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: context.colors.borderInteractive,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          dividerColor: context.colors.borderSubtle01,
          dividerHeight: 1,
          labelStyle: TextStyle(
            fontFamily: ibmPlexSans,
            fontSize: 14,
            height: 18 / 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.16,
            color: context.colors.textPrimary,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: ibmPlexSans,
            fontSize: 14,
            height: 18 / 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.16,
            color: context.colors.textSecondary,
          ),
          indicator: ShapeDecoration(
            shape: Border(
              bottom: BorderSide(
                color: context.colors.borderInteractive,
                width: 3,
              ),
            ),
          ),
          tabs: tabs.map((raw) => Tab(text: raw)).toList(),
          onTap: (index) {
            onCategoryChange.call(tabs[index]);
          },
        ),
      ),
    );
  }
}
