import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final TabController controller;
  const BottomNavigationBarWidget({super.key, required this.controller});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedIndex = widget.controller.index;
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.borderSubtle00)),
        ),
        child: TabBar(
          controller: widget.controller,
          enableFeedback: true,
          tabs: navigationItems
              .mapIndexed(
                (index, menu) => Tab(
                  icon: SvgPicture.asset(
                    menu.icon,
                    width: 24,
                    height: 24,
                    colorFilter: selectedIndex == index
                        ? colors.iconPrimary.colorFilter
                        : colors.iconOnColorDisabled.colorFilter,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
