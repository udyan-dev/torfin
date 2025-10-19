import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({super.key, this.child});

  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient {
    final t = _shimmerController.value;
    final s = _scaleX(t);
    final o = _opacity(t);
    final bool left = t < 0.28 || t >= 0.83;
    final Color bg = context.colors.skeletonBackground;
    final Color el = context.colors.skeletonElement.withValues(alpha: o);

    if (left) {
      final edge = s.clamp(0.0, 1.0);
      return LinearGradient(
        colors: [el, el, bg, bg],
        stops: [0.0, edge, edge, 1.0],
        tileMode: TileMode.decal,
      );
    } else {
      final edge = (1.0 - s).clamp(0.0, 1.0);
      return LinearGradient(
        colors: [bg, bg, el, el],
        stops: [0.0, edge, edge, 1.0],
        tileMode: TileMode.decal,
      );
    }
  }

  double _ease(double x) => Curves.easeInOut.transform(x.clamp(0.0, 1.0));

  double _lerp(double a, double b, double p) => a + (b - a) * _ease(p);

  double _seg(double t, double a, double b, double from, double to) {
    if (t <= a) return from;
    if (t >= b) return to;
    final p = (t - a) / (b - a);
    return _lerp(from, to, p);
  }

  double _scaleX(double t) {
    if (t <= 0.20) return _seg(t, 0.00, 0.20, 0.0, 1.0);
    if (t <= 0.28) return 1.0;
    if (t <= 0.51) return _seg(t, 0.28, 0.51, 1.0, 0.0);
    if (t <= 0.58) return 0.0;
    if (t <= 0.82) return _seg(t, 0.58, 0.82, 0.0, 1.0);
    if (t <= 0.83) return 1.0;
    if (t <= 0.96) return _seg(t, 0.83, 0.96, 1.0, 0.0);
    return 0.0;
  }

  double _opacity(double t) {
    if (t <= 0.20) return _seg(t, 0.00, 0.20, 0.3, 1.0);
    if (t <= 0.96) return 1.0;
    return _seg(t, 0.96, 1.00, 1.0, 0.3);
  }

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox?;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final shimmer = Shimmer.of(context);
    if (shimmer == null) {
      return widget.child;
    }

    if (!shimmer.isSized) {
      return const SizedBox();
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return widget.child;
    }

    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: renderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
