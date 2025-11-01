import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/utils/extensions.dart';

class SliderWidget extends StatelessWidget {
  final String? icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double> onChanged;
  final double? trackHeight;
  final double? thumbSize;

  const SliderWidget({
    super.key,
    this.icon,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    required this.onChanged,
    this.trackHeight,
    this.thumbSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveTrackHeight = trackHeight ?? 2;
    final effectiveThumbSize = thumbSize ?? 8;

    final slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: effectiveTrackHeight,
        padding: EdgeInsets.zero,
        thumbColor: colors.interactive,
        activeTrackColor: colors.interactive,
        inactiveTrackColor: colors.layerBackground01,
        inactiveTickMarkColor: colors.borderSubtle01,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbSize: WidgetStatePropertyAll(
          Size(effectiveThumbSize, effectiveThumbSize),
        ),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );

    if (icon == null && label == null) {
      return slider;
    }

    return Row(
      spacing: 16,
      children: [
        if (icon != null)
          SvgPicture.asset(
            icon!,
            width: 20,
            height: 20,
            colorFilter: colors.iconOnColor.colorFilter,
          ),
        Expanded(child: slider),
        if (label != null)
          Text(
            label!,
            style: TextStyle(color: colors.iconOnColor, fontSize: 12),
          ),
      ],
    );
  }
}
