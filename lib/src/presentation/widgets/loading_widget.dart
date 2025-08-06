import 'package:flutter/material.dart';
import 'package:torfin/core/utils/extensions.dart';

enum LoadingType {
  small(16.0),
  medium(32.0),
  large(88.0);

  final double size;

  const LoadingType(this.size);

  BoxConstraints get constraints => BoxConstraints.tight(Size.square(size));
}

class LoadingWidget extends StatelessWidget {
  final LoadingType type;

  const LoadingWidget({super.key, this.type = LoadingType.small});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      child: CircularProgressIndicator(
        color: colors.interactive,
        backgroundColor: colors.borderSubtle01,
        strokeWidth: 3.0,
        constraints: type.constraints,
      ),
    );
  }
}
