import 'package:flutter/widgets.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

/// Button Widgets

class CcButtonWidget extends StatefulWidget {
  String? text;
  CcButtonWidgetOptions? options;
  void Function(CcButtonState state) onTap;
  Widget? Function(CcButtonState state)? builder;

  CcButtonWidget({Key? key, this.text, this.builder, this.options, required this.onTap}) : super(key: key);

  @override
  State<CcButtonWidget> createState() => CcButtonState();
}

class CcButtonState extends State<CcButtonWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    if (options.isDisable) return;
    _isTapingDown = v;
    setState(() {});
  }

  CcButtonWidgetOptions? _options;

  CcButtonWidgetOptions get options => widget.options ?? (_options ??= CcButtonWidgetOptions());

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = options.decoration ??
        BoxDecoration(
          border: Border.all(color: const Color(0xFFDADAE8)),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: options.isDisable ? const Color(0xFFF5F5FA) : const Color(0xFF4275FF),
        );
    TextStyle textStyle = options.textStyle ??
        TextStyle(
          color: options.isDisable ? const Color(0xFFBFBFD2) : const Color(0xFFFFFFFF),
        );

    return Listener(
      onPointerUp: (event) => isTapingDown = false,
      onPointerDown: (event) => isTapingDown = true,
      child: GestureDetector(
        child: Opacity(
          opacity: isTapingDown ? options.pressedOpacity : 1.0,
          child: Container(
            width: options.width,
            height: options.height,
            padding: options.padding,
            alignment: options.alignment,
            decoration: decoration,
            child: widget.builder?.call(this) ?? Text(widget.text ?? 'Cancel', style: textStyle, maxLines: 1),
          ),
        ),
        onTap: () {
          if (options.isDisable) return;
          widget.onTap.call(this);
        },
      ),
    );
  }
}

class CcButtonWidgetOptions {
  double? width;
  double? height;

  TextStyle? textStyle;
  EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  BoxDecoration? decoration;
  AlignmentGeometry? alignment = Alignment.center;

  bool isDisable = false;
  double pressedOpacity = 0.4;

  CcButtonWidgetOptions();

  CcButtonWidgetOptions clone() {
    CcButtonWidgetOptions newInstance = CcButtonWidgetOptions();
    newInstance.width = width;
    newInstance.height = height;
    newInstance.textStyle = textStyle;
    newInstance.padding = padding;
    newInstance.decoration = decoration;
    newInstance.alignment = alignment;
    newInstance.isDisable = isDisable;
    newInstance.pressedOpacity = pressedOpacity;
    return newInstance;
  }
}

/// Tapped Widgets

abstract class CcTapViewBase extends StatefulWidget {
  Widget? child;
  bool isDisable = false;
  double? pressedOpacity;
  void Function(State state) onTap;
  Widget Function(State state)? builder;

  CcTapViewBase({Key? key, this.child, this.isDisable = false, this.pressedOpacity, this.builder, required this.onTap}) : super(key: key);
}

abstract class CcTapStateBase extends State {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    if (myWidget.isDisable) return;
    setState(() => _isTapingDown = v);
  }

  CcTapViewBase get myWidget => widget as CcTapViewBase;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) => isTapingDown = false,
      onPointerDown: (e) => isTapingDown = true,
      onPointerCancel: (e) => isTapingDown = false,
      child: GestureDetector(
        onTap: () {
          if (myWidget.isDisable) return;
          onEventTap();
        },
        child: myWidget.builder?.call(this) ?? Opacity(child: myWidget.child, opacity: isTapingDown ? myWidget.pressedOpacity ?? 0.5 : 1),
      ),
    );
  }

  void onEventTap() {
    myWidget.onTap(this);
  }
}

/// with tap effect
class CcTapWidget extends CcTapViewBase {
  CcTapWidget({
    Key? key,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable ?? false,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  @override
  State createState() => CcTapState();
}

class CcTapState extends CcTapStateBase {}

/// with tap effect and tap once only
class CcTapOnceWidget extends CcTapViewBase {
  CcTapOnceWidget({
    Key? key,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable ?? false,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  @override
  State createState() => CcTapOnceState();
}

class CcTapOnceState extends CcTapStateBase {
  bool _isTappedOnce = false;

  @override
  void onEventTap() {
    if (_isTappedOnce) {
      return;
    }
    _isTappedOnce = true;
    super.onEventTap();
  }
}

/// Tapped Widget with throttle
class CcTapThrottledWidget extends CcTapWidget {
  CcTapThrottledWidget({
    Key? key,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  @override
  State createState() => CcTapThrottledState();
}

class CcTapThrottledState extends CcTapState {
  @override
  void onEventTap() => AnyThrottle.instance.call(() => super.onEventTap());
}

/// Tapped Widget with debounce
class CcTapDebouncerWidget extends CcTapWidget {
  CcTapDebouncerWidget({
    Key? key,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    required void Function(State state) onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  @override
  State createState() => CcTapDebouncerState();
}

class CcTapDebouncerState extends CcTapState {
  @override
  void onEventTap() => AnyDebouncer.instance.call(() => super.onEventTap());
}
