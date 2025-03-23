import 'package:flutter/material.dart';

import 'app_color.dart';

class ThemeColor extends ThemeExtension<ThemeColor> {
  // Background colors
  final Color background;
  final Color backgroundInverse;
  final Color backgroundBrand;
  final Color backgroundActive;
  final Color backgroundHover;
  final Color backgroundInverseHover;
  final Color backgroundSelected;
  final Color backgroundSelectedHover;

  // Layer colors
  final Color layer01;
  final Color layerActive01;
  final Color layerHover01;
  final Color layerSelected01;
  final Color layerSelectedHover01;

  final Color layer02;
  final Color layerActive02;
  final Color layerHover02;
  final Color layerSelected02;
  final Color layerSelectedHover02;

  final Color layer03;
  final Color layerActive03;
  final Color layerHover03;
  final Color layerSelected03;
  final Color layerSelectedHover03;

  final Color layerSelectedInverse;
  final Color layerSelectedDisabled;
  final Color layerAccent01;
  final Color layerAccentActive01;
  final Color layerAccentHover01;
  final Color layerAccent02;
  final Color layerAccentActive02;
  final Color layerAccentHover02;
  final Color layerAccent03;
  final Color layerAccentActive03;
  final Color layerAccentHover03;

  // Field colors
  final Color field01;
  final Color fieldHover01;
  final Color field02;
  final Color fieldHover02;
  final Color field03;
  final Color fieldHover03;

  // Border colors
  final Color borderSubtle00;
  final Color borderSubtle01;
  final Color borderSubtleSelected01;
  final Color borderSubtle02;
  final Color borderSubtleSelected02;
  final Color borderSubtle03;
  final Color borderSubtleSelected03;
  final Color borderStrong01;
  final Color borderStrong02;
  final Color borderStrong03;
  final Color borderTile01;
  final Color borderTile02;
  final Color borderTile03;
  final Color borderInverse;
  final Color borderInteractive;
  final Color borderDisabled;

  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textPlaceholder;
  final Color textHelper;
  final Color textError;
  final Color textInverse;
  final Color textOnColor;
  final Color textOnColorDisabled;
  final Color textDisabled;

  // Link colors
  final Color linkPrimary;
  final Color linkPrimaryHover;
  final Color linkSecondary;
  final Color linkInverse;
  final Color linkVisited;
  final Color linkInverseVisited;
  final Color linkInverseActive;
  final Color linkInverseHover;

  // Icon colors
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconInverse;
  final Color iconOnColor;
  final Color iconOnColorDisabled;
  final Color iconDisabled;
  final Color iconInteractive;

  // Support colors
  final Color supportError;
  final Color supportSuccess;
  final Color supportWarning;
  final Color supportInfo;
  final Color supportErrorInverse;
  final Color supportSuccessInverse;
  final Color supportWarningInverse;
  final Color supportInfoInverse;
  final Color supportCautionMinor;
  final Color supportCautionMajor;
  final Color supportCautionUndefined;

  // Focus colors
  final Color focus;
  final Color focusInset;
  final Color focusInverse;

  // Skeleton colors
  final Color skeletonBackground;
  final Color skeletonElement;

  // Misc colors
  final Color interactive;
  final Color highlight;
  final Color overlay;
  final Color toggleOff;
  final Color shadow;

  const ThemeColor({
    // Background
    required this.background,
    required this.backgroundInverse,
    required this.backgroundBrand,
    required this.backgroundActive,
    required this.backgroundHover,
    required this.backgroundInverseHover,
    required this.backgroundSelected,
    required this.backgroundSelectedHover,

    // Layer
    required this.layer01,
    required this.layerActive01,
    required this.layerHover01,
    required this.layerSelected01,
    required this.layerSelectedHover01,
    required this.layer02,
    required this.layerActive02,
    required this.layerHover02,
    required this.layerSelected02,
    required this.layerSelectedHover02,
    required this.layer03,
    required this.layerActive03,
    required this.layerHover03,
    required this.layerSelected03,
    required this.layerSelectedHover03,
    required this.layerSelectedInverse,
    required this.layerSelectedDisabled,
    required this.layerAccent01,
    required this.layerAccentActive01,
    required this.layerAccentHover01,
    required this.layerAccent02,
    required this.layerAccentActive02,
    required this.layerAccentHover02,
    required this.layerAccent03,
    required this.layerAccentActive03,
    required this.layerAccentHover03,

    // Field
    required this.field01,
    required this.fieldHover01,
    required this.field02,
    required this.fieldHover02,
    required this.field03,
    required this.fieldHover03,

    // Border
    required this.borderSubtle00,
    required this.borderSubtle01,
    required this.borderSubtleSelected01,
    required this.borderSubtle02,
    required this.borderSubtleSelected02,
    required this.borderSubtle03,
    required this.borderSubtleSelected03,
    required this.borderStrong01,
    required this.borderStrong02,
    required this.borderStrong03,
    required this.borderTile01,
    required this.borderTile02,
    required this.borderTile03,
    required this.borderInverse,
    required this.borderInteractive,
    required this.borderDisabled,

    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.textHelper,
    required this.textError,
    required this.textInverse,
    required this.textOnColor,
    required this.textOnColorDisabled,
    required this.textDisabled,

    // Link
    required this.linkPrimary,
    required this.linkPrimaryHover,
    required this.linkSecondary,
    required this.linkInverse,
    required this.linkVisited,
    required this.linkInverseVisited,
    required this.linkInverseActive,
    required this.linkInverseHover,

    // Icon
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconInverse,
    required this.iconOnColor,
    required this.iconOnColorDisabled,
    required this.iconDisabled,
    required this.iconInteractive,

    // Support
    required this.supportError,
    required this.supportSuccess,
    required this.supportWarning,
    required this.supportInfo,
    required this.supportErrorInverse,
    required this.supportSuccessInverse,
    required this.supportWarningInverse,
    required this.supportInfoInverse,
    required this.supportCautionMinor,
    required this.supportCautionMajor,
    required this.supportCautionUndefined,

    // Focus
    required this.focus,
    required this.focusInset,
    required this.focusInverse,

    // Skeleton
    required this.skeletonBackground,
    required this.skeletonElement,

    // Misc
    required this.interactive,
    required this.highlight,
    required this.overlay,
    required this.toggleOff,
    required this.shadow,
  });

  static late AppColor _appColor;

  static void initialize(AppColor appColor) {
    _appColor = appColor;
  }

  static ThemeColor get light => ThemeColor(
    background: _appColor.white,
    backgroundInverse: _appColor.gray[80]!,
    backgroundBrand: _appColor.blue[60]!,
    backgroundActive: _appColor.gray[50]!.withValues(alpha: 0.5),
    backgroundHover: _appColor.gray[50]!.withValues(alpha: 0.12),
    backgroundInverseHover: _appColor.grayHover[80]!,
    backgroundSelected: _appColor.gray[50]!.withValues(alpha: 0.2),
    backgroundSelectedHover: _appColor.gray[50]!.withValues(alpha: 0.32),
    layer01: _appColor.gray[10]!,
    layerActive01: _appColor.gray[30]!,
    layerHover01: _appColor.grayHover[10]!,
    layerSelected01: _appColor.gray[20]!,
    layerSelectedHover01: _appColor.grayHover[20]!,
    layer02: _appColor.white,
    layerActive02: _appColor.gray[30]!,
    layerHover02: _appColor.whiteHover,
    layerSelected02: _appColor.gray[20]!,
    layerSelectedHover02: _appColor.grayHover[20]!,
    layer03: _appColor.gray[10]!,
    layerActive03: _appColor.gray[30]!,
    layerHover03: _appColor.grayHover[10]!,
    layerSelected03: _appColor.gray[20]!,
    layerSelectedHover03: _appColor.grayHover[20]!,
    layerSelectedInverse: _appColor.gray[100]!,
    layerSelectedDisabled: _appColor.gray[50]!,
    layerAccent01: _appColor.gray[20]!,
    layerAccentActive01: _appColor.gray[40]!,
    layerAccentHover01: _appColor.grayHover[20]!,
    layerAccent02: _appColor.gray[20]!,
    layerAccentActive02: _appColor.gray[40]!,
    layerAccentHover02: _appColor.grayHover[20]!,
    layerAccent03: _appColor.gray[20]!,
    layerAccentActive03: _appColor.gray[40]!,
    layerAccentHover03: _appColor.grayHover[20]!,
    field01: _appColor.gray[10]!,
    fieldHover01: _appColor.grayHover[10]!,
    field02: _appColor.white,
    fieldHover02: _appColor.whiteHover,
    field03: _appColor.gray[10]!,
    fieldHover03: _appColor.grayHover[10]!,
    borderSubtle00: _appColor.gray[20]!,
    borderSubtle01: _appColor.gray[30]!,
    borderSubtleSelected01: _appColor.gray[30]!,
    borderSubtle02: _appColor.gray[20]!,
    borderSubtleSelected02: _appColor.gray[30]!,
    borderSubtle03: _appColor.gray[30]!,
    borderSubtleSelected03: _appColor.gray[30]!,
    borderStrong01: _appColor.gray[50]!,
    borderStrong02: _appColor.gray[50]!,
    borderStrong03: _appColor.gray[50]!,
    borderTile01: _appColor.gray[30]!,
    borderTile02: _appColor.gray[40]!,
    borderTile03: _appColor.gray[30]!,
    borderInverse: _appColor.gray[100]!,
    borderInteractive: _appColor.blue[60]!,
    borderDisabled: _appColor.gray[30]!,
    textPrimary: _appColor.gray[100]!,
    textSecondary: _appColor.gray[70]!,
    textPlaceholder: _appColor.gray[100]!.withValues(alpha: 0.4),
    textHelper: _appColor.gray[60]!,
    textError: _appColor.red[60]!,
    textInverse: _appColor.white,
    textOnColor: _appColor.white,
    textOnColorDisabled: _appColor.gray[50]!,
    textDisabled: _appColor.gray[100]!.withValues(alpha: 0.25),
    linkPrimary: _appColor.blue[60]!,
    linkPrimaryHover: _appColor.blue[70]!,
    linkSecondary: _appColor.blue[70]!,
    linkInverse: _appColor.blue[40]!,
    linkVisited: _appColor.purple[60]!,
    linkInverseVisited: _appColor.purple[40]!,
    linkInverseActive: _appColor.gray[10]!,
    linkInverseHover: _appColor.blue[30]!,
    iconPrimary: _appColor.gray[100]!,
    iconSecondary: _appColor.gray[70]!,
    iconInverse: _appColor.white,
    iconOnColor: _appColor.white,
    iconOnColorDisabled: _appColor.gray[50]!,
    iconDisabled: _appColor.gray[100]!.withValues(alpha: 0.25),
    iconInteractive: _appColor.blue[60]!,
    supportError: _appColor.red[60]!,
    supportSuccess: _appColor.green[50]!,
    supportWarning: _appColor.yellow[30]!,
    supportInfo: _appColor.blue[70]!,
    supportErrorInverse: _appColor.red[50]!,
    supportSuccessInverse: _appColor.green[40]!,
    supportWarningInverse: _appColor.yellow[30]!,
    supportInfoInverse: _appColor.blue[50]!,
    supportCautionMinor: _appColor.yellow[30]!,
    supportCautionMajor: _appColor.orange[40]!,
    supportCautionUndefined: _appColor.purple[60]!,
    focus: _appColor.blue[60]!,
    focusInset: _appColor.white,
    focusInverse: _appColor.white,
    skeletonBackground: _appColor.whiteHover,
    skeletonElement: _appColor.gray[30]!,
    interactive: _appColor.blue[60]!,
    highlight: _appColor.blue[20]!,
    overlay: const Color.fromRGBO(22, 22, 22, 0.5),
    toggleOff: _appColor.gray[50]!,
    shadow: const Color.fromRGBO(0, 0, 0, 0.3),
  );

  static ThemeColor get dark => ThemeColor(
    background: _appColor.gray[100]!,
    backgroundInverse: _appColor.gray[10]!,
    backgroundBrand: _appColor.blue[60]!,
    backgroundActive: _appColor.gray[50]!.withValues(alpha: 0.4),
    backgroundHover: _appColor.gray[50]!.withValues(alpha: 0.16),
    backgroundInverseHover: _appColor.grayHover[10]!,
    backgroundSelected: _appColor.gray[50]!.withValues(alpha: 0.24),
    backgroundSelectedHover: _appColor.gray[50]!.withValues(alpha: 0.32),
    layer01: _appColor.gray[90]!,
    layerActive01: _appColor.gray[70]!,
    layerHover01: _appColor.grayHover[90]!,
    layerSelected01: _appColor.gray[80]!,
    layerSelectedHover01: _appColor.grayHover[80]!,
    layer02: _appColor.gray[80]!,
    layerActive02: _appColor.gray[60]!,
    layerHover02: _appColor.grayHover[80]!,
    layerSelected02: _appColor.gray[70]!,
    layerSelectedHover02: _appColor.grayHover[70]!,
    layer03: _appColor.gray[70]!,
    layerActive03: _appColor.gray[50]!,
    layerHover03: _appColor.grayHover[70]!,
    layerSelected03: _appColor.gray[60]!,
    layerSelectedHover03: _appColor.grayHover[60]!,
    layerSelectedInverse: _appColor.gray[10]!,
    layerSelectedDisabled: _appColor.gray[40]!,
    layerAccent01: _appColor.gray[80]!,
    layerAccentActive01: _appColor.gray[60]!,
    layerAccentHover01: _appColor.grayHover[80]!,
    layerAccent02: _appColor.gray[70]!,
    layerAccentActive02: _appColor.gray[50]!,
    layerAccentHover02: _appColor.grayHover[70]!,
    layerAccent03: _appColor.gray[60]!,
    layerAccentActive03: _appColor.gray[80]!,
    layerAccentHover03: _appColor.grayHover[60]!,
    field01: _appColor.gray[90]!,
    fieldHover01: _appColor.grayHover[90]!,
    field02: _appColor.gray[80]!,
    fieldHover02: _appColor.grayHover[80]!,
    field03: _appColor.gray[70]!,
    fieldHover03: _appColor.grayHover[70]!,
    borderSubtle00: _appColor.gray[80]!,
    borderSubtle01: _appColor.gray[70]!,
    borderSubtleSelected01: _appColor.gray[60]!,
    borderSubtle02: _appColor.gray[60]!,
    borderSubtleSelected02: _appColor.gray[50]!,
    borderSubtle03: _appColor.gray[60]!,
    borderSubtleSelected03: _appColor.gray[50]!,
    borderStrong01: _appColor.gray[60]!,
    borderStrong02: _appColor.gray[50]!,
    borderStrong03: _appColor.gray[40]!,
    borderTile01: _appColor.gray[70]!,
    borderTile02: _appColor.gray[60]!,
    borderTile03: _appColor.gray[50]!,
    borderInverse: _appColor.gray[10]!,
    borderInteractive: _appColor.blue[50]!,
    borderDisabled: _appColor.gray[50]!.withValues(alpha: 0.5),
    textPrimary: _appColor.gray[10]!,
    textSecondary: _appColor.gray[30]!,
    textPlaceholder: _appColor.gray[10]!.withValues(alpha: 0.4),
    textHelper: _appColor.gray[40]!,
    textError: _appColor.red[40]!,
    textInverse: _appColor.gray[100]!,
    textOnColor: _appColor.white,
    textOnColorDisabled: _appColor.white.withValues(alpha: 0.25),
    textDisabled: _appColor.gray[10]!.withValues(alpha: 0.25),
    linkPrimary: _appColor.blue[40]!,
    linkPrimaryHover: _appColor.blue[30]!,
    linkSecondary: _appColor.blue[30]!,
    linkInverse: _appColor.blue[60]!,
    linkVisited: _appColor.purple[40]!,
    linkInverseVisited: _appColor.purple[60]!,
    linkInverseActive: _appColor.gray[100]!,
    linkInverseHover: _appColor.blue[70]!,
    iconPrimary: _appColor.gray[10]!,
    iconSecondary: _appColor.gray[30]!,
    iconInverse: _appColor.gray[100]!,
    iconOnColor: _appColor.white,
    iconOnColorDisabled: _appColor.white.withValues(alpha: 0.25),
    iconDisabled: _appColor.gray[10]!.withValues(alpha: 0.25),
    iconInteractive: _appColor.white,
    supportError: _appColor.red[50]!,
    supportSuccess: _appColor.green[40]!,
    supportWarning: _appColor.yellow[30]!,
    supportInfo: _appColor.blue[50]!,
    supportErrorInverse: _appColor.red[60]!,
    supportSuccessInverse: _appColor.green[50]!,
    supportWarningInverse: _appColor.yellow[30]!,
    supportInfoInverse: _appColor.blue[70]!,
    supportCautionMinor: _appColor.yellow[30]!,
    supportCautionMajor: _appColor.orange[40]!,
    supportCautionUndefined: _appColor.purple[50]!,
    focus: _appColor.white,
    focusInset: _appColor.gray[100]!,
    focusInverse: _appColor.blue[60]!,
    skeletonBackground: _appColor.adjustLightness(_appColor.gray[100]!, 7),
    skeletonElement: _appColor.gray[80]!,
    interactive: _appColor.blue[50]!,
    highlight: _appColor.blue[90]!,
    overlay: Colors.black.withValues(alpha: 0.65),
    toggleOff: _appColor.gray[60]!,
    shadow: Colors.black.withValues(alpha: 0.8),
  );

  @override
  ThemeExtension<ThemeColor> copyWith({
    Color? background,
    Color? backgroundInverse,
    Color? backgroundInverseHover,
    Color? backgroundBrand,
    Color? backgroundActive,
    Color? backgroundHover,
    Color? backgroundSelected,
    Color? backgroundSelectedHover,
    Color? layer01,
    Color? layer02,
    Color? layer03,
    Color? layerActive01,
    Color? layerHover01,
    Color? layerSelected01,
    Color? layerSelectedHover01,
    Color? layerActive02,
    Color? layerHover02,
    Color? layerSelected02,
    Color? layerSelectedHover02,
    Color? layerActive03,
    Color? layerHover03,
    Color? layerSelected03,
    Color? layerSelectedHover03,
    Color? layerSelectedInverse,
    Color? layerSelectedDisabled,
    Color? layerAccent01,
    Color? layerAccentActive01,
    Color? layerAccentHover01,
    Color? layerAccent02,
    Color? layerAccentActive02,
    Color? layerAccentHover02,
    Color? layerAccent03,
    Color? layerAccentActive03,
    Color? layerAccentHover03,
    Color? field01,
    Color? fieldHover01,
    Color? field02,
    Color? fieldHover02,
    Color? field03,
    Color? fieldHover03,
    Color? borderSubtle00,
    Color? borderSubtle01,
    Color? borderSubtleSelected01,
    Color? borderSubtle02,
    Color? borderSubtleSelected02,
    Color? borderSubtle03,
    Color? borderSubtleSelected03,
    Color? borderStrong01,
    Color? borderStrong02,
    Color? borderStrong03,
    Color? borderTile01,
    Color? borderTile02,
    Color? borderTile03,
    Color? borderInverse,
    Color? borderInteractive,
    Color? borderDisabled,
    Color? textPrimary,
    Color? textSecondary,
    Color? textPlaceholder,
    Color? textHelper,
    Color? textError,
    Color? textInverse,
    Color? textOnColor,
    Color? textOnColorDisabled,
    Color? textDisabled,
    Color? linkPrimary,
    Color? linkPrimaryHover,
    Color? linkSecondary,
    Color? linkInverse,
    Color? linkVisited,
    Color? linkInverseVisited,
    Color? linkInverseActive,
    Color? linkInverseHover,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconInverse,
    Color? iconOnColor,
    Color? iconOnColorDisabled,
    Color? iconDisabled,
    Color? iconInteractive,
    Color? supportError,
    Color? supportSuccess,
    Color? supportWarning,
    Color? supportInfo,
    Color? supportErrorInverse,
    Color? supportSuccessInverse,
    Color? supportWarningInverse,
    Color? supportInfoInverse,
    Color? supportCautionMinor,
    Color? supportCautionMajor,
    Color? supportCautionUndefined,
    Color? focus,
    Color? focusInset,
    Color? focusInverse,
    Color? skeletonBackground,
    Color? skeletonElement,
    Color? interactive,
    Color? highlight,
    Color? overlay,
    Color? toggleOff,
    Color? shadow,
  }) {
    return ThemeColor(
      background: background ?? this.background,
      backgroundInverse: backgroundInverse ?? this.backgroundInverse,
      backgroundInverseHover:
          backgroundInverseHover ?? this.backgroundInverseHover,
      backgroundBrand: backgroundBrand ?? this.backgroundBrand,
      backgroundActive: backgroundActive ?? this.backgroundActive,
      backgroundHover: backgroundHover ?? this.backgroundHover,
      backgroundSelected: backgroundSelected ?? this.backgroundSelected,
      backgroundSelectedHover:
          backgroundSelectedHover ?? this.backgroundSelectedHover,
      layer01: layer01 ?? this.layer01,
      layer02: layer02 ?? this.layer02,
      layer03: layer03 ?? this.layer03,
      layerActive01: layerActive01 ?? this.layerActive01,
      layerHover01: layerHover01 ?? this.layerHover01,
      layerSelected01: layerSelected01 ?? this.layerSelected01,
      layerSelectedHover01: layerSelectedHover01 ?? this.layerSelectedHover01,
      layerActive02: layerActive02 ?? this.layerActive02,
      layerHover02: layerHover02 ?? this.layerHover02,
      layerSelected02: layerSelected02 ?? this.layerSelected02,
      layerSelectedHover02: layerSelectedHover02 ?? this.layerSelectedHover02,
      layerActive03: layerActive03 ?? this.layerActive03,
      layerHover03: layerHover03 ?? this.layerHover03,
      layerSelected03: layerSelected03 ?? this.layerSelected03,
      layerSelectedHover03: layerSelectedHover03 ?? this.layerSelectedHover03,
      layerSelectedInverse: layerSelectedInverse ?? this.layerSelectedInverse,
      layerSelectedDisabled:
          layerSelectedDisabled ?? this.layerSelectedDisabled,
      layerAccent01: layerAccent01 ?? this.layerAccent01,
      layerAccentActive01: layerAccentActive01 ?? this.layerAccentActive01,
      layerAccentHover01: layerAccentHover01 ?? this.layerAccentHover01,
      layerAccent02: layerAccent02 ?? this.layerAccent02,
      layerAccentActive02: layerAccentActive02 ?? this.layerAccentActive02,
      layerAccentHover02: layerAccentHover02 ?? this.layerAccentHover02,
      layerAccent03: layerAccent03 ?? this.layerAccent03,
      layerAccentActive03: layerAccentActive03 ?? this.layerAccentActive03,
      layerAccentHover03: layerAccentHover03 ?? this.layerAccentHover03,
      field01: field01 ?? this.field01,
      fieldHover01: fieldHover01 ?? this.fieldHover01,
      field02: field02 ?? this.field02,
      fieldHover02: fieldHover02 ?? this.fieldHover02,
      field03: field03 ?? this.field03,
      fieldHover03: fieldHover03 ?? this.fieldHover03,
      borderSubtle00: borderSubtle00 ?? this.borderSubtle00,
      borderSubtle01: borderSubtle01 ?? this.borderSubtle01,
      borderSubtleSelected01:
          borderSubtleSelected01 ?? this.borderSubtleSelected01,
      borderSubtle02: borderSubtle02 ?? this.borderSubtle02,
      borderSubtleSelected02:
          borderSubtleSelected02 ?? this.borderSubtleSelected02,
      borderSubtle03: borderSubtle03 ?? this.borderSubtle03,
      borderSubtleSelected03:
          borderSubtleSelected03 ?? this.borderSubtleSelected03,
      borderStrong01: borderStrong01 ?? this.borderStrong01,
      borderStrong02: borderStrong02 ?? this.borderStrong02,
      borderStrong03: borderStrong03 ?? this.borderStrong03,
      borderTile01: borderTile01 ?? this.borderTile01,
      borderTile02: borderTile02 ?? this.borderTile02,
      borderTile03: borderTile03 ?? this.borderTile03,
      borderInverse: borderInverse ?? this.borderInverse,
      borderInteractive: borderInteractive ?? this.borderInteractive,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textHelper: textHelper ?? this.textHelper,
      textError: textError ?? this.textError,
      textInverse: textInverse ?? this.textInverse,
      textOnColor: textOnColor ?? this.textOnColor,
      textOnColorDisabled: textOnColorDisabled ?? this.textOnColorDisabled,
      textDisabled: textDisabled ?? this.textDisabled,
      linkPrimary: linkPrimary ?? this.linkPrimary,
      linkPrimaryHover: linkPrimaryHover ?? this.linkPrimaryHover,
      linkSecondary: linkSecondary ?? this.linkSecondary,
      linkInverse: linkInverse ?? this.linkInverse,
      linkVisited: linkVisited ?? this.linkVisited,
      linkInverseVisited: linkInverseVisited ?? this.linkInverseVisited,
      linkInverseActive: linkInverseActive ?? this.linkInverseActive,
      linkInverseHover: linkInverseHover ?? this.linkInverseHover,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconInverse: iconInverse ?? this.iconInverse,
      iconOnColor: iconOnColor ?? this.iconOnColor,
      iconOnColorDisabled: iconOnColorDisabled ?? this.iconOnColorDisabled,
      iconDisabled: iconDisabled ?? this.iconDisabled,
      iconInteractive: iconInteractive ?? this.iconInteractive,
      supportError: supportError ?? this.supportError,
      supportSuccess: supportSuccess ?? this.supportSuccess,
      supportWarning: supportWarning ?? this.supportWarning,
      supportInfo: supportInfo ?? this.supportInfo,
      supportErrorInverse: supportErrorInverse ?? this.supportErrorInverse,
      supportSuccessInverse:
          supportSuccessInverse ?? this.supportSuccessInverse,
      supportWarningInverse:
          supportWarningInverse ?? this.supportWarningInverse,
      supportInfoInverse: supportInfoInverse ?? this.supportInfoInverse,
      supportCautionMinor: supportCautionMinor ?? this.supportCautionMinor,
      supportCautionMajor: supportCautionMajor ?? this.supportCautionMajor,
      supportCautionUndefined:
          supportCautionUndefined ?? this.supportCautionUndefined,
      focus: focus ?? this.focus,
      focusInset: focusInset ?? this.focusInset,
      focusInverse: focusInverse ?? this.focusInverse,
      skeletonBackground: skeletonBackground ?? this.skeletonBackground,
      skeletonElement: skeletonElement ?? this.skeletonElement,
      interactive: interactive ?? this.interactive,
      highlight: highlight ?? this.highlight,
      overlay: overlay ?? this.overlay,
      toggleOff: toggleOff ?? this.toggleOff,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ThemeExtension<ThemeColor> lerp(ThemeExtension<ThemeColor>? other, double t) {
    if (other is! ThemeColor) return this;

    return ThemeColor(
      background: Color.lerp(background, other.background, t)!,
      backgroundInverse:
          Color.lerp(backgroundInverse, other.backgroundInverse, t)!,
      backgroundInverseHover:
          Color.lerp(backgroundInverseHover, other.backgroundInverseHover, t)!,
      backgroundBrand: Color.lerp(backgroundBrand, other.backgroundBrand, t)!,
      backgroundActive:
          Color.lerp(backgroundActive, other.backgroundActive, t)!,
      backgroundHover: Color.lerp(backgroundHover, other.backgroundHover, t)!,
      backgroundSelected:
          Color.lerp(backgroundSelected, other.backgroundSelected, t)!,
      backgroundSelectedHover:
          Color.lerp(
            backgroundSelectedHover,
            other.backgroundSelectedHover,
            t,
          )!,
      layer01: Color.lerp(layer01, other.layer01, t)!,
      layer02: Color.lerp(layer02, other.layer02, t)!,
      layer03: Color.lerp(layer03, other.layer03, t)!,
      layerActive01: Color.lerp(layerActive01, other.layerActive01, t)!,
      layerHover01: Color.lerp(layerHover01, other.layerHover01, t)!,
      layerSelected01: Color.lerp(layerSelected01, other.layerSelected01, t)!,
      layerSelectedHover01:
          Color.lerp(layerSelectedHover01, other.layerSelectedHover01, t)!,
      layerActive02: Color.lerp(layerActive02, other.layerActive02, t)!,
      layerHover02: Color.lerp(layerHover02, other.layerHover02, t)!,
      layerSelected02: Color.lerp(layerSelected02, other.layerSelected02, t)!,
      layerSelectedHover02:
          Color.lerp(layerSelectedHover02, other.layerSelectedHover02, t)!,
      layerActive03: Color.lerp(layerActive03, other.layerActive03, t)!,
      layerHover03: Color.lerp(layerHover03, other.layerHover03, t)!,
      layerSelected03: Color.lerp(layerSelected03, other.layerSelected03, t)!,
      layerSelectedHover03:
          Color.lerp(layerSelectedHover03, other.layerSelectedHover03, t)!,
      layerSelectedInverse:
          Color.lerp(layerSelectedInverse, other.layerSelectedInverse, t)!,
      layerSelectedDisabled:
          Color.lerp(layerSelectedDisabled, other.layerSelectedDisabled, t)!,
      layerAccent01: Color.lerp(layerAccent01, other.layerAccent01, t)!,
      layerAccentActive01:
          Color.lerp(layerAccentActive01, other.layerAccentActive01, t)!,
      layerAccentHover01:
          Color.lerp(layerAccentHover01, other.layerAccentHover01, t)!,
      layerAccent02: Color.lerp(layerAccent02, other.layerAccent02, t)!,
      layerAccentActive02:
          Color.lerp(layerAccentActive02, other.layerAccentActive02, t)!,
      layerAccentHover02:
          Color.lerp(layerAccentHover02, other.layerAccentHover02, t)!,
      layerAccent03: Color.lerp(layerAccent03, other.layerAccent03, t)!,
      layerAccentActive03:
          Color.lerp(layerAccentActive03, other.layerAccentActive03, t)!,
      layerAccentHover03:
          Color.lerp(layerAccentHover03, other.layerAccentHover03, t)!,
      field01: Color.lerp(field01, other.field01, t)!,
      fieldHover01: Color.lerp(fieldHover01, other.fieldHover01, t)!,
      field02: Color.lerp(field02, other.field02, t)!,
      fieldHover02: Color.lerp(fieldHover02, other.fieldHover02, t)!,
      field03: Color.lerp(field03, other.field03, t)!,
      fieldHover03: Color.lerp(fieldHover03, other.fieldHover03, t)!,
      borderSubtle00: Color.lerp(borderSubtle00, other.borderSubtle00, t)!,
      borderSubtle01: Color.lerp(borderSubtle01, other.borderSubtle01, t)!,
      borderSubtleSelected01:
          Color.lerp(borderSubtleSelected01, other.borderSubtleSelected01, t)!,
      borderSubtle02: Color.lerp(borderSubtle02, other.borderSubtle02, t)!,
      borderSubtleSelected02:
          Color.lerp(borderSubtleSelected02, other.borderSubtleSelected02, t)!,
      borderSubtle03: Color.lerp(borderSubtle03, other.borderSubtle03, t)!,
      borderSubtleSelected03:
          Color.lerp(borderSubtleSelected03, other.borderSubtleSelected03, t)!,
      borderStrong01: Color.lerp(borderStrong01, other.borderStrong01, t)!,
      borderStrong02: Color.lerp(borderStrong02, other.borderStrong02, t)!,
      borderStrong03: Color.lerp(borderStrong03, other.borderStrong03, t)!,
      borderTile01: Color.lerp(borderTile01, other.borderTile01, t)!,
      borderTile02: Color.lerp(borderTile02, other.borderTile02, t)!,
      borderTile03: Color.lerp(borderTile03, other.borderTile03, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      borderInteractive:
          Color.lerp(borderInteractive, other.borderInteractive, t)!,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textHelper: Color.lerp(textHelper, other.textHelper, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textOnColor: Color.lerp(textOnColor, other.textOnColor, t)!,
      textOnColorDisabled:
          Color.lerp(textOnColorDisabled, other.textOnColorDisabled, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      linkPrimary: Color.lerp(linkPrimary, other.linkPrimary, t)!,
      linkPrimaryHover:
          Color.lerp(linkPrimaryHover, other.linkPrimaryHover, t)!,
      linkSecondary: Color.lerp(linkSecondary, other.linkSecondary, t)!,
      linkInverse: Color.lerp(linkInverse, other.linkInverse, t)!,
      linkVisited: Color.lerp(linkVisited, other.linkVisited, t)!,
      linkInverseVisited:
          Color.lerp(linkInverseVisited, other.linkInverseVisited, t)!,
      linkInverseActive:
          Color.lerp(linkInverseActive, other.linkInverseActive, t)!,
      linkInverseHover:
          Color.lerp(linkInverseHover, other.linkInverseHover, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t)!,
      iconOnColor: Color.lerp(iconOnColor, other.iconOnColor, t)!,
      iconOnColorDisabled:
          Color.lerp(iconOnColorDisabled, other.iconOnColorDisabled, t)!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      iconInteractive: Color.lerp(iconInteractive, other.iconInteractive, t)!,
      supportError: Color.lerp(supportError, other.supportError, t)!,
      supportSuccess: Color.lerp(supportSuccess, other.supportSuccess, t)!,
      supportWarning: Color.lerp(supportWarning, other.supportWarning, t)!,
      supportInfo: Color.lerp(supportInfo, other.supportInfo, t)!,
      supportErrorInverse:
          Color.lerp(supportErrorInverse, other.supportErrorInverse, t)!,
      supportSuccessInverse:
          Color.lerp(supportSuccessInverse, other.supportSuccessInverse, t)!,
      supportWarningInverse:
          Color.lerp(supportWarningInverse, other.supportWarningInverse, t)!,
      supportInfoInverse:
          Color.lerp(supportInfoInverse, other.supportInfoInverse, t)!,
      supportCautionMinor:
          Color.lerp(supportCautionMinor, other.supportCautionMinor, t)!,
      supportCautionMajor:
          Color.lerp(supportCautionMajor, other.supportCautionMajor, t)!,
      supportCautionUndefined:
          Color.lerp(
            supportCautionUndefined,
            other.supportCautionUndefined,
            t,
          )!,
      focus: Color.lerp(focus, other.focus, t)!,
      focusInset: Color.lerp(focusInset, other.focusInset, t)!,
      focusInverse: Color.lerp(focusInverse, other.focusInverse, t)!,
      skeletonBackground:
          Color.lerp(skeletonBackground, other.skeletonBackground, t)!,
      skeletonElement: Color.lerp(skeletonElement, other.skeletonElement, t)!,
      interactive: Color.lerp(interactive, other.interactive, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      toggleOff: Color.lerp(toggleOff, other.toggleOff, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

sealed class AppTheme {
  static ThemeData get lightTheme =>
      ThemeData.light(useMaterial3: true).copyWith(
        extensions: [ThemeColor.light],
        splashColor: ThemeColor.light.backgroundSelectedHover,
      );

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
    extensions: [ThemeColor.dark],
    splashColor: ThemeColor.dark.backgroundSelectedHover,
  );
}
