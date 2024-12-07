import 'package:flutter/material.dart';

sealed class AppColors {
  static const appBlack = Color(0xFF1C1C1C);
  static const appWhite = Color(0xFFFFFFFF);
  static const black = _Shades(
    s5: Color.fromRGBO(28, 28, 28, 0.05),
    s10: Color.fromRGBO(28, 28, 28, 0.10),
    s20: Color.fromRGBO(28, 28, 28, 0.20),
    s40: Color.fromRGBO(28, 28, 28, 0.40),
    s80: Color.fromRGBO(28, 28, 28, 0.80),
    s100: appBlack,
  );
  static const white = _Shades(
    s5: Color.fromRGBO(255, 255, 255, 0.05),
    s10: Color.fromRGBO(255, 255, 255, 0.10),
    s20: Color.fromRGBO(255, 255, 255, 0.20),
    s40: Color.fromRGBO(255, 255, 255, 0.40),
    s80: Color.fromRGBO(255, 255, 255, 0.80),
    s100: appWhite,
  );
  static const primary = Color(0XFF0437F2);
  static const primaryLight = Color(0XFFF7F9FB);
  static const primaryBlue = Color(0XFFE3F5FF);
  static const primaryPurple = Color(0XFFE5ECF6);
  static const primaryPurpleAccent = Color.fromRGBO(229, 236, 246, 0.5);
  static const purpleA = Color(0XFF95A4FC);
  static const purpleB = Color(0XFFC6C7F8);
  static const blueA = Color(0XFFA8C5DA);
  static const blueB = Color(0XFFB1E3FF);
  static const greenA = Color(0XFFA1E3CB);
  static const greenB = Color(0XFFBAEDBD);
  static const yellow = Color(0XFFFFE999);
  static const red = Color(0XFFFF4747);
}

class _Shades {
  final Color s5, s10, s20, s40, s80, s100;

  const _Shades({
    required this.s5,
    required this.s10,
    required this.s20,
    required this.s40,
    required this.s80,
    required this.s100,
  });
}
