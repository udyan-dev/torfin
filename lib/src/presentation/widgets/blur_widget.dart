import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/utils/app_constant.dart';
import 'connectivity/bloc/connectivity_cubit.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        if (state.status == ConnectivityEnum.offline) {
          return Positioned.fill(
            top: kMinInteractiveDimension,
            child: ColoredBox(
              color: context.themeColors.overlay,
              child: const AbsorbPointer(),
            ),
          );
        }
        return AppConstant.empty;
      },
    );
  }
}
