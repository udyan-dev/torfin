import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

extension AppThemeExtension on BuildContext {
  Brightness get _brightness => Theme.of(this).brightness;

  AppColors get colors => AppColors.fromBrightness(_brightness);

  AppStyles get styles => AppStyles.fromColors(colors);
}

extension AppTextStyleExtension on AppTextStyle {
  TextStyle get textPrimary => copyWith(color: colors.textPrimary);

  TextStyle get textSecondary => copyWith(color: colors.textSecondary);

  TextStyle get textPlaceholder => copyWith(color: colors.textPlaceholder);

  TextStyle get textHelper => copyWith(color: colors.textHelper);

  TextStyle get textError => copyWith(color: colors.textError);

  TextStyle get textInverse => copyWith(color: colors.textInverse);

  TextStyle get textDisabled => copyWith(color: colors.textDisabled);

  TextStyle get textOnColor => copyWith(color: colors.textOnColor);

  TextStyle get textOnColorDisabled =>
      copyWith(color: colors.textOnColorDisabled);

  TextStyle get linkPrimary => copyWith(color: colors.linkPrimary);

  TextStyle get linkPrimaryHover => copyWith(color: colors.linkPrimaryHover);

  TextStyle get linkSecondary => copyWith(color: colors.linkSecondary);

  TextStyle get linkInverse => copyWith(color: colors.linkInverse);

  TextStyle get linkVisited => copyWith(color: colors.linkVisited);

  TextStyle get iconPrimary => copyWith(color: colors.iconPrimary);

  TextStyle get iconSecondary => copyWith(color: colors.iconSecondary);

  TextStyle get iconInverse => copyWith(color: colors.iconInverse);

  TextStyle get iconOnColor => copyWith(color: colors.iconOnColor);

  TextStyle get iconDisabled => copyWith(color: colors.iconDisabled);

  TextStyle get iconInteractive => copyWith(color: colors.iconInteractive);

  TextStyle get supportError => copyWith(color: colors.supportError);

  TextStyle get supportSuccess => copyWith(color: colors.supportSuccess);

  TextStyle get supportWarning => copyWith(color: colors.supportWarning);

  TextStyle get supportInfo => copyWith(color: colors.supportInfo);

  TextStyle get background => copyWith(color: colors.background);

  TextStyle get backgroundInverse => copyWith(color: colors.backgroundInverse);

  TextStyle get backgroundBrand => copyWith(color: colors.backgroundBrand);

  TextStyle get backgroundActive => copyWith(color: colors.backgroundActive);

  TextStyle get backgroundHover => copyWith(color: colors.backgroundHover);

  TextStyle get backgroundSelected =>
      copyWith(color: colors.backgroundSelected);

  TextStyle get layer01 => copyWith(color: colors.layer01);

  TextStyle get layer02 => copyWith(color: colors.layer02);

  TextStyle get layer03 => copyWith(color: colors.layer03);

  TextStyle get layerActive01 => copyWith(color: colors.layerActive01);

  TextStyle get layerActive02 => copyWith(color: colors.layerActive02);

  TextStyle get layerActive03 => copyWith(color: colors.layerActive03);

  TextStyle get layerHover01 => copyWith(color: colors.layerHover01);

  TextStyle get layerHover02 => copyWith(color: colors.layerHover02);

  TextStyle get layerHover03 => copyWith(color: colors.layerHover03);

  TextStyle get layerSelected01 => copyWith(color: colors.layerSelected01);

  TextStyle get layerSelected02 => copyWith(color: colors.layerSelected02);

  TextStyle get layerSelected03 => copyWith(color: colors.layerSelected03);

  TextStyle get field01 => copyWith(color: colors.field01);

  TextStyle get field02 => copyWith(color: colors.field02);

  TextStyle get field03 => copyWith(color: colors.field03);

  TextStyle get fieldHover01 => copyWith(color: colors.fieldHover01);

  TextStyle get fieldHover02 => copyWith(color: colors.fieldHover02);

  TextStyle get fieldHover03 => copyWith(color: colors.fieldHover03);

  TextStyle get borderSubtle00 => copyWith(color: colors.borderSubtle00);

  TextStyle get borderSubtle01 => copyWith(color: colors.borderSubtle01);

  TextStyle get borderSubtle02 => copyWith(color: colors.borderSubtle02);

  TextStyle get borderSubtle03 => copyWith(color: colors.borderSubtle03);

  TextStyle get borderStrong01 => copyWith(color: colors.borderStrong01);

  TextStyle get borderStrong02 => copyWith(color: colors.borderStrong02);

  TextStyle get borderStrong03 => copyWith(color: colors.borderStrong03);

  TextStyle get borderInverse => copyWith(color: colors.borderInverse);

  TextStyle get borderInteractive => copyWith(color: colors.borderInteractive);

  TextStyle get borderDisabled => copyWith(color: colors.borderDisabled);

  TextStyle get focus => copyWith(color: colors.focus);

  TextStyle get focusInset => copyWith(color: colors.focusInset);

  TextStyle get focusInverse => copyWith(color: colors.focusInverse);

  TextStyle get interactive => copyWith(color: colors.interactive);

  TextStyle get highlight => copyWith(color: colors.highlight);

  TextStyle get overlay => copyWith(color: colors.overlay);

  TextStyle get toggleOff => copyWith(color: colors.toggleOff);

  TextStyle get shadow => copyWith(color: colors.shadow);

  TextStyle get skeletonBackground =>
      copyWith(color: colors.skeletonBackground);

  TextStyle get skeletonElement => copyWith(color: colors.skeletonElement);

  TextStyle get buttonPrimary => copyWith(color: colors.buttonPrimary);

  TextStyle get buttonSecondary => copyWith(color: colors.buttonSecondary);

  TextStyle get buttonTertiary => copyWith(color: colors.buttonTertiary);

  TextStyle get buttonDangerPrimary =>
      copyWith(color: colors.buttonDangerPrimary);

  TextStyle get buttonDangerSecondary =>
      copyWith(color: colors.buttonDangerSecondary);

  TextStyle get buttonDisabled => copyWith(color: colors.buttonDisabled);

  TextStyle get tagColorRed => copyWith(color: colors.tagColorRed);

  TextStyle get tagColorMagenta => copyWith(color: colors.tagColorMagenta);

  TextStyle get tagColorPurple => copyWith(color: colors.tagColorPurple);

  TextStyle get tagColorBlue => copyWith(color: colors.tagColorBlue);

  TextStyle get tagColorCyan => copyWith(color: colors.tagColorCyan);

  TextStyle get tagColorTeal => copyWith(color: colors.tagColorTeal);

  TextStyle get tagColorGreen => copyWith(color: colors.tagColorGreen);

  TextStyle get tagColorGray => copyWith(color: colors.tagColorGray);

  TextStyle get tagColorCoolGray => copyWith(color: colors.tagColorCoolGray);

  TextStyle get tagColorWarmGray => copyWith(color: colors.tagColorWarmGray);

  TextStyle get statusRed => copyWith(color: colors.statusRed);

  TextStyle get statusOrange => copyWith(color: colors.statusOrange);

  TextStyle get statusYellow => copyWith(color: colors.statusYellow);

  TextStyle get statusPurple => copyWith(color: colors.statusPurple);

  TextStyle get statusGreen => copyWith(color: colors.statusGreen);

  TextStyle get statusBlue => copyWith(color: colors.statusBlue);

  TextStyle get statusGray => copyWith(color: colors.statusGray);
}
