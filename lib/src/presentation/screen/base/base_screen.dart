import 'package:flutter/material.dart';
import 'package:torfin/src/presentation/screen/base/widgets/bottom_navigation_widget.dart';
import 'package:torfin/src/presentation/screen/trending/trending_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IndexedStack(
        key: ValueKey('_body_'),
        children: const [
          TrendingScreen(
            key: ValueKey('_trending_screen_'),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationWidget(
        key: ValueKey('_bottom_navigation_'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
