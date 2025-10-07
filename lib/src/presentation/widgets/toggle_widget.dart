import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/utils/extensions.dart';

class ToggleWidget extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? leadingIcon;

  const ToggleWidget({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.leadingIcon,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            SvgPicture.asset(
              leadingIcon!,
              width: 20,
              height: 20,
              colorFilter: context.colors.iconPrimary.colorFilter,
            ),
            const SizedBox(width: 16),
          ],
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodyCompact02(
                        label,
                        color: context.colors.textPrimary,
                      ),
                      if (description != null)
                        AppText.label02(
                          description!,
                          color: context.colors.textSecondary,
                        ),
                    ],
                  ),
                ),
                CustomSwitch(
                  value: value,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  activeTrackColor: context.colors.supportSuccess,
                  activeThumbColor: context.colors.iconOnColor,
                  inactiveThumbColor: context.colors.iconOnColorDisabled,
                  inactiveTrackColor: context.colors.buttonDisabled,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    @Deprecated(
      'Use activeThumbColor instead. '
      'This feature was deprecated after v3.31.0-2.0.pre.',
    )
    this.activeColor,
    this.activeThumbColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.padding,
  }) : applyCupertinoTheme = false,
       assert(activeThumbImage != null || onActiveThumbImageError == null),
       assert(inactiveThumbImage != null || onInactiveThumbImageError == null);

  final bool value;
  final ValueChanged<bool>? onChanged;
  @Deprecated(
    'Use activeThumbColor or activeTrackColor instead. '
    'This feature was deprecated after v3.31.0-2.0.pre.',
  )
  final Color? activeColor;
  final Color? activeThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageProvider? inactiveThumbImage;
  final ImageErrorListener? onInactiveThumbImageError;

  final WidgetStateProperty<Color?>? thumbColor;

  final WidgetStateProperty<Color?>? trackColor;

  final WidgetStateProperty<Color?>? trackOutlineColor;

  final WidgetStateProperty<double?>? trackOutlineWidth;

  final WidgetStateProperty<Icon?>? thumbIcon;

  final MaterialTapTargetSize? materialTapTargetSize;

  final bool? applyCupertinoTheme;

  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final Color? focusColor;

  final Color? hoverColor;

  final WidgetStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  final bool autofocus;

  final EdgeInsetsGeometry? padding;

  Size _getSwitchSize(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SwitchThemeData switchTheme = SwitchTheme.of(context);
    final SwitchThemeData defaults = _SwitchDefaultsM3(context);
    final _SwitchConfig switchConfig = _SwitchConfigM3(context);

    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        materialTapTargetSize ??
        switchTheme.materialTapTargetSize ??
        theme.materialTapTargetSize;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? switchTheme.padding ?? defaults.padding!;
    return switch (effectiveMaterialTapTargetSize) {
      MaterialTapTargetSize.padded => Size(
        switchConfig.switchWidth + effectivePadding.horizontal,
        switchConfig.switchHeight + effectivePadding.vertical,
      ),
      MaterialTapTargetSize.shrinkWrap => Size(
        switchConfig.switchWidth + effectivePadding.horizontal,
        switchConfig.switchHeightCollapsed + effectivePadding.vertical,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    Color? effectiveActiveThumbColor;
    Color? effectiveActiveTrackColor;
    effectiveActiveThumbColor = activeThumbColor;
    return _MaterialSwitch(
      value: value,
      onChanged: onChanged,
      size: _getSwitchSize(context),
      activeThumbColor: activeThumbColor ?? effectiveActiveThumbColor,
      activeTrackColor: activeTrackColor ?? effectiveActiveTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      activeThumbImage: activeThumbImage,
      onActiveThumbImageError: onActiveThumbImageError,
      inactiveThumbImage: inactiveThumbImage,
      onInactiveThumbImageError: onInactiveThumbImageError,
      thumbColor: thumbColor,
      trackColor: trackColor,
      trackOutlineColor: trackOutlineColor,
      trackOutlineWidth: trackOutlineWidth,
      thumbIcon: thumbIcon,
      materialTapTargetSize: materialTapTargetSize,
      dragStartBehavior: dragStartBehavior,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      applyCupertinoTheme: applyCupertinoTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'value',
        value: value,
        ifTrue: 'on',
        ifFalse: 'off',
        showName: true,
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
  }
}

class _MaterialSwitch extends StatefulWidget {
  const _MaterialSwitch({
    required this.value,
    required this.onChanged,
    required this.size,
    this.activeThumbColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.applyCupertinoTheme,
  }) : assert(activeThumbImage != null || onActiveThumbImageError == null),
       assert(inactiveThumbImage != null || onInactiveThumbImageError == null);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageProvider? inactiveThumbImage;
  final ImageErrorListener? onInactiveThumbImageError;
  final WidgetStateProperty<Color?>? thumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;
  final WidgetStateProperty<double?>? trackOutlineWidth;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final Size size;
  final bool? applyCupertinoTheme;

  @override
  State<StatefulWidget> createState() => _MaterialSwitchState();
}

class _MaterialSwitchState extends State<_MaterialSwitch>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();

  @override
  void didUpdateWidget(_MaterialSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (position.value == 0.0 || position.value == 1.0) {
        updateCurve();
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  void updateCurve() {
    if (Theme.of(context).useMaterial3) {
      position
        ..curve = Curves.easeOutBack
        ..reverseCurve = Curves.easeOutBack.flipped;
    } else {
      position
        ..curve = Curves.easeIn
        ..reverseCurve = Curves.easeOut;
    }
  }

  WidgetStateProperty<Color?> get _widgetThumbColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return widget.inactiveThumbColor;
      }
      if (states.contains(WidgetState.selected)) {
        return widget.activeThumbColor;
      }
      return widget.inactiveThumbColor;
    });
  }

  WidgetStateProperty<Color?> get _widgetTrackColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return widget.activeTrackColor;
      }
      return widget.inactiveTrackColor;
    });
  }

  double get _trackInnerLength {
    final _SwitchConfig config = _SwitchConfigM3(context);
    const double thumbRadius = 9.0;
    const double margin = 3.0;
    const double trackInnerStart = thumbRadius + margin;
    final double trackInnerEnd = config.trackWidth - trackInnerStart;
    final double trackInnerLength = trackInnerEnd - trackInnerStart;
    return trackInnerLength;
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      positionController.value += switch (Directionality.of(context)) {
        TextDirection.rtl => -delta,
        TextDirection.ltr => delta,
      };
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged?.call(!widget.value);

      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged?.call(value!);
  }

  bool isCupertino = false;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final ThemeData theme = Theme.of(context);
    final SwitchThemeData switchTheme = SwitchTheme.of(context);
    _SwitchConfig switchConfig;
    SwitchThemeData defaults;
    const double disabledOpacity = 1;
    switchConfig = _SwitchConfigM3(context);
    defaults = _SwitchDefaultsM3(context);
    positionController.duration = Duration(
      milliseconds: switchConfig.toggleDuration,
    );

    final Set<WidgetState> activeStates = states..add(WidgetState.selected);
    final Set<WidgetState> inactiveStates = states
      ..remove(WidgetState.selected);

    final Color? activeThumbColor =
        widget.thumbColor?.resolve(activeStates) ??
        _widgetThumbColor.resolve(activeStates) ??
        switchTheme.thumbColor?.resolve(activeStates);
    final Color effectiveActiveThumbColor =
        activeThumbColor ?? defaults.thumbColor!.resolve(activeStates)!;
    final Color? inactiveThumbColor =
        widget.thumbColor?.resolve(inactiveStates) ??
        _widgetThumbColor.resolve(inactiveStates) ??
        switchTheme.thumbColor?.resolve(inactiveStates);
    final Color effectiveInactiveThumbColor =
        inactiveThumbColor ?? defaults.thumbColor!.resolve(inactiveStates)!;
    final Color effectiveActiveTrackColor =
        widget.trackColor?.resolve(activeStates) ??
        _widgetTrackColor.resolve(activeStates) ??
        (switchTheme.trackColor?.resolve(activeStates)) ??
        _widgetThumbColor
            .resolve(activeStates)
            ?.withValues(alpha: 0x80 / 255.0) ??
        defaults.trackColor!.resolve(activeStates)!;
    final Color? effectiveActiveTrackOutlineColor =
        widget.trackOutlineColor?.resolve(activeStates) ??
        switchTheme.trackOutlineColor?.resolve(activeStates) ??
        defaults.trackOutlineColor!.resolve(activeStates);
    final double? effectiveActiveTrackOutlineWidth =
        widget.trackOutlineWidth?.resolve(activeStates) ??
        switchTheme.trackOutlineWidth?.resolve(activeStates) ??
        defaults.trackOutlineWidth?.resolve(activeStates);

    final Color effectiveInactiveTrackColor =
        widget.trackColor?.resolve(inactiveStates) ??
        _widgetTrackColor.resolve(inactiveStates) ??
        switchTheme.trackColor?.resolve(inactiveStates) ??
        defaults.trackColor!.resolve(inactiveStates)!;
    final Color? effectiveInactiveTrackOutlineColor =
        widget.trackOutlineColor?.resolve(inactiveStates) ??
        switchTheme.trackOutlineColor?.resolve(inactiveStates) ??
        defaults.trackOutlineColor?.resolve(inactiveStates);
    final double? effectiveInactiveTrackOutlineWidth =
        widget.trackOutlineWidth?.resolve(inactiveStates) ??
        switchTheme.trackOutlineWidth?.resolve(inactiveStates) ??
        defaults.trackOutlineWidth?.resolve(inactiveStates);

    final Icon? effectiveActiveIcon =
        widget.thumbIcon?.resolve(activeStates) ??
        switchTheme.thumbIcon?.resolve(activeStates);
    final Icon? effectiveInactiveIcon =
        widget.thumbIcon?.resolve(inactiveStates) ??
        switchTheme.thumbIcon?.resolve(inactiveStates);

    final Color effectiveActiveIconColor =
        effectiveActiveIcon?.color ??
        switchConfig.iconColor.resolve(activeStates);
    final Color effectiveInactiveIconColor =
        effectiveInactiveIcon?.color ??
        switchConfig.iconColor.resolve(inactiveStates);

    final Set<WidgetState> focusedStates = states..add(WidgetState.focused);
    final Color effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
        widget.focusColor ??
        switchTheme.overlayColor?.resolve(focusedStates) ??
        defaults.overlayColor!.resolve(focusedStates)!;

    final Set<WidgetState> hoveredStates = states..add(WidgetState.hovered);
    final Color effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
        widget.hoverColor ??
        switchTheme.overlayColor?.resolve(hoveredStates) ??
        defaults.overlayColor!.resolve(hoveredStates)!;

    final Set<WidgetState> activePressedStates = activeStates
      ..add(WidgetState.pressed);
    final Color effectiveActivePressedThumbColor =
        widget.thumbColor?.resolve(activePressedStates) ??
        _widgetThumbColor.resolve(activePressedStates) ??
        switchTheme.thumbColor?.resolve(activePressedStates) ??
        defaults.thumbColor!.resolve(activePressedStates)!;
    final Color effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ??
        switchTheme.overlayColor?.resolve(activePressedStates) ??
        activeThumbColor?.withValues(alpha: kRadialReactionAlpha / 255.0) ??
        defaults.overlayColor!.resolve(activePressedStates)!;

    final Set<WidgetState> inactivePressedStates = inactiveStates
      ..add(WidgetState.pressed);
    final Color effectiveInactivePressedThumbColor =
        widget.thumbColor?.resolve(inactivePressedStates) ??
        _widgetThumbColor.resolve(inactivePressedStates) ??
        switchTheme.thumbColor?.resolve(inactivePressedStates) ??
        defaults.thumbColor!.resolve(inactivePressedStates)!;
    final Color effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ??
        switchTheme.overlayColor?.resolve(inactivePressedStates) ??
        inactiveThumbColor?.withValues(alpha: kRadialReactionAlpha / 255.0) ??
        defaults.overlayColor!.resolve(inactivePressedStates)!;

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
          return WidgetStateProperty.resolveAs<MouseCursor?>(
                widget.mouseCursor,
                states,
              ) ??
              switchTheme.mouseCursor?.resolve(states) ??
              defaults.mouseCursor!.resolve(states)!;
        });

    final double effectiveActiveThumbRadius = effectiveActiveIcon == null
        ? switchConfig.activeThumbRadius
        : switchConfig.thumbRadiusWithIcon;
    final double effectiveInactiveThumbRadius =
        effectiveInactiveIcon == null && widget.inactiveThumbImage == null
        ? switchConfig.inactiveThumbRadius
        : switchConfig.thumbRadiusWithIcon;
    final double effectiveSplashRadius =
        widget.splashRadius ??
        switchTheme.splashRadius ??
        defaults.splashRadius!;

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: Opacity(
          opacity: onChanged == null ? disabledOpacity : 1,
          child: buildToggleable(
            mouseCursor: effectiveMouseCursor,
            focusNode: widget.focusNode,
            onFocusChange: widget.onFocusChange,
            autofocus: widget.autofocus,
            size: widget.size,
            painter: _painter
              ..position = position
              ..reaction = reaction
              ..reactionFocusFade = reactionFocusFade
              ..reactionHoverFade = reactionHoverFade
              ..inactiveReactionColor = effectiveInactivePressedOverlayColor
              ..reactionColor = effectiveActivePressedOverlayColor
              ..hoverColor = effectiveHoverOverlayColor
              ..focusColor = effectiveFocusOverlayColor
              ..splashRadius = effectiveSplashRadius
              ..downPosition = downPosition
              ..isFocused = states.contains(WidgetState.focused)
              ..isHovered = states.contains(WidgetState.hovered)
              ..activeColor = effectiveActiveThumbColor
              ..inactiveColor = effectiveInactiveThumbColor
              ..activePressedColor = effectiveActivePressedThumbColor
              ..inactivePressedColor = effectiveInactivePressedThumbColor
              ..activeThumbImage = widget.activeThumbImage
              ..onActiveThumbImageError = widget.onActiveThumbImageError
              ..inactiveThumbImage = widget.inactiveThumbImage
              ..onInactiveThumbImageError = widget.onInactiveThumbImageError
              ..activeTrackColor = effectiveActiveTrackColor
              ..activeTrackOutlineColor = effectiveActiveTrackOutlineColor
              ..activeTrackOutlineWidth = effectiveActiveTrackOutlineWidth
              ..inactiveTrackColor = effectiveInactiveTrackColor
              ..inactiveTrackOutlineColor = effectiveInactiveTrackOutlineColor
              ..inactiveTrackOutlineWidth = effectiveInactiveTrackOutlineWidth
              ..configuration = createLocalImageConfiguration(context)
              ..isInteractive = isInteractive
              ..trackInnerLength = _trackInnerLength
              ..textDirection = Directionality.of(context)
              ..surfaceColor = theme.colorScheme.surface
              ..inactiveThumbRadius = effectiveInactiveThumbRadius
              ..activeThumbRadius = effectiveActiveThumbRadius
              ..pressedThumbRadius = switchConfig.pressedThumbRadius
              ..thumbOffset = switchConfig.thumbOffset
              ..trackHeight = switchConfig.trackHeight
              ..trackWidth = switchConfig.trackWidth
              ..activeIconColor = effectiveActiveIconColor
              ..inactiveIconColor = effectiveInactiveIconColor
              ..activeIcon = effectiveActiveIcon
              ..inactiveIcon = effectiveInactiveIcon
              ..iconTheme = IconTheme.of(context)
              ..thumbShadow = switchConfig.thumbShadow
              ..transitionalThumbSize = switchConfig.transitionalThumbSize
              ..positionController = positionController
              ..isCupertino = isCupertino,
          ),
        ),
      ),
    );
  }
}

class _SwitchPainter extends ToggleablePainter {
  AnimationController get positionController => _positionController!;
  AnimationController? _positionController;

  set positionController(AnimationController? value) {
    assert(value != null);
    if (value == _positionController) {
      return;
    }
    _positionController = value;
    _colorAnimation?.dispose();
    _colorAnimation = CurvedAnimation(
      parent: positionController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    notifyListeners();
  }

  CurvedAnimation? _colorAnimation;

  Icon? get activeIcon => _activeIcon;
  Icon? _activeIcon;

  set activeIcon(Icon? value) {
    if (value == _activeIcon) {
      return;
    }
    _activeIcon = value;
    notifyListeners();
  }

  Icon? get inactiveIcon => _inactiveIcon;
  Icon? _inactiveIcon;

  set inactiveIcon(Icon? value) {
    if (value == _inactiveIcon) {
      return;
    }
    _inactiveIcon = value;
    notifyListeners();
  }

  IconThemeData? get iconTheme => _iconTheme;
  IconThemeData? _iconTheme;

  set iconTheme(IconThemeData? value) {
    if (value == _iconTheme) {
      return;
    }
    _iconTheme = value;
    notifyListeners();
  }

  Color get activeIconColor => _activeIconColor!;
  Color? _activeIconColor;

  set activeIconColor(Color value) {
    if (value == _activeIconColor) {
      return;
    }
    _activeIconColor = value;
    notifyListeners();
  }

  Color get inactiveIconColor => _inactiveIconColor!;
  Color? _inactiveIconColor;

  set inactiveIconColor(Color value) {
    if (value == _inactiveIconColor) {
      return;
    }
    _inactiveIconColor = value;
    notifyListeners();
  }

  Color get activePressedColor => _activePressedColor!;
  Color? _activePressedColor;

  set activePressedColor(Color? value) {
    assert(value != null);
    if (value == _activePressedColor) {
      return;
    }
    _activePressedColor = value;
    notifyListeners();
  }

  Color get inactivePressedColor => _inactivePressedColor!;
  Color? _inactivePressedColor;

  set inactivePressedColor(Color? value) {
    assert(value != null);
    if (value == _inactivePressedColor) {
      return;
    }
    _inactivePressedColor = value;
    notifyListeners();
  }

  double get activeThumbRadius => _activeThumbRadius!;
  double? _activeThumbRadius;

  set activeThumbRadius(double value) {
    if (value == _activeThumbRadius) {
      return;
    }
    _activeThumbRadius = value;
    notifyListeners();
  }

  double get inactiveThumbRadius => _inactiveThumbRadius!;
  double? _inactiveThumbRadius;

  set inactiveThumbRadius(double value) {
    if (value == _inactiveThumbRadius) {
      return;
    }
    _inactiveThumbRadius = value;
    notifyListeners();
  }

  double get pressedThumbRadius => _pressedThumbRadius!;
  double? _pressedThumbRadius;

  set pressedThumbRadius(double value) {
    if (value == _pressedThumbRadius) {
      return;
    }
    _pressedThumbRadius = value;
    notifyListeners();
  }

  double? get thumbOffset => _thumbOffset;
  double? _thumbOffset;

  set thumbOffset(double? value) {
    if (value == _thumbOffset) {
      return;
    }
    _thumbOffset = value;
    notifyListeners();
  }

  Size get transitionalThumbSize => _transitionalThumbSize!;
  Size? _transitionalThumbSize;

  set transitionalThumbSize(Size value) {
    if (value == _transitionalThumbSize) {
      return;
    }
    _transitionalThumbSize = value;
    notifyListeners();
  }

  double get trackHeight => _trackHeight!;
  double? _trackHeight;

  set trackHeight(double value) {
    if (value == _trackHeight) {
      return;
    }
    _trackHeight = value;
    notifyListeners();
  }

  double get trackWidth => _trackWidth!;
  double? _trackWidth;

  set trackWidth(double value) {
    if (value == _trackWidth) {
      return;
    }
    _trackWidth = value;
    notifyListeners();
  }

  ImageProvider? get activeThumbImage => _activeThumbImage;
  ImageProvider? _activeThumbImage;

  set activeThumbImage(ImageProvider? value) {
    if (value == _activeThumbImage) {
      return;
    }
    _activeThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onActiveThumbImageError => _onActiveThumbImageError;
  ImageErrorListener? _onActiveThumbImageError;

  set onActiveThumbImageError(ImageErrorListener? value) {
    if (value == _onActiveThumbImageError) {
      return;
    }
    _onActiveThumbImageError = value;
    notifyListeners();
  }

  ImageProvider? get inactiveThumbImage => _inactiveThumbImage;
  ImageProvider? _inactiveThumbImage;

  set inactiveThumbImage(ImageProvider? value) {
    if (value == _inactiveThumbImage) {
      return;
    }
    _inactiveThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onInactiveThumbImageError =>
      _onInactiveThumbImageError;
  ImageErrorListener? _onInactiveThumbImageError;

  set onInactiveThumbImageError(ImageErrorListener? value) {
    if (value == _onInactiveThumbImageError) {
      return;
    }
    _onInactiveThumbImageError = value;
    notifyListeners();
  }

  Color get activeTrackColor => _activeTrackColor!;
  Color? _activeTrackColor;

  set activeTrackColor(Color value) {
    if (value == _activeTrackColor) {
      return;
    }
    _activeTrackColor = value;
    notifyListeners();
  }

  Color? get activeTrackOutlineColor => _activeTrackOutlineColor;
  Color? _activeTrackOutlineColor;

  set activeTrackOutlineColor(Color? value) {
    if (value == _activeTrackOutlineColor) {
      return;
    }
    _activeTrackOutlineColor = value;
    notifyListeners();
  }

  Color? get inactiveTrackOutlineColor => _inactiveTrackOutlineColor;
  Color? _inactiveTrackOutlineColor;

  set inactiveTrackOutlineColor(Color? value) {
    if (value == _inactiveTrackOutlineColor) {
      return;
    }
    _inactiveTrackOutlineColor = value;
    notifyListeners();
  }

  double? get activeTrackOutlineWidth => _activeTrackOutlineWidth;
  double? _activeTrackOutlineWidth;

  set activeTrackOutlineWidth(double? value) {
    if (value == _activeTrackOutlineWidth) {
      return;
    }
    _activeTrackOutlineWidth = value;
    notifyListeners();
  }

  double? get inactiveTrackOutlineWidth => _inactiveTrackOutlineWidth;
  double? _inactiveTrackOutlineWidth;

  set inactiveTrackOutlineWidth(double? value) {
    if (value == _inactiveTrackOutlineWidth) {
      return;
    }
    _inactiveTrackOutlineWidth = value;
    notifyListeners();
  }

  Color get inactiveTrackColor => _inactiveTrackColor!;
  Color? _inactiveTrackColor;

  set inactiveTrackColor(Color value) {
    if (value == _inactiveTrackColor) {
      return;
    }
    _inactiveTrackColor = value;
    notifyListeners();
  }

  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;

  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    notifyListeners();
  }

  Color get surfaceColor => _surfaceColor!;
  Color? _surfaceColor;

  set surfaceColor(Color value) {
    if (value == _surfaceColor) {
      return;
    }
    _surfaceColor = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;

  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;

  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  bool get isCupertino => _isCupertino!;
  bool? _isCupertino;

  set isCupertino(bool? value) {
    assert(value != null);
    if (value == _isCupertino) {
      return;
    }
    _isCupertino = value;
    notifyListeners();
  }

  List<BoxShadow>? get thumbShadow => _thumbShadow;
  List<BoxShadow>? _thumbShadow;

  set thumbShadow(List<BoxShadow>? value) {
    if (value == _thumbShadow) {
      return;
    }
    _thumbShadow = value;
    notifyListeners();
  }

  final TextPainter _textPainter = TextPainter();
  Color? _cachedThumbColor;
  ImageProvider? _cachedThumbImage;
  ImageErrorListener? _cachedThumbErrorListener;
  BoxPainter? _cachedThumbPainter;

  ShapeDecoration _createDefaultThumbDecoration(
    Color color,
    ImageProvider? image,
    ImageErrorListener? errorListener,
  ) {
    return ShapeDecoration(
      color: color,
      image: image == null
          ? null
          : DecorationImage(image: image, onError: errorListener),
      shape: const StadiumBorder(),
      shadows: isCupertino ? null : thumbShadow,
    );
  }

  bool _isPainting = false;

  void _handleDecorationChanged() {
    if (!_isPainting) {
      notifyListeners();
    }
  }

  bool _stopPressAnimation = false;
  double? _pressedInactiveThumbRadius;
  double? _pressedActiveThumbRadius;
  late double? _pressedThumbExtension;

  @override
  void paint(Canvas canvas, Size size) {
    final double currentValue = position.value;

    final double visualPosition = switch (textDirection) {
      TextDirection.rtl => 1.0 - currentValue,
      TextDirection.ltr => currentValue,
    };
    if (reaction.status == AnimationStatus.reverse && !_stopPressAnimation) {
      _stopPressAnimation = true;
    } else {
      _stopPressAnimation = false;
    }

    if (!_stopPressAnimation) {
      _pressedThumbExtension = isCupertino ? reaction.value * 7 : 0;
      if (reaction.isCompleted) {
        _pressedInactiveThumbRadius = lerpDouble(
          inactiveThumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
        _pressedActiveThumbRadius = lerpDouble(
          activeThumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
      }
      if (currentValue == 0) {
        _pressedInactiveThumbRadius = lerpDouble(
          inactiveThumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
        _pressedActiveThumbRadius = activeThumbRadius;
      }
      if (currentValue == 1) {
        _pressedActiveThumbRadius = lerpDouble(
          activeThumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
        _pressedInactiveThumbRadius = inactiveThumbRadius;
      }
    }
    final Size inactiveThumbSize = isCupertino
        ? Size(
            _pressedInactiveThumbRadius! * 2 + _pressedThumbExtension!,
            _pressedInactiveThumbRadius! * 2,
          )
        : Size.fromRadius(_pressedInactiveThumbRadius ?? inactiveThumbRadius);
    final Size activeThumbSize = isCupertino
        ? Size(
            _pressedActiveThumbRadius! * 2 + _pressedThumbExtension!,
            _pressedActiveThumbRadius! * 2,
          )
        : Size.fromRadius(_pressedActiveThumbRadius ?? activeThumbRadius);
    Animation<Size> thumbSizeAnimation(bool isForward) {
      List<TweenSequenceItem<Size>> thumbSizeSequence;
      if (isForward) {
        thumbSizeSequence = <TweenSequenceItem<Size>>[
          TweenSequenceItem<Size>(
            tween: Tween<Size>(
              begin: inactiveThumbSize,
              end: transitionalThumbSize,
            ).chain(CurveTween(curve: const Cubic(0.31, 0.00, 0.56, 1.00))),
            weight: 11,
          ),
          TweenSequenceItem<Size>(
            tween: Tween<Size>(
              begin: transitionalThumbSize,
              end: activeThumbSize,
            ).chain(CurveTween(curve: const Cubic(0.20, 0.00, 0.00, 1.00))),
            weight: 72,
          ),
          TweenSequenceItem<Size>(
            tween: ConstantTween<Size>(activeThumbSize),
            weight: 17,
          ),
        ];
      } else {
        thumbSizeSequence = <TweenSequenceItem<Size>>[
          TweenSequenceItem<Size>(
            tween: ConstantTween<Size>(inactiveThumbSize),
            weight: 17,
          ),
          TweenSequenceItem<Size>(
            tween:
                Tween<Size>(
                  begin: inactiveThumbSize,
                  end: transitionalThumbSize,
                ).chain(
                  CurveTween(
                    curve: const Cubic(0.20, 0.00, 0.00, 1.00).flipped,
                  ),
                ),
            weight: 72,
          ),
          TweenSequenceItem<Size>(
            tween:
                Tween<Size>(
                  begin: transitionalThumbSize,
                  end: activeThumbSize,
                ).chain(
                  CurveTween(
                    curve: const Cubic(0.31, 0.00, 0.56, 1.00).flipped,
                  ),
                ),
            weight: 11,
          ),
        ];
      }

      return TweenSequence<Size>(thumbSizeSequence).animate(positionController);
    }

    Size? thumbSize;
    if (isCupertino) {
      if (reaction.isCompleted) {
        thumbSize = Size(
          _pressedInactiveThumbRadius! * 2 + _pressedThumbExtension!,
          _pressedInactiveThumbRadius! * 2,
        );
      } else {
        if (position.isDismissed ||
            position.status == AnimationStatus.forward) {
          thumbSize = Size.lerp(
            inactiveThumbSize,
            activeThumbSize,
            position.value,
          );
        } else {
          thumbSize = Size.lerp(
            inactiveThumbSize,
            activeThumbSize,
            position.value,
          );
        }
      }
    } else {
      if (reaction.isCompleted) {
        thumbSize = Size.fromRadius(pressedThumbRadius);
      } else {
        if (position.isDismissed ||
            position.status == AnimationStatus.forward) {
          thumbSize = thumbSizeAnimation(true).value;
        } else {
          thumbSize = thumbSizeAnimation(false).value;
        }
      }
    }

    final double inset = thumbOffset == null
        ? 0
        : 1.0 - (currentValue - thumbOffset!).abs() * 2.0;
    thumbSize = Size(thumbSize!.width - inset, thumbSize.height - inset);

    final double colorValue = _colorAnimation!.value;
    final Color trackColor = Color.lerp(
      inactiveTrackColor,
      activeTrackColor,
      colorValue,
    )!;
    final Color? trackOutlineColor =
        inactiveTrackOutlineColor == null || activeTrackOutlineColor == null
        ? null
        : Color.lerp(
            inactiveTrackOutlineColor,
            activeTrackOutlineColor,
            colorValue,
          );
    final double? trackOutlineWidth = lerpDouble(
      inactiveTrackOutlineWidth,
      activeTrackOutlineWidth,
      colorValue,
    );
    Color lerpedThumbColor;
    if (!reaction.isDismissed) {
      lerpedThumbColor = Color.lerp(
        inactivePressedColor,
        activePressedColor,
        colorValue,
      )!;
    } else if (positionController.status == AnimationStatus.forward) {
      lerpedThumbColor = Color.lerp(
        inactivePressedColor,
        activeColor,
        colorValue,
      )!;
    } else if (positionController.status == AnimationStatus.reverse) {
      lerpedThumbColor = Color.lerp(
        inactiveColor,
        activePressedColor,
        colorValue,
      )!;
    } else {
      lerpedThumbColor = Color.lerp(inactiveColor, activeColor, colorValue)!;
    }

    final Color thumbColor = Color.alphaBlend(lerpedThumbColor, surfaceColor);

    final Icon? thumbIcon = currentValue < 0.5 ? inactiveIcon : activeIcon;

    final ImageProvider? thumbImage = currentValue < 0.5
        ? inactiveThumbImage
        : activeThumbImage;

    final ImageErrorListener? thumbErrorListener = currentValue < 0.5
        ? onInactiveThumbImageError
        : onActiveThumbImageError;

    final Paint paint = Paint()..color = trackColor;

    final Offset trackPaintOffset = _computeTrackPaintOffset(
      size,
      trackWidth,
      trackHeight,
    );
    final Offset thumbPaintOffset = _computeThumbPaintOffset(
      trackPaintOffset,
      thumbSize,
      visualPosition,
    );
    final Offset radialReactionOrigin = Offset(
      thumbPaintOffset.dx + thumbSize.height / 2,
      size.height / 2,
    );

    _paintTrackWith(
      canvas,
      paint,
      trackPaintOffset,
      trackOutlineColor,
      trackOutlineWidth,
    );
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumbWith(
      thumbPaintOffset,
      canvas,
      colorValue,
      thumbColor,
      thumbImage,
      thumbErrorListener,
      thumbIcon,
      thumbSize,
      inset,
    );
  }

  Offset _computeTrackPaintOffset(
    Size canvasSize,
    double trackWidth,
    double trackHeight,
  ) {
    final double horizontalOffset = (canvasSize.width - trackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - trackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  Offset _computeThumbPaintOffset(
    Offset trackPaintOffset,
    Size thumbSize,
    double visualPosition,
  ) {
    const double thumbRadius = 9.0;
    const double margin = 3.0;

    final double horizontalProgress =
        visualPosition * (trackInnerLength - _pressedThumbExtension!);
    final double thumbHorizontalOffset =
        trackPaintOffset.dx +
        thumbRadius +
        margin +
        (_pressedThumbExtension! / 2) -
        thumbSize.width / 2 +
        horizontalProgress;
    final double thumbVerticalOffset =
        trackPaintOffset.dy + (trackHeight - thumbSize.height) / 2;
    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrackWith(
    Canvas canvas,
    Paint paint,
    Offset trackPaintOffset,
    Color? trackOutlineColor,
    double? trackOutlineWidth,
  ) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      trackWidth,
      trackHeight,
    );
    final double trackRadius = trackHeight / 2;
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius),
    );

    canvas.drawRRect(trackRRect, paint);

    if (trackOutlineColor != null) {
      final Rect outlineTrackRect = Rect.fromLTWH(
        trackPaintOffset.dx + 1,
        trackPaintOffset.dy + 1,
        trackWidth - 2,
        trackHeight - 2,
      );
      final RRect outlineTrackRRect = RRect.fromRectAndRadius(
        outlineTrackRect,
        Radius.circular(trackRadius),
      );

      final Paint outlinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackOutlineWidth ?? 2.0
        ..color = trackOutlineColor;

      canvas.drawRRect(outlineTrackRRect, outlinePaint);
    }

    if (isCupertino) {
      if (isFocused) {
        final RRect focusedOutline = trackRRect.inflate(1.75);
        final Paint focusedPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = focusColor
          ..strokeWidth = _kCupertinoFocusTrackOutline;
        canvas.drawRRect(focusedOutline, focusedPaint);
      }
      canvas.clipRRect(trackRRect);
    }
  }

  void _paintThumbWith(
    Offset thumbPaintOffset,
    Canvas canvas,
    double currentValue,
    Color thumbColor,
    ImageProvider? thumbImage,
    ImageErrorListener? thumbErrorListener,
    Icon? thumbIcon,
    Size thumbSize,
    double inset,
  ) {
    try {
      _isPainting = true;
      if (_cachedThumbPainter == null ||
          thumbColor != _cachedThumbColor ||
          thumbImage != _cachedThumbImage ||
          thumbErrorListener != _cachedThumbErrorListener) {
        _cachedThumbColor = thumbColor;
        _cachedThumbImage = thumbImage;
        _cachedThumbErrorListener = thumbErrorListener;
        _cachedThumbPainter?.dispose();
        _cachedThumbPainter = _createDefaultThumbDecoration(
          thumbColor,
          thumbImage,
          thumbErrorListener,
        ).createBoxPainter(_handleDecorationChanged);
      }
      final BoxPainter thumbPainter = _cachedThumbPainter!;

      if (isCupertino) {
        _paintCupertinoThumbShadowAndBorder(
          canvas,
          thumbPaintOffset,
          thumbSize,
        );
      }

      thumbPainter.paint(
        canvas,
        thumbPaintOffset,
        configuration.copyWith(size: thumbSize),
      );

      if (thumbIcon != null && thumbIcon.icon != null) {
        final Color iconColor = Color.lerp(
          inactiveIconColor,
          activeIconColor,
          currentValue,
        )!;
        final double iconSize = thumbIcon.size ?? _SwitchConfigM3.iconSize;
        final IconData iconData = thumbIcon.icon!;
        final double? iconWeight = thumbIcon.weight ?? iconTheme?.weight;
        final double? iconFill = thumbIcon.fill ?? iconTheme?.fill;
        final double? iconGrade = thumbIcon.grade ?? iconTheme?.grade;
        final double? iconOpticalSize =
            thumbIcon.opticalSize ?? iconTheme?.opticalSize;
        final List<Shadow>? iconShadows =
            thumbIcon.shadows ?? iconTheme?.shadows;

        final TextSpan textSpan = TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontVariations: <FontVariation>[
              if (iconFill != null) FontVariation('FILL', iconFill),
              if (iconWeight != null) FontVariation('wght', iconWeight),
              if (iconGrade != null) FontVariation('GRAD', iconGrade),
              if (iconOpticalSize != null)
                FontVariation('opsz', iconOpticalSize),
            ],
            color: iconColor,
            fontSize: iconSize,
            inherit: false,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            shadows: iconShadows,
          ),
        );
        _textPainter
          ..textDirection = textDirection
          ..text = textSpan;
        _textPainter.layout();
        final double additionalHorizontalOffset =
            (thumbSize.width - iconSize) / 2;
        final double additionalVerticalOffset =
            (thumbSize.height - iconSize) / 2;
        final Offset offset =
            thumbPaintOffset +
            Offset(additionalHorizontalOffset, additionalVerticalOffset);

        _textPainter.paint(canvas, offset);
      }
    } finally {
      _isPainting = false;
    }
  }

  void _paintCupertinoThumbShadowAndBorder(
    Canvas canvas,
    Offset thumbPaintOffset,
    Size thumbSize,
  ) {
    final RRect thumbBounds = RRect.fromLTRBR(
      thumbPaintOffset.dx,
      thumbPaintOffset.dy,
      thumbPaintOffset.dx + thumbSize.width,
      thumbPaintOffset.dy + thumbSize.height,
      Radius.circular(thumbSize.height / 2.0),
    );
    if (thumbShadow != null) {
      for (final BoxShadow shadow in thumbShadow!) {
        canvas.drawRRect(thumbBounds.shift(shadow.offset), shadow.toPaint());
      }
    }

    canvas.drawRRect(
      thumbBounds.inflate(0.5),
      Paint()..color = const Color(0x0A000000),
    );
  }

  @override
  void dispose() {
    _textPainter.dispose();
    _cachedThumbPainter?.dispose();
    _cachedThumbPainter = null;
    _cachedThumbColor = null;
    _cachedThumbImage = null;
    _cachedThumbErrorListener = null;
    _colorAnimation?.dispose();
    super.dispose();
  }
}

mixin _SwitchConfig {
  double get trackHeight;

  double get trackWidth;

  double get switchWidth;

  double get switchHeight;

  double get switchHeightCollapsed;

  double get activeThumbRadius;

  double get inactiveThumbRadius;

  double get pressedThumbRadius;

  double get thumbRadiusWithIcon;

  List<BoxShadow>? get thumbShadow;

  WidgetStateProperty<Color> get iconColor;

  double? get thumbOffset;

  Size get transitionalThumbSize;

  int get toggleDuration;

  Size get switchMinSize;
}

const double _kCupertinoFocusTrackOutline = 3.5;

class _SwitchDefaultsM3 extends SwitchThemeData {
  _SwitchDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  WidgetStateProperty<Color> get thumbColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.surface.withValues(alpha: 1.0);
        }
        return _colors.onSurface.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primaryContainer;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primaryContainer;
        }
        return _colors.onPrimary;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.outline;
    });
  }

  @override
  WidgetStateProperty<Color> get trackColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.onSurface.withValues(alpha: 0.12);
        }
        return _colors.surfaceContainerHighest.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary;
        }
        return _colors.primary;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.surfaceContainerHighest;
      }
      return _colors.surfaceContainerHighest;
    });
  }

  @override
  WidgetStateProperty<Color?> get trackOutlineColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      if (states.contains(WidgetState.disabled)) {
        return _colors.onSurface.withValues(alpha: 0.12);
      }
      return null;
    });
  }

  @override
  WidgetStateProperty<Color?> get overlayColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha: 0.1);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withValues(alpha: 0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha: 0.1);
      }
      return null;
    });
  }

  @override
  WidgetStateProperty<MouseCursor> get mouseCursor {
    return WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) =>
          WidgetStateMouseCursor.clickable.resolve(states),
    );
  }

  @override
  WidgetStatePropertyAll<double> get trackOutlineWidth =>
      const WidgetStatePropertyAll<double>(2.0);

  @override
  double get splashRadius => 40.0 / 2;

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.symmetric(horizontal: 4);
}

class _SwitchConfigM3 with _SwitchConfig {
  _SwitchConfigM3(this.context) : _colors = Theme.of(context).colorScheme;

  BuildContext context;
  final ColorScheme _colors;

  static const double iconSize = 16.0;

  @override
  double get activeThumbRadius => 9.0;

  @override
  WidgetStateProperty<Color> get iconColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.onSurface.withValues(alpha: 0.38);
        }
        return _colors.surfaceContainerHighest.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onPrimaryContainer;
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onPrimaryContainer;
        }
        return _colors.onPrimaryContainer;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.surfaceContainerHighest;
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.surfaceContainerHighest;
      }
      return _colors.surfaceContainerHighest;
    });
  }

  @override
  double get inactiveThumbRadius => 9.0;

  @override
  double get pressedThumbRadius => 10.0;

  @override
  double get switchHeight => switchMinSize.height + 8.0;

  @override
  double get switchHeightCollapsed => switchMinSize.height;

  @override
  double get switchWidth => 52.0;

  @override
  double get thumbRadiusWithIcon => 9.0;

  @override
  List<BoxShadow>? get thumbShadow => kElevationToShadow[0];

  @override
  double get trackHeight => 24.0;

  @override
  double get trackWidth => 46.0;

  @override
  Size get transitionalThumbSize => const Size(20, 18);

  @override
  int get toggleDuration => 300;

  @override
  double? get thumbOffset => null;

  @override
  Size get switchMinSize =>
      const Size(kMinInteractiveDimension, kMinInteractiveDimension / 2);
}
