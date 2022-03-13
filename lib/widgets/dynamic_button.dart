// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A copy of the CupertinoButton class with modified haptics
class DynamicButton extends StatefulWidget {
  /// Creates an iOS-style button.
  const DynamicButton({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedScale = 0.96,
    this.shouldDarken = true,
    this.splashColor = Colors.black26,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
    required this.onPressed,
  })  : assert(pressedScale == null || (pressedScale >= 0.0 && pressedScale <= 1.0)),
        _filled = false,
        super(key: key);

  const DynamicButton.filled({
    Key? key,
    required this.child,
    this.padding,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedScale = 0.96,
    this.shouldDarken = true,
    this.splashColor = Colors.black26,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
    required this.onPressed,
  })  : assert(pressedScale == null || (pressedScale >= 0.0 && pressedScale <= 1.0)),
        color = null,
        _filled = true,
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry? padding;

  ///The color that should overlay when button is pressed
  final Color splashColor;

  /// The color of the button's background.
  ///
  /// Defaults to null which produces a button with no background or border.
  ///
  /// Defaults to the [CupertinoTheme]'s `primaryColor` when the
  /// [DynamicButton.filled] constructor is used.
  final Color? color;

  /// The color of the button's background when the button is disabled.
  ///
  /// Ignored if the [DynamicButton] doesn't also have a [color].
  ///
  /// Defaults to [CupertinoColors.quaternarySystemFill] when [color] is
  /// specified. Must not be null.
  final Color disabledColor;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Minimum size of the button.
  ///
  /// Defaults to kMinInteractiveDimensionCupertino which the iOS Human
  /// Interface Guidelines recommends as the minimum tappable area.
  final double? minSize;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.4. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double? pressedScale;
  final bool shouldDarken;

  /// The radius of the button's corners when it has a background color.
  ///
  /// Defaults to round corners of 8 logical pixels.
  final BorderRadius? borderRadius;

  /// The alignment of the button's [child].
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  final bool _filled;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  _DynamicButtonState createState() => _DynamicButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _DynamicButtonState extends State<DynamicButton> with TickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 6); //Vorher 10
  static const Duration kFadeInDuration = Duration(milliseconds: 60); //Vorher 100
  final Tween<double> _scalingTween = Tween<double>(begin: 1.0);
  final Tween<double> _darkenTween = Tween<double>(begin: 0, end: 0.4);

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _darkenController;
  late Animation<double> _darkenAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _darkenController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _scaleAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_scalingTween);
    _setTween();

    _darkenAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_darkenTween);
    _setTween();
  }

  @override
  void didUpdateWidget(DynamicButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _scalingTween.end = widget.pressedScale ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _darkenController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);

    final TickerFuture ticker2 =
        _buttonHeldDown ? _darkenController.animateTo(0.0, duration: kFadeOutDuration) : _darkenController.animateTo(1, duration: kFadeInDuration);

    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
    ticker2.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final Color primaryColor = themeData.primaryColor;
    final Color? backgroundColor =
        widget.color == null ? (widget._filled ? primaryColor : null) : CupertinoDynamicColor.maybeResolve(widget.color, context);

    final Color foregroundColor = backgroundColor != null
        ? themeData.primaryContrastingColor
        : enabled
            ? primaryColor
            : CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context);

    final TextStyle textStyle = themeData.textTheme.textStyle.copyWith(color: foregroundColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: widget.minSize == null
              ? const BoxConstraints()
              : BoxConstraints(
                  minWidth: widget.minSize!,
                  minHeight: widget.minSize!,
                ),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: backgroundColor != null && !enabled ? CupertinoDynamicColor.resolve(widget.disabledColor, context) : backgroundColor,
              ),
              child: Align(
                alignment: widget.alignment,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: DefaultTextStyle(
                  style: textStyle,
                  child: IconTheme(
                    data: IconThemeData(color: foregroundColor),
                    child: Stack(
                      children: [
                        widget.child,
                        if (widget.shouldDarken)
                          Positioned.fill(
                            child: FadeTransition(
                              opacity: _darkenAnimation,
                              child: Container(
                                decoration: BoxDecoration(color: widget.splashColor, borderRadius: widget.borderRadius),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
