import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/app_style.dart';
import '../../../gen/assets.gen.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SvgPicture.asset(AppAsset.svg.icError.path),
          const SizedBox(height: 16),
          Text(
            "Server is Busy !",
            textAlign: TextAlign.center,
            style: AppStyle.getStyle(TextStyleType.label01),
          ),
        ],
      ),
    );
  }
}
