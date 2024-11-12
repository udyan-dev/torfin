import 'package:flutter/material.dart';

import 'app_colors.dart';

sealed class AppStyles {
  static const styleOne = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: AppColors.white);
}
