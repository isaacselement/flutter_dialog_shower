// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

/// Button Widgets

class CcButtonWidget extends StatefulWidget {
  String? title;
  CcButtonWidgetOptions? options;
  void Function(CcButtonState state) onTap;
  Widget? Function(CcButtonState state)? builder;

  CcButtonWidget({Key? key, this.title, this.builder, this.options, required this.onTap}) : super(key: key);

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
            margin: options.margin,
            padding: options.padding,
            alignment: options.alignment,
            decoration: options.isDisable ? options.decorationDisable : options.decoration,
            child: widget.builder?.call(this) ??
                Text(
                  widget.title ?? 'Cancel',
                  maxLines: 1,
                  style: options.isDisable ? options.titleStyle : options.titleStyleDisable,
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
  EdgeInsets? margin;
  EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  AlignmentGeometry? alignment = Alignment.center;

  BoxDecoration? decoration = BoxDecoration(
    color: const Color(0xFF4275FF),
    border: Border.all(color: const Color(0xFFDADAE8)),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );
  BoxDecoration? decorationDisable = BoxDecoration(
    color: const Color(0xFFF5F5FA),
    border: Border.all(color: const Color(0xFFDADAE8)),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  TextStyle? titleStyle = const TextStyle(color: Color(0xFFFFFFFF));
  TextStyle? titleStyleDisable = const TextStyle(color: Color(0xFFBFBFD2));

  CcButtonWidgetOptions();

  CcButtonWidgetOptions clone() {
    CcButtonWidgetOptions newInstance = CcButtonWidgetOptions();
    newInstance.isDisable = isDisable;
    newInstance.pressedOpacity = pressedOpacity;

    newInstance.width = width;
    newInstance.height = height;
    newInstance.margin = margin;
    newInstance.padding = padding;
    newInstance.alignment = alignment;
    newInstance.decoration = decoration;
    newInstance.decorationDisable = decorationDisable;

    newInstance.titleStyle = titleStyle;
    newInstance.titleStyleDisable = titleStyleDisable;
    return newInstance;
  }
}

/// Cupertino Button

class CcAppleButton extends StatelessWidget {
  CcAppleButton({Key? key, this.title, this.child, required this.onPressed, this.isDisable, this.options}) : super(key: key);

  String? title;
  Widget? child;
  bool? isDisable;
  VoidCallback onPressed;
  CcAppleButtonOptions? options;

  bool get _isDisable => (isDisable ??= false);

  CcAppleButtonOptions get _options => (options ??= CcAppleButtonOptions());

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: _isDisable ? null : onPressed,
      child: Container(
        width: _options.width,
        height: _options.height,
        margin: _options.margin,
        padding: _options.padding,
        alignment: _options.alignment,
        decoration: _isDisable ? _options.decorationDisable : _options.decoration,
        child: child ?? Text(title ?? '', style: _isDisable ? _options.titleStyleDisable : _options.titleStyle),
      ),
    );
  }
}

class CcAppleButtonOptions {
  double? width;
  double? height;
  EdgeInsets? margin;
  EdgeInsets? padding = const EdgeInsets.symmetric(vertical: 10);
  Alignment? alignment = Alignment.center;
  BoxDecoration? decoration = const BoxDecoration(color: Color(0xFF006BE1), borderRadius: BorderRadius.all(Radius.circular(5)));
  BoxDecoration? decorationDisable = const BoxDecoration(color: Color(0xFFF5F5FA), borderRadius: BorderRadius.all(Radius.circular(5)));

  TextStyle? titleStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle? titleStyleDisable = const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16);

  CcAppleButtonOptions();

  CcAppleButtonOptions clone() {
    CcAppleButtonOptions newInstance = CcAppleButtonOptions();

    newInstance.width = width;
    newInstance.height = height;
    newInstance.margin = margin;
    newInstance.padding = padding;
    newInstance.alignment = alignment;
    newInstance.decoration = decoration;
    newInstance.decorationDisable = decorationDisable;

    newInstance.titleStyle = titleStyle;
    newInstance.titleStyleDisable = titleStyleDisable;
    return newInstance;
  }
}

/// Tapped Widgets

class CcTapWidget extends StatefulWidget {
  Widget? child;
  bool isDisable = false;
  double? pressedOpacity;
  void Function(State state)? onTap;
  Widget Function(State state)? builder;

  CcTapWidget({Key? key, this.child, this.isDisable = false, this.pressedOpacity, this.builder, this.onTap}) : super(key: key);

  @override
  State createState() => CcTapState();
}

class CcTapState extends State {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    if (myWidget.isDisable) return;
    setState(() => _isTapingDown = v);
  }

  CcTapWidget get myWidget => widget as CcTapWidget;

  @override
  Widget build(BuildContext context) {
    Widget mChild() => myWidget.builder?.call(this) ?? Opacity(child: myWidget.child, opacity: isTapingDown ? myWidget.pressedOpacity ?? 0.5 : 1);
    return Listener(
      onPointerUp: (e) => isTapingDown = false,
      onPointerDown: (e) => isTapingDown = true,
      onPointerCancel: (e) => isTapingDown = false,
      child: myWidget.isDisable ? mChild() : GestureDetector(onTap: () => onEventTap(), child: mChild()),
    );
  }

  void onEventTap() {
    myWidget.onTap?.call(this);
  }
}

/// with tap effect and tap once only
class CcTapOnceWidget extends CcTapWidget {
  CcTapOnceWidget({
    Key? key,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    void Function(State state)? onTap,
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

class CcTapOnceState extends CcTapState {
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
    this.throttle,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    void Function(State state)? onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable ?? false,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  AnyThrottle? throttle;

  @override
  State createState() => CcTapThrottledState();
}

class CcTapThrottledState extends CcTapState {
  @override
  void onEventTap() => ((widget as CcTapThrottledWidget).throttle ?? AnyThrottle.instance).call(() => super.onEventTap());
}

/// Tapped Widget with debounce
class CcTapDebouncerWidget extends CcTapWidget {
  CcTapDebouncerWidget({
    Key? key,
    this.debouncer,
    Widget? child,
    bool? isDisable,
    double? pressedOpacity = 0.5,
    Widget Function(State state)? builder,
    void Function(State state)? onTap,
  }) : super(
          key: key,
          child: child,
          isDisable: isDisable ?? false,
          pressedOpacity: pressedOpacity,
          builder: builder,
          onTap: onTap,
        );

  AnyDebouncer? debouncer;

  @override
  State createState() => CcTapDebouncerState();
}

class CcTapDebouncerState extends CcTapState {
  @override
  void onEventTap() => ((widget as CcTapDebouncerWidget).debouncer ?? AnyDebouncer.instance).call(() => super.onEventTap());
}

/// Action Sheet Button
class ActionSheetButtons extends StatelessWidget {
  List<Object?> items;

  double? itemWidth;
  double? itemHeight;
  double? itemSpacing;
  TextStyle? itemTextStyle;
  CcButtonWidgetOptions? itemOptions;

  Widget Function(int index, Object? item)? itemOuterBuilder;
  Widget Function(int index, Object? item)? itemInnerBuilder;

  String Function(int index, Object? item)? funcOfItemName;
  bool Function(int index, Object? item)? funcOfItemOnTapped;

  ActionSheetButtons({
    Key? key,
    required this.items,
    this.itemWidth,
    this.itemHeight,
    this.itemSpacing,
    this.itemOuterBuilder,
    this.itemInnerBuilder,
    this.funcOfItemName,
    this.funcOfItemOnTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CcButtonWidgetOptions options = itemOptions ?? CcButtonWidgetOptions()
      ..height = itemHeight ?? 45
      ..decoration = BoxDecoration(
        color: const Color(0xFFF5F5FA),
        border: Border.all(color: const Color(0xFFDADAE8)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      );
    TextStyle textStyle = itemTextStyle ?? const TextStyle(color: Color(0xFF1C1D21), fontSize: 16);

    /// children
    List<Widget> children = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      Object? e = items[i];
      Widget child = itemOuterBuilder?.call(i, e) ??
          CcButtonWidget(
            options: options,
            builder: (state) {
              return itemInnerBuilder?.call(i, e) ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        funcOfItemName?.call(i, e) ?? e?.toString() ?? '',
                        style: textStyle,
                      )
                    ],
                  );
            },
            onTap: (state) {
              if (funcOfItemOnTapped?.call(i, e) ?? false) {
                /// caller handle the event totally
              } else {
                DialogWrapper.dismissTopDialog();
              }
            },
          );
      if (itemSpacing != null) children.add(SizedBox(height: itemSpacing));
      children.add(child);
    }

    /// column
    Widget widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    return itemWidth != null ? SizedBox(width: itemWidth, child: widget) : widget;
  }
}
