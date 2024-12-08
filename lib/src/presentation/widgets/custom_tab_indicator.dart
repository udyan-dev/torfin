import 'package:flutter/material.dart';

import '../../../core/utils/app_radius.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double height;
  final BorderRadius borderRadius;

  const CustomTabIndicator({
    required this.color,
    this.height = 2.0,
    this.borderRadius = AppRadius.br4,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BarPainter(color, height, borderRadius);
  }
}

class _BarPainter extends BoxPainter {
  final Paint _paint;
  final double height;
  final BorderRadius borderRadius;

  _BarPainter(Color color, this.height, this.borderRadius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Rect.fromLTWH(
      offset.dx,
      cfg.size!.height - height - cfg.size!.height / 5,
      cfg.size!.width,
      height,
    );
    final RRect roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(borderRadius.topLeft.x),
      topRight: Radius.circular(borderRadius.topRight.x),
      bottomLeft: Radius.circular(borderRadius.bottomLeft.x),
      bottomRight: Radius.circular(borderRadius.bottomRight.x),
    );
    canvas.drawRRect(roundedRect, _paint);
  }
}
