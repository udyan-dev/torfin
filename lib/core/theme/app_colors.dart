import 'package:flutter/material.dart';

class AppColors {
  final bool _isDark;

  const AppColors._(this._isDark);

  factory AppColors.fromBrightness(Brightness brightness) =>
      AppColors._(brightness == Brightness.dark);

  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightBackgroundInverse = Color(0xFF393939);
  static const Color _lightBackgroundBrand = Color(0xFF0F62FE);
  static const Color _lightBackgroundActive = Color(0x668D8D96);
  static const Color _lightBackgroundHover = Color(0x1F8D8D96);
  static const Color _lightBackgroundInverseHover = Color(0xFFE8E8E8);
  static const Color _lightBackgroundSelected = Color(0x338D8D96);
  static const Color _lightBackgroundSelectedHover = Color(0x528D8D96);

  static const Color _lightLayer01 = Color(0xFFF4F4F4);
  static const Color _lightLayerActive01 = Color(0xFFC6C6C6);
  static const Color _lightLayerBackground01 = Color(0xFFFFFFFF);
  static const Color _lightLayerHover01 = Color(0xFFE8E8E8);
  static const Color _lightLayerSelected01 = Color(0xFFE0E0E0);
  static const Color _lightLayerSelectedHover01 = Color(0xFFD1D1D1);

  static const Color _lightLayer02 = Color(0xFFFFFFFF);
  static const Color _lightLayerActive02 = Color(0xFFC6C6C6);
  static const Color _lightLayerBackground02 = Color(0xFFF4F4F4);
  static const Color _lightLayerHover02 = Color(0xFFE8E8E8);
  static const Color _lightLayerSelected02 = Color(0xFFE0E0E0);
  static const Color _lightLayerSelectedHover02 = Color(0xFFD1D1D1);

  static const Color _lightLayer03 = Color(0xFFF4F4F4);
  static const Color _lightLayerActive03 = Color(0xFFC6C6C6);
  static const Color _lightLayerBackground03 = Color(0xFFFFFFFF);
  static const Color _lightLayerHover03 = Color(0xFFE8E8E8);
  static const Color _lightLayerSelected03 = Color(0xFFE0E0E0);
  static const Color _lightLayerSelectedHover03 = Color(0xFFD1D1D1);

  static const Color _lightLayerSelectedInverse = Color(0xFF161616);
  static const Color _lightLayerSelectedDisabled = Color(0xFF8D8D8D);

  static const Color _lightLayerAccent01 = Color(0xFFE0E0E0);
  static const Color _lightLayerAccentActive01 = Color(0xFFA8A8A8);
  static const Color _lightLayerAccentHover01 = Color(0xFFD1D1D1);

  static const Color _lightLayerAccent02 = Color(0xFFE0E0E0);
  static const Color _lightLayerAccentActive02 = Color(0xFFA8A8A8);
  static const Color _lightLayerAccentHover02 = Color(0xFFD1D1D1);

  static const Color _lightLayerAccent03 = Color(0xFFE0E0E0);
  static const Color _lightLayerAccentActive03 = Color(0xFFA8A8A8);
  static const Color _lightLayerAccentHover03 = Color(0xFFD1D1D1);

  static const Color _lightField01 = Color(0xFFF4F4F4);
  static const Color _lightFieldHover01 = Color(0xFFE8E8E8);

  static const Color _lightField02 = Color(0xFFFFFFFF);
  static const Color _lightFieldHover02 = Color(0xFFE8E8E8);

  static const Color _lightField03 = Color(0xFFF4F4F4);
  static const Color _lightFieldHover03 = Color(0xFFE8E8E8);

  static const Color _lightBorderSubtle00 = Color(0xFFE0E0E0);
  static const Color _lightBorderSubtle01 = Color(0xFFC6C6C6);
  static const Color _lightBorderSubtleSelected01 = Color(0xFFC6C6C6);
  static const Color _lightBorderSubtle02 = Color(0xFFE0E0E0);
  static const Color _lightBorderSubtleSelected02 = Color(0xFFC6C6C6);
  static const Color _lightBorderSubtle03 = Color(0xFFC6C6C6);
  static const Color _lightBorderSubtleSelected03 = Color(0xFFC6C6C6);

  static const Color _lightBorderStrong01 = Color(0xFF8D8D8D);
  static const Color _lightBorderStrong02 = Color(0xFF8D8D8D);
  static const Color _lightBorderStrong03 = Color(0xFF8D8D8D);

  static const Color _lightBorderTile01 = Color(0xFFC6C6C6);
  static const Color _lightBorderTile02 = Color(0xFFA8A8A8);
  static const Color _lightBorderTile03 = Color(0xFFC6C6C6);

  static const Color _lightBorderInverse = Color(0xFF161616);
  static const Color _lightBorderInteractive = Color(0xFF0F62FE);
  static const Color _lightBorderDisabled = Color(0xFFC6C6C6);

  static const Color _lightTextPrimary = Color(0xFF161616);
  static const Color _lightTextSecondary = Color(0xFF525252);
  static const Color _lightTextPlaceholder = Color(0x66161616);
  static const Color _lightTextHelper = Color(0xFF6F6F6F);
  static const Color _lightTextError = Color(0xFFDA1E28);
  static const Color _lightTextInverse = Color(0xFFFFFFFF);
  static const Color _lightTextOnColor = Color(0xFFFFFFFF);
  static const Color _lightTextOnColorDisabled = Color(0xFF8D8D8D);
  static const Color _lightTextDisabled = Color(0x40161616);

  static const Color _lightLinkPrimary = Color(0xFF0F62FE);
  static const Color _lightLinkPrimaryHover = Color(0xFF0043CE);
  static const Color _lightLinkSecondary = Color(0xFF0043CE);
  static const Color _lightLinkInverse = Color(0xFF78A9FF);
  static const Color _lightLinkVisited = Color(0xFF8A3FFC);
  static const Color _lightLinkInverseVisited = Color(0xFFBE95FF);
  static const Color _lightLinkInverseActive = Color(0xFFF4F4F4);
  static const Color _lightLinkInverseHover = Color(0xFFA6C8FF);

  static const Color _lightIconPrimary = Color(0xFF161616);
  static const Color _lightIconSecondary = Color(0xFF525252);
  static const Color _lightIconInverse = Color(0xFFFFFFFF);
  static const Color _lightIconOnColor = Color(0xFFFFFFFF);
  static const Color _lightIconOnColorDisabled = Color(0xFF8D8D8D);
  static const Color _lightIconDisabled = Color(0x40161616);
  static const Color _lightIconInteractive = Color(0xFF0F62FE);

  static const Color _lightSupportError = Color(0xFFDA1E28);
  static const Color _lightSupportSuccess = Color(0xFF24A148);
  static const Color _lightSupportWarning = Color(0xFFF1C21B);
  static const Color _lightSupportInfo = Color(0xFF0043CE);
  static const Color _lightSupportErrorInverse = Color(0xFFFA4D56);
  static const Color _lightSupportSuccessInverse = Color(0xFF42BE65);
  static const Color _lightSupportWarningInverse = Color(0xFFF1C21B);
  static const Color _lightSupportInfoInverse = Color(0xFF4589FF);
  static const Color _lightSupportCautionMinor = Color(0xFFF1C21B);
  static const Color _lightSupportCautionMajor = Color(0xFFFF832B);
  static const Color _lightSupportCautionUndefined = Color(0xFF8A3FFC);

  static const Color _lightFocus = Color(0xFF0F62FE);
  static const Color _lightFocusInset = Color(0xFFFFFFFF);
  static const Color _lightFocusInverse = Color(0xFFFFFFFF);

  static const Color _lightSkeletonBackground = Color(0xFFE5E5E5);
  static const Color _lightSkeletonElement = Color(0xFFC6C6C6);

  static const Color _lightInteractive = Color(0xFF0F62FE);
  static const Color _lightHighlight = Color(0xFFD0E2FF);
  static const Color _lightOverlay = Color(0x80161616);
  static const Color _lightToggleOff = Color(0xFF8D8D8D);
  static const Color _lightShadow = Color(0x4D000000);

  static const Color _lightAiInnerShadow = Color(0x1A4589FF);
  static const Color _lightAiAuraStartSm = Color(0x294589FF);
  static const Color _lightAiAuraStart = Color(0x1A4589FF);
  static const Color _lightAiAuraEnd = Color(0x00FFFFFF);
  static const Color _lightAiBorderStrong = Color(0xFF4589FF);
  static const Color _lightAiBorderStart = Color(0xA3A6C8FF);
  static const Color _lightAiBorderEnd = Color(0xFF78A9FF);
  static const Color _lightAiDropShadow = Color(0x1A0F62FE);
  static const Color _lightAiAuraHoverBackground = Color(0xFFEDF5FF);
  static const Color _lightAiAuraHoverStart = Color(0x524589FF);
  static const Color _lightAiAuraHoverEnd = Color(0x00FFFFFF);

  static const Color _lightAiPopoverBackground = Color(0xFFFFFFFF);
  static const Color _lightAiPopoverShadowOuter01 = Color(0x0F0043CE);
  static const Color _lightAiPopoverShadowOuter02 = Color(0x0A000000);

  static const Color _lightAiSkeletonBackground = Color(0xFFD0E2FF);
  static const Color _lightAiSkeletonElementBackground = Color(0xFF4589FF);

  static const Color _lightAiOverlay = Color(0x80001141);

  static const Color _lightAiPopoverCaretCenter = Color(0xFFA0C3FF);
  static const Color _lightAiPopoverCaretBottom = Color(0xFF78A9FF);
  static const Color _lightAiPopoverCaretBottomBackgroundActions = Color(
    0xFFE9EFFA,
  );
  static const Color _lightAiPopoverCaretBottomBackground = Color(0xFFEAF1FF);

  static const Color _lightChatPromptBackground = Color(0xFFFFFFFF);
  static const Color _lightChatPromptBorderStart = Color(0xFFF4F4F4);
  static const Color _lightChatPromptBorderEnd = Color(0x00F4F4F4);
  static const Color _lightChatBubbleUser = Color(0xFFE0E0E0);
  static const Color _lightChatBubbleAgent = Color(0xFFFFFFFF);
  static const Color _lightChatBubbleBorder = Color(0xFFE0E0E0);
  static const Color _lightChatAvatarBot = Color(0xFF6F6F6F);
  static const Color _lightChatAvatarAgent = Color(0xFF393939);
  static const Color _lightChatAvatarUser = Color(0xFF0F62FE);
  static const Color _lightChatShellBackground = Color(0xFFFFFFFF);
  static const Color _lightChatHeaderBackground = Color(0xFFFFFFFF);

  static const Color _lightChatButton = Color(0xFF0F62FE);
  static const Color _lightChatButtonHover = Color(0x1F8D8D96);
  static const Color _lightChatButtonTextHover = Color(0xFF0043CE);
  static const Color _lightChatButtonActive = Color(0x668D8D96);
  static const Color _lightChatButtonSelected = Color(0x338D8D96);
  static const Color _lightChatButtonTextSelected = Color(0xFF525252);

  static const Color _lightButtonSeparator = Color(0xFFE0E0E0);
  static const Color _lightButtonPrimary = Color(0xFF0F62FE);
  static const Color _lightButtonSecondary = Color(0xFF393939);
  static const Color _lightButtonTertiary = Color(0xFF0F62FE);
  static const Color _lightButtonDangerPrimary = Color(0xFFDA1E28);
  static const Color _lightButtonDangerSecondary = Color(0xFFDA1E28);
  static const Color _lightButtonDangerActive = Color(0xFF750E13);
  static const Color _lightButtonPrimaryActive = Color(0xFF002D9C);
  static const Color _lightButtonSecondaryActive = Color(0xFF6F6F6F);
  static const Color _lightButtonTertiaryActive = Color(0xFF002D9C);
  static const Color _lightButtonDangerHover = Color(0xFFB81921);
  static const Color _lightButtonPrimaryHover = Color(0xFF0050E6);
  static const Color _lightButtonSecondaryHover = Color(0xFF474747);
  static const Color _lightButtonTertiaryHover = Color(0xFF0050E6);
  static const Color _lightButtonDisabled = Color(0xFFC6C6C6);

  static const Color _lightContentSwitcherSelected = Color(0xFFFFFFFF);
  static const Color _lightContentSwitcherBackground = Color(0xFFE0E0E0);
  static const Color _lightContentSwitcherBackgroundHover = Color(0xFFD1D1D1);

  static const Color _lightNotificationBackgroundError = Color(0xFFFFF1F1);
  static const Color _lightNotificationBackgroundSuccess = Color(0xFFDEFBE6);
  static const Color _lightNotificationBackgroundInfo = Color(0xFFEDF5FF);
  static const Color _lightNotificationBackgroundWarning = Color(0xFFFCF4D6);
  static const Color _lightNotificationActionHover = Color(0xFFFFFFFF);

  static const Color _lightStatusRed = Color(0xFFDA1E28);
  static const Color _lightStatusOrange = Color(0xFFFF832B);
  static const Color _lightStatusOrangeOutline = Color(0xFFEB6200);
  static const Color _lightStatusYellow = Color(0xFFF1C21B);
  static const Color _lightStatusYellowOutline = Color(0xFFB28600);
  static const Color _lightStatusPurple = Color(0xFF8A3FFC);
  static const Color _lightStatusGreen = Color(0xFF24A148);
  static const Color _lightStatusBlue = Color(0xFF0043CE);
  static const Color _lightStatusGray = Color(0xFF6F6F6F);
  static const Color _lightStatusAccessibilityBackground = Color(0xFFFFFFFF);

  static const Color _lightTagBackgroundRed = Color(0xFFFFD7D9);
  static const Color _lightTagColorRed = Color(0xFFA2191F);
  static const Color _lightTagHoverRed = Color(0xFFFFC2C5);
  static const Color _lightTagBorderRed = Color(0xFFFF8389);
  static const Color _lightTagBackgroundMagenta = Color(0xFFFFD6E8);
  static const Color _lightTagColorMagenta = Color(0xFF9F1853);
  static const Color _lightTagHoverMagenta = Color(0xFFFFBDDA);
  static const Color _lightTagBorderMagenta = Color(0xFFFF7EB6);
  static const Color _lightTagBackgroundPurple = Color(0xFFE8DAFF);
  static const Color _lightTagColorPurple = Color(0xFF6929C4);
  static const Color _lightTagHoverPurple = Color(0xFFDCC7FF);
  static const Color _lightTagBorderPurple = Color(0xFFBE95FF);
  static const Color _lightTagBackgroundBlue = Color(0xFFD0E2FF);
  static const Color _lightTagColorBlue = Color(0xFF0043CE);
  static const Color _lightTagHoverBlue = Color(0xFFB8D3FF);
  static const Color _lightTagBorderBlue = Color(0xFF78A9FF);
  static const Color _lightTagBackgroundCyan = Color(0xFFBAE6FF);
  static const Color _lightTagColorCyan = Color(0xFF00539A);
  static const Color _lightTagHoverCyan = Color(0xFF99DAFF);
  static const Color _lightTagBorderCyan = Color(0xFF33B1FF);
  static const Color _lightTagBackgroundTeal = Color(0xFF9EF0F0);
  static const Color _lightTagColorTeal = Color(0xFF005D5D);
  static const Color _lightTagHoverTeal = Color(0xFF57E5E5);
  static const Color _lightTagBorderTeal = Color(0xFF08BDBA);
  static const Color _lightTagBackgroundGreen = Color(0xFFA7F0BA);
  static const Color _lightTagColorGreen = Color(0xFF0E6027);
  static const Color _lightTagHoverGreen = Color(0xFF74E792);
  static const Color _lightTagBorderGreen = Color(0xFF42BE65);
  static const Color _lightTagBackgroundGray = Color(0xFFE0E0E0);
  static const Color _lightTagColorGray = Color(0xFF161616);
  static const Color _lightTagHoverGray = Color(0xFFD1D1D1);
  static const Color _lightTagBorderGray = Color(0xFFA8A8A8);
  static const Color _lightTagBackgroundCoolGray = Color(0xFFDDE1E6);
  static const Color _lightTagColorCoolGray = Color(0xFF121619);
  static const Color _lightTagHoverCoolGray = Color(0xFFCDD3DA);
  static const Color _lightTagBorderCoolGray = Color(0xFFA2A9B0);
  static const Color _lightTagBackgroundWarmGray = Color(0xFFE5E0DF);
  static const Color _lightTagColorWarmGray = Color(0xFF171414);
  static const Color _lightTagHoverWarmGray = Color(0xFFD8D0CF);
  static const Color _lightTagBorderWarmGray = Color(0xFFADA8A8);

  static const Color _darkBackground = Color(0xFF161616);
  static const Color _darkBackgroundInverse = Color(0xFFF4F4F4);
  static const Color _darkBackgroundBrand = Color(0xFF0F62FE);
  static const Color _darkBackgroundActive = Color(0x668D8D96);
  static const Color _darkBackgroundHover = Color(0x298D8D96);
  static const Color _darkBackgroundInverseHover = Color(0xFFE8E8E8);
  static const Color _darkBackgroundSelected = Color(0x3D8D8D96);
  static const Color _darkBackgroundSelectedHover = Color(0x528D8D96);

  static const Color _darkLayer01 = Color(0xFF262626);
  static const Color _darkLayerActive01 = Color(0xFF525252);
  static const Color _darkLayerBackground01 = Color(0xFF161616);
  static const Color _darkLayerHover01 = Color(0xFF333333);
  static const Color _darkLayerSelected01 = Color(0xFF393939);
  static const Color _darkLayerSelectedHover01 = Color(0xFF474747);

  static const Color _darkLayer02 = Color(0xFF393939);
  static const Color _darkLayerActive02 = Color(0xFF6F6F6F);
  static const Color _darkLayerBackground02 = Color(0xFF262626);
  static const Color _darkLayerHover02 = Color(0xFF474747);
  static const Color _darkLayerSelected02 = Color(0xFF525252);
  static const Color _darkLayerSelectedHover02 = Color(0xFF636363);

  static const Color _darkLayer03 = Color(0xFF525252);
  static const Color _darkLayerActive03 = Color(0xFF8D8D8D);
  static const Color _darkLayerBackground03 = Color(0xFF393939);
  static const Color _darkLayerHover03 = Color(0xFF636363);
  static const Color _darkLayerSelected03 = Color(0xFF6F6F6F);
  static const Color _darkLayerSelectedHover03 = Color(0xFF5E5E5E);

  static const Color _darkLayerSelectedInverse = Color(0xFFF4F4F4);
  static const Color _darkLayerSelectedDisabled = Color(0xFFA8A8A8);

  static const Color _darkLayerAccent01 = Color(0xFF393939);
  static const Color _darkLayerAccentActive01 = Color(0xFF6F6F6F);
  static const Color _darkLayerAccentHover01 = Color(0xFF474747);

  static const Color _darkLayerAccent02 = Color(0xFF525252);
  static const Color _darkLayerAccentActive02 = Color(0xFF8D8D8D);
  static const Color _darkLayerAccentHover02 = Color(0xFF636363);

  static const Color _darkLayerAccent03 = Color(0xFF6F6F6F);
  static const Color _darkLayerAccentActive03 = Color(0xFF393939);
  static const Color _darkLayerAccentHover03 = Color(0xFF5E5E5E);

  static const Color _darkField01 = Color(0xFF262626);
  static const Color _darkFieldHover01 = Color(0xFF333333);

  static const Color _darkField02 = Color(0xFF393939);
  static const Color _darkFieldHover02 = Color(0xFF474747);

  static const Color _darkField03 = Color(0xFF525252);
  static const Color _darkFieldHover03 = Color(0xFF636363);

  static const Color _darkBorderSubtle00 = Color(0xFF393939);
  static const Color _darkBorderSubtle01 = Color(0xFF525252);
  static const Color _darkBorderSubtleSelected01 = Color(0xFF6F6F6F);
  static const Color _darkBorderSubtle02 = Color(0xFF6F6F6F);
  static const Color _darkBorderSubtleSelected02 = Color(0xFF8D8D8D);
  static const Color _darkBorderSubtle03 = Color(0xFF6F6F6F);
  static const Color _darkBorderSubtleSelected03 = Color(0xFF8D8D8D);

  static const Color _darkBorderStrong01 = Color(0xFF6F6F6F);
  static const Color _darkBorderStrong02 = Color(0xFF8D8D8D);
  static const Color _darkBorderStrong03 = Color(0xFFA8A8A8);

  static const Color _darkBorderTile01 = Color(0xFF525252);
  static const Color _darkBorderTile02 = Color(0xFF6F6F6F);
  static const Color _darkBorderTile03 = Color(0xFF8D8D8D);

  static const Color _darkBorderInverse = Color(0xFFF4F4F4);
  static const Color _darkBorderInteractive = Color(0xFF4589FF);
  static const Color _darkBorderDisabled = Color(0x808D8D8D);

  static const Color _darkTextPrimary = Color(0xFFF4F4F4);
  static const Color _darkTextSecondary = Color(0xFFC6C6C6);
  static const Color _darkTextPlaceholder = Color(0x66F4F4F4);
  static const Color _darkTextHelper = Color(0xFFA8A8A8);
  static const Color _darkTextError = Color(0xFFFF8389);
  static const Color _darkTextInverse = Color(0xFF161616);
  static const Color _darkTextOnColor = Color(0xFFFFFFFF);
  static const Color _darkTextOnColorDisabled = Color(0x40FFFFFF);
  static const Color _darkTextDisabled = Color(0x40F4F4F4);

  static const Color _darkLinkPrimary = Color(0xFF78A9FF);
  static const Color _darkLinkPrimaryHover = Color(0xFFA6C8FF);
  static const Color _darkLinkSecondary = Color(0xFFA6C8FF);
  static const Color _darkLinkInverse = Color(0xFF0F62FE);
  static const Color _darkLinkVisited = Color(0xFFBE95FF);
  static const Color _darkLinkInverseVisited = Color(0xFF8A3FFC);
  static const Color _darkLinkInverseActive = Color(0xFF161616);
  static const Color _darkLinkInverseHover = Color(0xFF0043CE);

  static const Color _darkIconPrimary = Color(0xFFF4F4F4);
  static const Color _darkIconSecondary = Color(0xFFC6C6C6);
  static const Color _darkIconInverse = Color(0xFF161616);
  static const Color _darkIconOnColor = Color(0xFFFFFFFF);
  static const Color _darkIconOnColorDisabled = Color(0x40FFFFFF);
  static const Color _darkIconDisabled = Color(0x40F4F4F4);
  static const Color _darkIconInteractive = Color(0xFFFFFFFF);

  static const Color _darkSupportError = Color(0xFFFA4D56);
  static const Color _darkSupportSuccess = Color(0xFF42BE65);
  static const Color _darkSupportWarning = Color(0xFFF1C21B);
  static const Color _darkSupportInfo = Color(0xFF4589FF);
  static const Color _darkSupportErrorInverse = Color(0xFFDA1E28);
  static const Color _darkSupportSuccessInverse = Color(0xFF24A148);
  static const Color _darkSupportWarningInverse = Color(0xFFF1C21B);
  static const Color _darkSupportInfoInverse = Color(0xFF0043CE);
  static const Color _darkSupportCautionMinor = Color(0xFFF1C21B);
  static const Color _darkSupportCautionMajor = Color(0xFFFF832B);
  static const Color _darkSupportCautionUndefined = Color(0xFFA56EFF);

  static const Color _darkFocus = Color(0xFFFFFFFF);
  static const Color _darkFocusInset = Color(0xFF161616);
  static const Color _darkFocusInverse = Color(0xFF0F62FE);

  static const Color _darkSkeletonBackground = Color(0xFF1F1F23);
  static const Color _darkSkeletonElement = Color(0xFF393939);

  static const Color _darkInteractive = Color(0xFF4589FF);
  static const Color _darkHighlight = Color(0xFF001D6C);
  static const Color _darkOverlay = Color(0xA6000000);
  static const Color _darkToggleOff = Color(0xFF6F6F6F);
  static const Color _darkShadow = Color(0xCC000000);

  static const Color _darkAiInnerShadow = Color(0x294589FF);
  static const Color _darkAiAuraStartSm = Color(0x294589FF);
  static const Color _darkAiAuraStart = Color(0x1A4589FF);
  static const Color _darkAiAuraEnd = Color(0x00000000);
  static const Color _darkAiBorderStrong = Color(0xFF78A9FF);
  static const Color _darkAiBorderStart = Color(0x5CA6C8FF);
  static const Color _darkAiBorderEnd = Color(0xFF4589FF);
  static const Color _darkAiDropShadow = Color(0x47000000);
  static const Color _darkAiAuraHoverBackground = Color(0xFF333333);
  static const Color _darkAiAuraHoverStart = Color(0x664589FF);
  static const Color _darkAiAuraHoverEnd = Color(0x00000000);

  static const Color _darkAiPopoverBackground = Color(0xFF161616);
  static const Color _darkAiPopoverShadowOuter01 = Color(0x1F000000);
  static const Color _darkAiPopoverShadowOuter02 = Color(0x14000000);

  static const Color _darkAiSkeletonBackground = Color(0x8078A9FF);
  static const Color _darkAiSkeletonElementBackground = Color(0x4D78A9FF);

  static const Color _darkAiOverlay = Color(0x80000000);

  static const Color _darkAiPopoverCaretCenter = Color(0xFF4870B5);
  static const Color _darkAiPopoverCaretBottom = Color(0xFF4589FF);
  static const Color _darkAiPopoverCaretBottomBackgroundActions = Color(
    0xFF1E283A,
  );
  static const Color _darkAiPopoverCaretBottomBackground = Color(0xFF202D45);

  static const Color _darkChatPromptBackground = Color(0xFF161616);
  static const Color _darkChatPromptBorderStart = Color(0xFF262626);
  static const Color _darkChatPromptBorderEnd = Color(0x00262626);
  static const Color _darkChatBubbleUser = Color(0xFF393939);
  static const Color _darkChatBubbleAgent = Color(0xFF262626);
  static const Color _darkChatBubbleBorder = Color(0xFF525252);
  static const Color _darkChatAvatarBot = Color(0xFF8D8D8D);
  static const Color _darkChatAvatarAgent = Color(0xFFC6C6C6);
  static const Color _darkChatAvatarUser = Color(0xFF4589FF);
  static const Color _darkChatShellBackground = Color(0xFF262626);
  static const Color _darkChatHeaderBackground = Color(0xFF262626);

  static const Color _darkChatButton = Color(0xFF78A9FF);
  static const Color _darkChatButtonHover = Color(0x298D8D96);
  static const Color _darkChatButtonTextHover = Color(0xFFA6C8FF);
  static const Color _darkChatButtonActive = Color(0x668D8D96);
  static const Color _darkChatButtonSelected = Color(0x3D8D8D96);
  static const Color _darkChatButtonTextSelected = Color(0xFFC6C6C6);

  static const Color _darkButtonSeparator = Color(0xFF161616);
  static const Color _darkButtonPrimary = Color(0xFF0F62FE);
  static const Color _darkButtonSecondary = Color(0xFF6F6F6F);
  static const Color _darkButtonTertiary = Color(0xFFFFFFFF);
  static const Color _darkButtonDangerPrimary = Color(0xFFDA1E28);
  static const Color _darkButtonDangerSecondary = Color(0xFFFA4D56);
  static const Color _darkButtonDangerActive = Color(0xFF750E13);
  static const Color _darkButtonPrimaryActive = Color(0xFF002D9C);
  static const Color _darkButtonSecondaryActive = Color(0xFF393939);
  static const Color _darkButtonTertiaryActive = Color(0xFFC6C6C6);
  static const Color _darkButtonDangerHover = Color(0xFFB81921);
  static const Color _darkButtonPrimaryHover = Color(0xFF0050E6);
  static const Color _darkButtonSecondaryHover = Color(0xFF5E5E5E);
  static const Color _darkButtonTertiaryHover = Color(0xFFF4F4F4);
  static const Color _darkButtonDisabled = Color(0x4D8D8D8D);

  static const Color _darkContentSwitcherSelected = Color(0x3D8D8D8D);
  static const Color _darkContentSwitcherBackground = Color(0x00000000);
  static const Color _darkContentSwitcherBackgroundHover = Color(0x1F8D8D8D);

  static const Color _darkNotificationBackgroundError = Color(0xFF393939);
  static const Color _darkNotificationBackgroundSuccess = Color(0xFF393939);
  static const Color _darkNotificationBackgroundInfo = Color(0xFF393939);
  static const Color _darkNotificationBackgroundWarning = Color(0xFF393939);

  static const Color _darkStatusRed = Color(0xFFFA4D56);
  static const Color _darkStatusOrange = Color(0xFFFF832B);
  static const Color _darkStatusYellow = Color(0xFFF1C21B);
  static const Color _darkStatusPurple = Color(0xFFA56EFF);
  static const Color _darkStatusGreen = Color(0xFF42BE65);
  static const Color _darkStatusBlue = Color(0xFF4589FF);
  static const Color _darkStatusGray = Color(0xFF8D8D8D);
  static const Color _darkStatusAccessibilityBackground = Color(0xFF161616);

  static const Color _darkTagBackgroundRed = Color(0xFFA2191F);
  static const Color _darkTagColorRed = Color(0xFFFFD7D9);
  static const Color _darkTagHoverRed = Color(0xFFC21E25);
  static const Color _darkTagBorderRed = Color(0xFFFA4D56);
  static const Color _darkTagBackgroundMagenta = Color(0xFF9F1853);
  static const Color _darkTagColorMagenta = Color(0xFFFFD6E8);
  static const Color _darkTagHoverMagenta = Color(0xFFBF1D63);
  static const Color _darkTagBorderMagenta = Color(0xFFEE5396);
  static const Color _darkTagBackgroundPurple = Color(0xFF6929C4);
  static const Color _darkTagColorPurple = Color(0xFFE8DAFF);
  static const Color _darkTagHoverPurple = Color(0xFF7C3DD6);
  static const Color _darkTagBorderPurple = Color(0xFFA56EFF);
  static const Color _darkTagBackgroundBlue = Color(0xFF0043CE);
  static const Color _darkTagColorBlue = Color(0xFFD0E2FF);
  static const Color _darkTagHoverBlue = Color(0xFF0053FF);
  static const Color _darkTagBorderBlue = Color(0xFF4589FF);
  static const Color _darkTagBackgroundCyan = Color(0xFF00539A);
  static const Color _darkTagColorCyan = Color(0xFFBAE6FF);
  static const Color _darkTagHoverCyan = Color(0xFF0066BD);
  static const Color _darkTagBorderCyan = Color(0xFF1192E8);
  static const Color _darkTagBackgroundTeal = Color(0xFF005D5D);
  static const Color _darkTagColorTeal = Color(0xFF9EF0F0);
  static const Color _darkTagHoverTeal = Color(0xFF007070);
  static const Color _darkTagBorderTeal = Color(0xFF009D9A);
  static const Color _darkTagBackgroundGreen = Color(0xFF0E6027);
  static const Color _darkTagColorGreen = Color(0xFFA7F0BA);
  static const Color _darkTagHoverGreen = Color(0xFF11742F);
  static const Color _darkTagBorderGreen = Color(0xFF24A148);
  static const Color _darkTagBackgroundGray = Color(0xFF525252);
  static const Color _darkTagColorGray = Color(0xFFF4F4F4);
  static const Color _darkTagHoverGray = Color(0xFF636363);
  static const Color _darkTagBorderGray = Color(0xFF8D8D8D);
  static const Color _darkTagBackgroundCoolGray = Color(0xFF4D5358);
  static const Color _darkTagColorCoolGray = Color(0xFFF2F4F8);
  static const Color _darkTagHoverCoolGray = Color(0xFF5D646A);
  static const Color _darkTagBorderCoolGray = Color(0xFF878D96);
  static const Color _darkTagBackgroundWarmGray = Color(0xFF565151);
  static const Color _darkTagColorWarmGray = Color(0xFFF7F3F2);
  static const Color _darkTagHoverWarmGray = Color(0xFF696363);
  static const Color _darkTagBorderWarmGray = Color(0xFF8F8B8B);

  Color get background => _isDark ? _darkBackground : _lightBackground;

  Color get backgroundInverse =>
      _isDark ? _darkBackgroundInverse : _lightBackgroundInverse;

  Color get backgroundBrand =>
      _isDark ? _darkBackgroundBrand : _lightBackgroundBrand;

  Color get backgroundActive =>
      _isDark ? _darkBackgroundActive : _lightBackgroundActive;

  Color get backgroundHover =>
      _isDark ? _darkBackgroundHover : _lightBackgroundHover;

  Color get backgroundInverseHover =>
      _isDark ? _darkBackgroundInverseHover : _lightBackgroundInverseHover;

  Color get backgroundSelected =>
      _isDark ? _darkBackgroundSelected : _lightBackgroundSelected;

  Color get backgroundSelectedHover =>
      _isDark ? _darkBackgroundSelectedHover : _lightBackgroundSelectedHover;

  Color get layer01 => _isDark ? _darkLayer01 : _lightLayer01;

  Color get layerActive01 => _isDark ? _darkLayerActive01 : _lightLayerActive01;

  Color get layerBackground01 =>
      _isDark ? _darkLayerBackground01 : _lightLayerBackground01;

  Color get layerHover01 => _isDark ? _darkLayerHover01 : _lightLayerHover01;

  Color get layerSelected01 =>
      _isDark ? _darkLayerSelected01 : _lightLayerSelected01;

  Color get layerSelectedHover01 =>
      _isDark ? _darkLayerSelectedHover01 : _lightLayerSelectedHover01;

  Color get layer02 => _isDark ? _darkLayer02 : _lightLayer02;

  Color get layerActive02 => _isDark ? _darkLayerActive02 : _lightLayerActive02;

  Color get layerBackground02 =>
      _isDark ? _darkLayerBackground02 : _lightLayerBackground02;

  Color get layerHover02 => _isDark ? _darkLayerHover02 : _lightLayerHover02;

  Color get layerSelected02 =>
      _isDark ? _darkLayerSelected02 : _lightLayerSelected02;

  Color get layerSelectedHover02 =>
      _isDark ? _darkLayerSelectedHover02 : _lightLayerSelectedHover02;

  Color get layer03 => _isDark ? _darkLayer03 : _lightLayer03;

  Color get layerActive03 => _isDark ? _darkLayerActive03 : _lightLayerActive03;

  Color get layerBackground03 =>
      _isDark ? _darkLayerBackground03 : _lightLayerBackground03;

  Color get layerHover03 => _isDark ? _darkLayerHover03 : _lightLayerHover03;

  Color get layerSelected03 =>
      _isDark ? _darkLayerSelected03 : _lightLayerSelected03;

  Color get layerSelectedHover03 =>
      _isDark ? _darkLayerSelectedHover03 : _lightLayerSelectedHover03;

  Color get layerSelectedInverse =>
      _isDark ? _darkLayerSelectedInverse : _lightLayerSelectedInverse;

  Color get layerSelectedDisabled =>
      _isDark ? _darkLayerSelectedDisabled : _lightLayerSelectedDisabled;

  Color get layerAccent01 => _isDark ? _darkLayerAccent01 : _lightLayerAccent01;

  Color get layerAccentActive01 =>
      _isDark ? _darkLayerAccentActive01 : _lightLayerAccentActive01;

  Color get layerAccentHover01 =>
      _isDark ? _darkLayerAccentHover01 : _lightLayerAccentHover01;

  Color get layerAccent02 => _isDark ? _darkLayerAccent02 : _lightLayerAccent02;

  Color get layerAccentActive02 =>
      _isDark ? _darkLayerAccentActive02 : _lightLayerAccentActive02;

  Color get layerAccentHover02 =>
      _isDark ? _darkLayerAccentHover02 : _lightLayerAccentHover02;

  Color get layerAccent03 => _isDark ? _darkLayerAccent03 : _lightLayerAccent03;

  Color get layerAccentActive03 =>
      _isDark ? _darkLayerAccentActive03 : _lightLayerAccentActive03;

  Color get layerAccentHover03 =>
      _isDark ? _darkLayerAccentHover03 : _lightLayerAccentHover03;

  Color get field01 => _isDark ? _darkField01 : _lightField01;

  Color get fieldHover01 => _isDark ? _darkFieldHover01 : _lightFieldHover01;

  Color get field02 => _isDark ? _darkField02 : _lightField02;

  Color get fieldHover02 => _isDark ? _darkFieldHover02 : _lightFieldHover02;

  Color get field03 => _isDark ? _darkField03 : _lightField03;

  Color get fieldHover03 => _isDark ? _darkFieldHover03 : _lightFieldHover03;

  Color get borderSubtle00 =>
      _isDark ? _darkBorderSubtle00 : _lightBorderSubtle00;

  Color get borderSubtle01 =>
      _isDark ? _darkBorderSubtle01 : _lightBorderSubtle01;

  Color get borderSubtleSelected01 =>
      _isDark ? _darkBorderSubtleSelected01 : _lightBorderSubtleSelected01;

  Color get borderSubtle02 =>
      _isDark ? _darkBorderSubtle02 : _lightBorderSubtle02;

  Color get borderSubtleSelected02 =>
      _isDark ? _darkBorderSubtleSelected02 : _lightBorderSubtleSelected02;

  Color get borderSubtle03 =>
      _isDark ? _darkBorderSubtle03 : _lightBorderSubtle03;

  Color get borderSubtleSelected03 =>
      _isDark ? _darkBorderSubtleSelected03 : _lightBorderSubtleSelected03;

  Color get borderStrong01 =>
      _isDark ? _darkBorderStrong01 : _lightBorderStrong01;

  Color get borderStrong02 =>
      _isDark ? _darkBorderStrong02 : _lightBorderStrong02;

  Color get borderStrong03 =>
      _isDark ? _darkBorderStrong03 : _lightBorderStrong03;

  Color get borderTile01 => _isDark ? _darkBorderTile01 : _lightBorderTile01;

  Color get borderTile02 => _isDark ? _darkBorderTile02 : _lightBorderTile02;

  Color get borderTile03 => _isDark ? _darkBorderTile03 : _lightBorderTile03;

  Color get borderInverse => _isDark ? _darkBorderInverse : _lightBorderInverse;

  Color get borderInteractive =>
      _isDark ? _darkBorderInteractive : _lightBorderInteractive;

  Color get borderDisabled =>
      _isDark ? _darkBorderDisabled : _lightBorderDisabled;

  Color get textPrimary => _isDark ? _darkTextPrimary : _lightTextPrimary;

  Color get textSecondary => _isDark ? _darkTextSecondary : _lightTextSecondary;

  Color get textPlaceholder =>
      _isDark ? _darkTextPlaceholder : _lightTextPlaceholder;

  Color get textHelper => _isDark ? _darkTextHelper : _lightTextHelper;

  Color get textError => _isDark ? _darkTextError : _lightTextError;

  Color get textInverse => _isDark ? _darkTextInverse : _lightTextInverse;

  Color get textOnColor => _isDark ? _darkTextOnColor : _lightTextOnColor;

  Color get textOnColorDisabled =>
      _isDark ? _darkTextOnColorDisabled : _lightTextOnColorDisabled;

  Color get textDisabled => _isDark ? _darkTextDisabled : _lightTextDisabled;

  Color get linkPrimary => _isDark ? _darkLinkPrimary : _lightLinkPrimary;

  Color get linkPrimaryHover =>
      _isDark ? _darkLinkPrimaryHover : _lightLinkPrimaryHover;

  Color get linkSecondary => _isDark ? _darkLinkSecondary : _lightLinkSecondary;

  Color get linkInverse => _isDark ? _darkLinkInverse : _lightLinkInverse;

  Color get linkVisited => _isDark ? _darkLinkVisited : _lightLinkVisited;

  Color get linkInverseVisited =>
      _isDark ? _darkLinkInverseVisited : _lightLinkInverseVisited;

  Color get linkInverseActive =>
      _isDark ? _darkLinkInverseActive : _lightLinkInverseActive;

  Color get linkInverseHover =>
      _isDark ? _darkLinkInverseHover : _lightLinkInverseHover;

  Color get iconPrimary => _isDark ? _darkIconPrimary : _lightIconPrimary;

  Color get iconSecondary => _isDark ? _darkIconSecondary : _lightIconSecondary;

  Color get iconInverse => _isDark ? _darkIconInverse : _lightIconInverse;

  Color get iconOnColor => _isDark ? _darkIconOnColor : _lightIconOnColor;

  Color get iconOnColorDisabled =>
      _isDark ? _darkIconOnColorDisabled : _lightIconOnColorDisabled;

  Color get iconDisabled => _isDark ? _darkIconDisabled : _lightIconDisabled;

  Color get iconInteractive =>
      _isDark ? _darkIconInteractive : _lightIconInteractive;

  Color get supportError => _isDark ? _darkSupportError : _lightSupportError;

  Color get supportSuccess =>
      _isDark ? _darkSupportSuccess : _lightSupportSuccess;

  Color get supportWarning =>
      _isDark ? _darkSupportWarning : _lightSupportWarning;

  Color get supportInfo => _isDark ? _darkSupportInfo : _lightSupportInfo;

  Color get supportErrorInverse =>
      _isDark ? _darkSupportErrorInverse : _lightSupportErrorInverse;

  Color get supportSuccessInverse =>
      _isDark ? _darkSupportSuccessInverse : _lightSupportSuccessInverse;

  Color get supportWarningInverse =>
      _isDark ? _darkSupportWarningInverse : _lightSupportWarningInverse;

  Color get supportInfoInverse =>
      _isDark ? _darkSupportInfoInverse : _lightSupportInfoInverse;

  Color get supportCautionMinor =>
      _isDark ? _darkSupportCautionMinor : _lightSupportCautionMinor;

  Color get supportCautionMajor =>
      _isDark ? _darkSupportCautionMajor : _lightSupportCautionMajor;

  Color get supportCautionUndefined =>
      _isDark ? _darkSupportCautionUndefined : _lightSupportCautionUndefined;

  Color get focus => _isDark ? _darkFocus : _lightFocus;

  Color get focusInset => _isDark ? _darkFocusInset : _lightFocusInset;

  Color get focusInverse => _isDark ? _darkFocusInverse : _lightFocusInverse;

  Color get skeletonBackground =>
      _isDark ? _darkSkeletonBackground : _lightSkeletonBackground;

  Color get skeletonElement =>
      _isDark ? _darkSkeletonElement : _lightSkeletonElement;

  Color get interactive => _isDark ? _darkInteractive : _lightInteractive;

  Color get highlight => _isDark ? _darkHighlight : _lightHighlight;

  Color get overlay => _isDark ? _darkOverlay : _lightOverlay;

  Color get toggleOff => _isDark ? _darkToggleOff : _lightToggleOff;

  Color get shadow => _isDark ? _darkShadow : _lightShadow;

  Color get aiInnerShadow => _isDark ? _darkAiInnerShadow : _lightAiInnerShadow;

  Color get aiAuraStartSm => _isDark ? _darkAiAuraStartSm : _lightAiAuraStartSm;

  Color get aiAuraStart => _isDark ? _darkAiAuraStart : _lightAiAuraStart;

  Color get aiAuraEnd => _isDark ? _darkAiAuraEnd : _lightAiAuraEnd;

  Color get aiBorderStrong =>
      _isDark ? _darkAiBorderStrong : _lightAiBorderStrong;

  Color get aiBorderStart => _isDark ? _darkAiBorderStart : _lightAiBorderStart;

  Color get aiBorderEnd => _isDark ? _darkAiBorderEnd : _lightAiBorderEnd;

  Color get aiDropShadow => _isDark ? _darkAiDropShadow : _lightAiDropShadow;

  Color get aiAuraHoverBackground =>
      _isDark ? _darkAiAuraHoverBackground : _lightAiAuraHoverBackground;

  Color get aiAuraHoverStart =>
      _isDark ? _darkAiAuraHoverStart : _lightAiAuraHoverStart;

  Color get aiAuraHoverEnd =>
      _isDark ? _darkAiAuraHoverEnd : _lightAiAuraHoverEnd;

  Color get aiPopoverBackground =>
      _isDark ? _darkAiPopoverBackground : _lightAiPopoverBackground;

  Color get aiPopoverShadowOuter01 =>
      _isDark ? _darkAiPopoverShadowOuter01 : _lightAiPopoverShadowOuter01;

  Color get aiPopoverShadowOuter02 =>
      _isDark ? _darkAiPopoverShadowOuter02 : _lightAiPopoverShadowOuter02;

  Color get aiSkeletonBackground =>
      _isDark ? _darkAiSkeletonBackground : _lightAiSkeletonBackground;

  Color get aiSkeletonElementBackground => _isDark
      ? _darkAiSkeletonElementBackground
      : _lightAiSkeletonElementBackground;

  Color get aiOverlay => _isDark ? _darkAiOverlay : _lightAiOverlay;

  Color get aiPopoverCaretCenter =>
      _isDark ? _darkAiPopoverCaretCenter : _lightAiPopoverCaretCenter;

  Color get aiPopoverCaretBottom =>
      _isDark ? _darkAiPopoverCaretBottom : _lightAiPopoverCaretBottom;

  Color get aiPopoverCaretBottomBackgroundActions => _isDark
      ? _darkAiPopoverCaretBottomBackgroundActions
      : _lightAiPopoverCaretBottomBackgroundActions;

  Color get aiPopoverCaretBottomBackground => _isDark
      ? _darkAiPopoverCaretBottomBackground
      : _lightAiPopoverCaretBottomBackground;

  Color get chatPromptBackground =>
      _isDark ? _darkChatPromptBackground : _lightChatPromptBackground;

  Color get chatPromptBorderStart =>
      _isDark ? _darkChatPromptBorderStart : _lightChatPromptBorderStart;

  Color get chatPromptBorderEnd =>
      _isDark ? _darkChatPromptBorderEnd : _lightChatPromptBorderEnd;

  Color get chatBubbleUser =>
      _isDark ? _darkChatBubbleUser : _lightChatBubbleUser;

  Color get chatBubbleAgent =>
      _isDark ? _darkChatBubbleAgent : _lightChatBubbleAgent;

  Color get chatBubbleBorder =>
      _isDark ? _darkChatBubbleBorder : _lightChatBubbleBorder;

  Color get chatAvatarBot => _isDark ? _darkChatAvatarBot : _lightChatAvatarBot;

  Color get chatAvatarAgent =>
      _isDark ? _darkChatAvatarAgent : _lightChatAvatarAgent;

  Color get chatAvatarUser =>
      _isDark ? _darkChatAvatarUser : _lightChatAvatarUser;

  Color get chatShellBackground =>
      _isDark ? _darkChatShellBackground : _lightChatShellBackground;

  Color get chatHeaderBackground =>
      _isDark ? _darkChatHeaderBackground : _lightChatHeaderBackground;

  Color get chatButton => _isDark ? _darkChatButton : _lightChatButton;

  Color get chatButtonHover =>
      _isDark ? _darkChatButtonHover : _lightChatButtonHover;

  Color get chatButtonTextHover =>
      _isDark ? _darkChatButtonTextHover : _lightChatButtonTextHover;

  Color get chatButtonActive =>
      _isDark ? _darkChatButtonActive : _lightChatButtonActive;

  Color get chatButtonSelected =>
      _isDark ? _darkChatButtonSelected : _lightChatButtonSelected;

  Color get chatButtonTextSelected =>
      _isDark ? _darkChatButtonTextSelected : _lightChatButtonTextSelected;

  Color get buttonSeparator =>
      _isDark ? _darkButtonSeparator : _lightButtonSeparator;

  Color get buttonPrimary => _isDark ? _darkButtonPrimary : _lightButtonPrimary;

  Color get buttonSecondary =>
      _isDark ? _darkButtonSecondary : _lightButtonSecondary;

  Color get buttonTertiary =>
      _isDark ? _darkButtonTertiary : _lightButtonTertiary;

  Color get buttonDangerPrimary =>
      _isDark ? _darkButtonDangerPrimary : _lightButtonDangerPrimary;

  Color get buttonDangerSecondary =>
      _isDark ? _darkButtonDangerSecondary : _lightButtonDangerSecondary;

  Color get buttonDangerActive =>
      _isDark ? _darkButtonDangerActive : _lightButtonDangerActive;

  Color get buttonPrimaryActive =>
      _isDark ? _darkButtonPrimaryActive : _lightButtonPrimaryActive;

  Color get buttonSecondaryActive =>
      _isDark ? _darkButtonSecondaryActive : _lightButtonSecondaryActive;

  Color get buttonTertiaryActive =>
      _isDark ? _darkButtonTertiaryActive : _lightButtonTertiaryActive;

  Color get buttonDangerHover =>
      _isDark ? _darkButtonDangerHover : _lightButtonDangerHover;

  Color get buttonPrimaryHover =>
      _isDark ? _darkButtonPrimaryHover : _lightButtonPrimaryHover;

  Color get buttonSecondaryHover =>
      _isDark ? _darkButtonSecondaryHover : _lightButtonSecondaryHover;

  Color get buttonTertiaryHover =>
      _isDark ? _darkButtonTertiaryHover : _lightButtonTertiaryHover;

  Color get buttonDisabled =>
      _isDark ? _darkButtonDisabled : _lightButtonDisabled;

  Color get contentSwitcherSelected =>
      _isDark ? _darkContentSwitcherSelected : _lightContentSwitcherSelected;

  Color get contentSwitcherBackground => _isDark
      ? _darkContentSwitcherBackground
      : _lightContentSwitcherBackground;

  Color get contentSwitcherBackgroundHover => _isDark
      ? _darkContentSwitcherBackgroundHover
      : _lightContentSwitcherBackgroundHover;

  Color get notificationBackgroundError => _isDark
      ? _darkNotificationBackgroundError
      : _lightNotificationBackgroundError;

  Color get notificationBackgroundSuccess => _isDark
      ? _darkNotificationBackgroundSuccess
      : _lightNotificationBackgroundSuccess;

  Color get notificationBackgroundInfo => _isDark
      ? _darkNotificationBackgroundInfo
      : _lightNotificationBackgroundInfo;

  Color get notificationBackgroundWarning => _isDark
      ? _darkNotificationBackgroundWarning
      : _lightNotificationBackgroundWarning;

  Color get notificationActionHover => _lightNotificationActionHover;

  Color get statusRed => _isDark ? _darkStatusRed : _lightStatusRed;

  Color get statusOrange => _isDark ? _darkStatusOrange : _lightStatusOrange;

  Color get statusOrangeOutline => _lightStatusOrangeOutline;

  Color get statusYellow => _isDark ? _darkStatusYellow : _lightStatusYellow;

  Color get statusYellowOutline => _lightStatusYellowOutline;

  Color get statusPurple => _isDark ? _darkStatusPurple : _lightStatusPurple;

  Color get statusGreen => _isDark ? _darkStatusGreen : _lightStatusGreen;

  Color get statusBlue => _isDark ? _darkStatusBlue : _lightStatusBlue;

  Color get statusGray => _isDark ? _darkStatusGray : _lightStatusGray;

  Color get statusAccessibilityBackground => _isDark
      ? _darkStatusAccessibilityBackground
      : _lightStatusAccessibilityBackground;

  Color get tagBackgroundRed =>
      _isDark ? _darkTagBackgroundRed : _lightTagBackgroundRed;

  Color get tagColorRed => _isDark ? _darkTagColorRed : _lightTagColorRed;

  Color get tagHoverRed => _isDark ? _darkTagHoverRed : _lightTagHoverRed;

  Color get tagBorderRed => _isDark ? _darkTagBorderRed : _lightTagBorderRed;

  Color get tagBackgroundMagenta =>
      _isDark ? _darkTagBackgroundMagenta : _lightTagBackgroundMagenta;

  Color get tagColorMagenta =>
      _isDark ? _darkTagColorMagenta : _lightTagColorMagenta;

  Color get tagHoverMagenta =>
      _isDark ? _darkTagHoverMagenta : _lightTagHoverMagenta;

  Color get tagBorderMagenta =>
      _isDark ? _darkTagBorderMagenta : _lightTagBorderMagenta;

  Color get tagBackgroundPurple =>
      _isDark ? _darkTagBackgroundPurple : _lightTagBackgroundPurple;

  Color get tagColorPurple =>
      _isDark ? _darkTagColorPurple : _lightTagColorPurple;

  Color get tagHoverPurple =>
      _isDark ? _darkTagHoverPurple : _lightTagHoverPurple;

  Color get tagBorderPurple =>
      _isDark ? _darkTagBorderPurple : _lightTagBorderPurple;

  Color get tagBackgroundBlue =>
      _isDark ? _darkTagBackgroundBlue : _lightTagBackgroundBlue;

  Color get tagColorBlue => _isDark ? _darkTagColorBlue : _lightTagColorBlue;

  Color get tagHoverBlue => _isDark ? _darkTagHoverBlue : _lightTagHoverBlue;

  Color get tagBorderBlue => _isDark ? _darkTagBorderBlue : _lightTagBorderBlue;

  Color get tagBackgroundCyan =>
      _isDark ? _darkTagBackgroundCyan : _lightTagBackgroundCyan;

  Color get tagColorCyan => _isDark ? _darkTagColorCyan : _lightTagColorCyan;

  Color get tagHoverCyan => _isDark ? _darkTagHoverCyan : _lightTagHoverCyan;

  Color get tagBorderCyan => _isDark ? _darkTagBorderCyan : _lightTagBorderCyan;

  Color get tagBackgroundTeal =>
      _isDark ? _darkTagBackgroundTeal : _lightTagBackgroundTeal;

  Color get tagColorTeal => _isDark ? _darkTagColorTeal : _lightTagColorTeal;

  Color get tagHoverTeal => _isDark ? _darkTagHoverTeal : _lightTagHoverTeal;

  Color get tagBorderTeal => _isDark ? _darkTagBorderTeal : _lightTagBorderTeal;

  Color get tagBackgroundGreen =>
      _isDark ? _darkTagBackgroundGreen : _lightTagBackgroundGreen;

  Color get tagColorGreen => _isDark ? _darkTagColorGreen : _lightTagColorGreen;

  Color get tagHoverGreen => _isDark ? _darkTagHoverGreen : _lightTagHoverGreen;

  Color get tagBorderGreen =>
      _isDark ? _darkTagBorderGreen : _lightTagBorderGreen;

  Color get tagBackgroundGray =>
      _isDark ? _darkTagBackgroundGray : _lightTagBackgroundGray;

  Color get tagColorGray => _isDark ? _darkTagColorGray : _lightTagColorGray;

  Color get tagHoverGray => _isDark ? _darkTagHoverGray : _lightTagHoverGray;

  Color get tagBorderGray => _isDark ? _darkTagBorderGray : _lightTagBorderGray;

  Color get tagBackgroundCoolGray =>
      _isDark ? _darkTagBackgroundCoolGray : _lightTagBackgroundCoolGray;

  Color get tagColorCoolGray =>
      _isDark ? _darkTagColorCoolGray : _lightTagColorCoolGray;

  Color get tagHoverCoolGray =>
      _isDark ? _darkTagHoverCoolGray : _lightTagHoverCoolGray;

  Color get tagBorderCoolGray =>
      _isDark ? _darkTagBorderCoolGray : _lightTagBorderCoolGray;

  Color get tagBackgroundWarmGray =>
      _isDark ? _darkTagBackgroundWarmGray : _lightTagBackgroundWarmGray;

  Color get tagColorWarmGray =>
      _isDark ? _darkTagColorWarmGray : _lightTagColorWarmGray;

  Color get tagHoverWarmGray =>
      _isDark ? _darkTagHoverWarmGray : _lightTagHoverWarmGray;

  Color get tagBorderWarmGray =>
      _isDark ? _darkTagBorderWarmGray : _lightTagBorderWarmGray;
}
