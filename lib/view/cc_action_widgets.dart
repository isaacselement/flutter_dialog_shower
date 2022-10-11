import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    setState(() {
      _isTapingDown = v;
    });
  }

  CcButtonWidgetOptions? _options;

  CcButtonWidgetOptions get options => widget.options ?? (_options ??= CcButtonWidgetOptions());

  @override
  Widget build(BuildContext context) {
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
            decoration: options.isDisable ? options.decorationDisable : options.decoration,
            child: widget.builder?.call(this) ??
                Text(
                  widget.text ?? 'Cancel',
                  maxLines: 1,
                  style: options.isDisable ? options.textStyle : options.textStyleDisable,
                ),
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
  bool isDisable = false;
  double pressedOpacity = 0.4;

  double? width;
  double? height;

  EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  AlignmentGeometry? alignment = Alignment.center;

  BoxDecoration? decoration = BoxDecoration(
    border: Border.all(color: const Color(0xFFDADAE8)),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    color: const Color(0xFF4275FF),
  );
  BoxDecoration? decorationDisable = BoxDecoration(
    border: Border.all(color: const Color(0xFFDADAE8)),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    color: const Color(0xFFF5F5FA),
  );

  TextStyle? textStyle = const TextStyle(color: Color(0xFFFFFFFF));
  TextStyle? textStyleDisable = const TextStyle(color: Color(0xFFBFBFD2));

  CcButtonWidgetOptions();

  CcButtonWidgetOptions clone() {
    CcButtonWidgetOptions newInstance = CcButtonWidgetOptions();
    newInstance.isDisable = isDisable;
    newInstance.pressedOpacity = pressedOpacity;

    newInstance.width = width;
    newInstance.height = height;
    newInstance.padding = padding;
    newInstance.alignment = alignment;
    newInstance.decoration = decoration;
    newInstance.decorationDisable = decorationDisable;

    newInstance.textStyle = textStyle;
    newInstance.textStyleDisable = textStyleDisable;
    return newInstance;
  }
}

/// Cupertino Button

class CcAppleButton extends StatelessWidget {
  CcAppleButton({Key? key, this.title, this.child, required this.onPressed, this.options}) : super(key: key);

  String? title;
  Widget? child;
  VoidCallback onPressed;
  CcAppleButtonOptions? options;

  CcAppleButtonOptions get _options => (options ??= CcAppleButtonOptions());

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: _options.width,
        height: _options.height,
        padding: _options.padding,
        alignment: _options.alignment,
        decoration: _options.decoration,
        child: child ?? Text(title ?? '', style: _options.titleStyle),
      ),
    );
  }
}

class CcAppleButtonOptions {
  CcAppleButtonOptions();

  double? width;
  double? height;
  Alignment? alignment = Alignment.center;
  EdgeInsets? padding = const EdgeInsets.symmetric(vertical: 10);
  BoxDecoration? decoration = const BoxDecoration(color: Color(0xFF006BE1), borderRadius: BorderRadius.all(Radius.circular(5)));

  TextStyle? titleStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);
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
