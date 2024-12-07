import 'package:flutter/material.dart';

import '../../widgets/app_bar_widget.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarWidget(key: ValueKey('_trending_app_bar_'), title: 'Trending'),
    );
  }
}
