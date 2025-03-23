import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torfin/core/utils/app_extension.dart';

import '../../main.dart';
import '../theme/app_text.dart';

toggleDrawer(BuildContext context, {required bool open}) {
  final scaffoldState = Scaffold.maybeOf(context);
  if (open) {
    scaffoldState?.openDrawer();
  } else {
    scaffoldState?.closeDrawer();
  }
}

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

FlutterView getView(BuildContext context) {
  return View.of(context);
}

extension WidgetExtension on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget padding(EdgeInsets padding) => Padding(padding: padding, child: this);

  Widget fill() => Positioned.fill(child: this);

  Widget onTap(VoidCallback? onTap) =>
      GestureDetector(onTap: onTap, child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    ),
    child: this,
  );

  Widget paddingFromLTRB({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) => Padding(
    padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    child: this,
  );

  Widget marginAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget marginSymmetric({
    required double horizontal,
    required double vertical,
  }) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );

  Widget marginOnly({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    ),
    child: this,
  );

  Widget marginFromLTRB({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) => Padding(
    padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    child: this,
  );

  Widget center() => Center(child: this);

  Widget fit() => FittedBox(child: this);

  Widget square(double value) => SizedBox.square(dimension: value, child: this);

  Widget materialized({BorderRadius? borderRadius}) => Material(
    borderRadius: borderRadius,
    color: Colors.transparent,
    child: this,
  );

  Widget safeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
  }) =>
      SafeArea(left: left, top: top, right: right, bottom: bottom, child: this);

  Widget showIf(bool value) => value ? this : const SizedBox.shrink();

  Widget align([AlignmentGeometry alignment = Alignment.center]) =>
      Align(alignment: alignment, child: this);

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  Widget background(Color color) => Material(color: color, child: this);

  Widget addDivider({
    double height = 1.0,
    Color color = Colors.grey,
    double indent = 0.0,
    double endIndent = 0.0,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        Divider(
          height: height,
          color: color,
          indent: indent,
          endIndent: endIndent,
        ),
      ],
    );
  }

  Widget constrains({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: this,
    );
  }

  Widget responsiveConstrains({
    alignment = Alignment.topCenter,
    double minWidth = 0.0,
    double maxWidth = 600.0,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: this,
    ).align(alignment);
  }

  Widget toScrollableList({
    int itemCount = 10,
    Axis scrollDirection = Axis.vertical,
    EdgeInsets padding = EdgeInsets.zero,
    Widget? separator,
  }) {
    List<Widget> items = List.generate(itemCount, (index) => this);
    if (separator != null) {
      items = items.expand((element) => [element, separator]).toList();
    }

    return SingleChildScrollView(
      padding: padding,
      scrollDirection: scrollDirection,
      child:
          scrollDirection == Axis.vertical
              ? Column(children: items)
              : Row(children: items),
    );
  }

  Widget toScrollableGrid({
    SliverGridDelegate gridDelegate =
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
    EdgeInsets padding = EdgeInsets.zero,
    int itemCount = 10,
    Axis scrollDirection = Axis.vertical,
  }) {
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      scrollDirection: scrollDirection,
      padding: padding,
      itemBuilder: (_, __) => this,
    );
  }

  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      child: this,
    );
  }
}

List<bool> convertBitfieldToBoolList(Uint8List bitfield, int pieceCount) {
  List<bool> piecesAsBool = [];
  int pieceIndex = 0;

  for (int byte in bitfield) {
    for (int bitIndex = 7; bitIndex >= 0; bitIndex--) {
      if (pieceIndex >= pieceCount) {
        return piecesAsBool; // Stop if we've processed all pieces
      }

      int bit = (byte >> bitIndex) & 1;
      piecesAsBool.add(bit == 1);
      pieceIndex++;
    }

    if (pieceIndex >= pieceCount) {
      return piecesAsBool;
    }
  }

  return piecesAsBool;
}

void showSnackBar(
  BuildContext context,
  String message,
  SvgPicture icon,
  Color? backgroundColor,
  Color? leadingColor,
) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      showCloseIcon: true,
      duration: Durations.extralong4,
      behavior: SnackBarBehavior.floating,
      shape: const LinearBorder(),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
      closeIconColor:
          context.isDark
              ? context.themeColors.iconOnColor
              : context.themeColors.iconPrimary,
      content: Row(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          AppText.headingCompact01(
            message,
            color: context.themeColors.textPrimary,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
