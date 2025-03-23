import 'package:flutter/material.dart';

class TopIndicatorDecoration extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;

  const TopIndicatorDecoration({
    required this.indicatorHeight,
    required this.indicatorColor,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return TopIndicatorPainter(
      indicatorHeight: indicatorHeight,
      indicatorColor: indicatorColor,
    );
  }
}

class TopIndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double indicatorHeight;
  final Color indicatorColor;

  TopIndicatorPainter({
    required this.indicatorHeight,
    required this.indicatorColor,
  }) : _paint =
           Paint()
             ..color = indicatorColor
             ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Rect.fromLTWH(
      offset.dx,
      offset.dy, // Position at the top
      configuration.size!.width,
      indicatorHeight, // Height of the indicator
    );

    canvas.drawRect(rect, _paint);
  }
}
