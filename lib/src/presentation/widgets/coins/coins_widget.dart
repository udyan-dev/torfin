import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:torfin/core/utils/extensions.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/app_assets.dart';

class CoinsWidget extends StatelessWidget {
  const CoinsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.supportCautionMajor),
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                // SvgPicture.asset(
                //   AppAssets.icAdd,
                //   width: 20,
                //   height: 20,
                //   colorFilter: context.colors.supportCautionMinor.colorFilter,
                // ),
                const SizedBox(width: 2),
                AppText.bodyCompact01(
                  '10',
                  color: context.colors.supportCautionMajor,
                ),
                const SizedBox(width: kToolbarHeight / 2),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Transform.scale(
            scale: 1.75,
            child: Lottie.asset(
              AppAssets.icCoinLottie,
              frameRate: FrameRate.max,
              repeat: true,
              filterQuality: FilterQuality.high,
              addRepaintBoundary: true,
            ),
          ),
        ),
      ],
    );
  }
}
