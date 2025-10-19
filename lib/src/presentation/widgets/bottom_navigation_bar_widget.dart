import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.borderSubtle00)),
        ),
        child: TabBar(
          enableFeedback: true,
          tabs: navigationItems
              .mapIndexed(
                (index, menu) => Tab(
                  icon: SvgPicture.asset(
                    menu.icon,
                    width: 24,
                    height: 24,
                    colorFilter: _selectedIndex == index
                        ? colors.iconPrimary.colorFilter
                        : colors.iconOnColorDisabled.colorFilter,
                  ),
                ),
              )
              .toList(),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
