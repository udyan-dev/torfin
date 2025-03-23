import 'dart:io';

import 'package:flutter/material.dart';

bool isMobileSize(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 450;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
}

bool isDesktop() {
  return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
