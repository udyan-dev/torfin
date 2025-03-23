import 'package:flutter/material.dart';
import 'package:torfin/core/theme/app_text.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../../core/utils/app_constant.dart';
import '../../../gen/assets.gen.dart';
import '../../../main.dart';
import 'icon_widget.dart';

class BannerWidget extends MaterialBanner {
  BannerWidget({super.key})
    : super(
        backgroundColor:
            scaffoldMessengerKey.currentContext?.themeColors.backgroundInverse,
        dividerColor:
            scaffoldMessengerKey.currentContext?.themeColors.backgroundInverse,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        minActionBarHeight: kMinInteractiveDimension,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconWidget(
              icon: AppAsset.svg.icOffline,
              color:
                  scaffoldMessengerKey
                      .currentContext
                      ?.themeColors
                      .supportErrorInverse,
            ),
            AppText.label01(
              AppConstant.noInternetFound,
              color:
                  scaffoldMessengerKey.currentContext?.themeColors.textInverse,
            ),
          ],
        ),
        actions: [AppConstant.empty],
      );
}
