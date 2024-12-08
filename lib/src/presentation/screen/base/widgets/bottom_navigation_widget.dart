import 'package:collection/collection.dart' show ListExtensions;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/app_extensions.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late final List<String> _bottomNavigationList;

  late final ValueNotifier<int> _currentIndex;

  @override
  void initState() {
    _currentIndex = ValueNotifier<int>(0);
    _bottomNavigationList = [
      AppAssets.trending,
      AppAssets.search,
      AppAssets.favorite,
      AppAssets.settings,
    ];
    super.initState();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey("_bottom_navigation_widget_"),
      child: ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return BottomNavigationBar(
            currentIndex: value,
            items: _bottomNavigationList
                .mapIndexed<BottomNavigationBarItem>((index, item) {
              return BottomNavigationBarItem(
                  key: ValueKey(item),
                  icon: SvgPicture.asset(
                    item,
                    colorFilter: value == index
                        ? context.iconActive.colorFilter
                        : context.iconInActive.colorFilter,
                  ),
                  label: '');
            }).toList(growable: false),
            onTap: (index) => _currentIndex.value = index,
          );
        },
      ),
    );
  }
}
