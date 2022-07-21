import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

class CcButtonWidget extends StatefulWidget {
  CcButtonWidget({
    Key? key,
    this.text,
    this.textStyle,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.decoration,
    this.alignment = Alignment.center,
    this.isDisable = false,
    this.pressedOpacity = 0.4,
    required this.onTap,
    this.builder,
  }) : super(key: key);

  String? text;
  TextStyle? textStyle;

  double? width;
  double? height;
  EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  BoxDecoration? decoration;
  AlignmentGeometry? alignment = Alignment.center;

  bool isDisable = false;
  double pressedOpacity = 0.4;
  void Function(CcButtonState state) onTap;
  Widget? Function(CcButtonState state)? builder;

  @override
  State<CcButtonWidget> createState() => CcButtonState();
}

class CcButtonState extends State<CcButtonWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    if (widget.isDisable) {
      return;
    }
    setState(() => _isTapingDown = v);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = widget.decoration ??
        BoxDecoration(
          border: Border.all(color: const Color(0xFFDADAE8)),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: widget.isDisable ? const Color(0xFFF5F5FA) : const Color(0xFF4275FF),
        );
    TextStyle textStyle = widget.textStyle ??
        TextStyle(
          color: widget.isDisable ? const Color(0xFFBFBFD2) : const Color(0xFFFFFFFF),
        );

    return Listener(
      onPointerUp: (event) => isTapingDown = false,
      onPointerDown: (event) => isTapingDown = true,
      child: GestureDetector(
        child: Opacity(
          opacity: isTapingDown ? widget.pressedOpacity : 1.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            alignment: widget.alignment,
            decoration: decoration,
            child: widget.builder?.call(this) ?? Text(widget.text ?? 'Cancel', style: textStyle, maxLines: 1),
          ),
        ),
        onTap: () {
          if (widget.isDisable) {
            return;
          }
          isTapingDown = false;
          widget.onTap.call(this);
        },
      ),
    );
  }
}

/// Tapped Widget with tap effect

class CcTapWidget extends StatefulWidget {
  final Widget? child;
  final double? pressedOpacity;
  final Widget Function(State state)? builder;
  final void Function(State state) onTap;

  const CcTapWidget({Key? key, this.builder, this.child, required this.onTap, this.pressedOpacity = 0.5}) : super(key: key);

  @override
  State createState() => CcTapWidgetState();
}

class CcTapWidgetState extends State<CcTapWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() => _isTapingDown = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => isTapingDown = true,
      onPointerUp: (e) => isTapingDown = false,
      onPointerCancel: (e) => isTapingDown = false,
      child: GestureDetector(
        child: widget.builder?.call(this) ??
            Opacity(
              child: widget.child,
              opacity: isTapingDown ? widget.pressedOpacity ?? 0.5 : 1,
            ),
        onTap: () {
          onEventTap();
        },
      ),
    );
  }

  void onEventTap() {
    widget.onTap(this);
  }
}

/// Tapped Widget that tap once only
class CcTapOnceWidget extends StatefulWidget {
  final Widget? child;
  final double? pressedOpacity;
  final Widget Function()? builder;
  final void Function(CcTapOnceWidgetState state) onTap;

  const CcTapOnceWidget({Key? key, this.builder, this.child, required this.onTap, this.pressedOpacity = 0.5}) : super(key: key);

  @override
  State<CcTapOnceWidget> createState() => CcTapOnceWidgetState();
}

class CcTapOnceWidgetState extends State<CcTapOnceWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() => _isTapingDown = v);
  }

  bool _isTappedOnce = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => isTapingDown = true,
      onPointerUp: (e) => isTapingDown = false,
      onPointerCancel: (e) => isTapingDown = false,
      child: GestureDetector(
        child: widget.builder?.call() ??
            Opacity(
              child: widget.child,
              opacity: isTapingDown ? widget.pressedOpacity ?? 0.5 : 1,
            ),
        onTap: () {
          onEventTap();
        },
      ),
    );
  }

  void onEventTap() {
    if (_isTappedOnce) {
      return;
    }
    _isTappedOnce = true;
    widget.onTap(this);
  }
}

/// Tapped Widget with throttle
class CcTapThrottledWidget extends CcTapWidget {
  const CcTapThrottledWidget({
    Key? key,
    Widget? child,
    double? pressedOpacity,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(key: key, child: child, builder: builder, onTap: onTap, pressedOpacity: pressedOpacity);

  @override
  State createState() => CcTapThrottledState();
}

class CcTapThrottledState extends CcTapWidgetState {
  @override
  void onEventTap() {
    ThrottleAny.instance.call(() {
      super.onEventTap();
    });
  }
}

/// Tapped Widget with debounce
class CcTapDebouncerWidget extends CcTapWidget {
  const CcTapDebouncerWidget({
    Key? key,
    Widget? child,
    double? pressedOpacity,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(key: key, child: child, builder: builder, onTap: onTap, pressedOpacity: pressedOpacity);

  @override
  State createState() => CcTapDebouncerState();
}

class CcTapDebouncerState extends CcTapWidgetState {
  @override
  void onEventTap() {
    DebouncerAny.instance.call(() {
      super.onEventTap();
    });
  }
}

/// Transform Widget such as for Icons.arrow_back_ios
class CcTransformZ extends StatelessWidget {
  const CcTransformZ({Key? key, this.child, this.ratio}) : super(key: key);

  final Widget? child;
  final double? ratio; // [0.0 - 2.0] * pi for on circle angle

  @override
  Widget build(BuildContext context) {
    return Transform(
      child: child,
      alignment: Alignment.center,
      transform: Matrix4.rotationZ((ratio ?? 0) * math.pi),
    );
  }
}
