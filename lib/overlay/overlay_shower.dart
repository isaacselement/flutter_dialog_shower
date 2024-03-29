import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

class OverlayShower {
  static BuildContext? gContext;

  String name = '';
  BuildContext? context;

  bool isSyncShow = false; // should assign value before show method
  bool isWithTicker = false; // should assign value before show method

  bool isUseRootOverlay = true;
  bool isWrappedNothing = false;
  bool isWrappedMaterial = true;

  OverlayEntry? showBelow, showAbove; // insert below or above entry

  late OverlayEntry _entry;

  OverlayEntry get entry => _entry;

  bool _isShowing = false;

  bool get isShowing => _isShowing;

  OverlayState get parentOverlayState => Overlay.of(context!, rootOverlay: isUseRootOverlay);

  /// for Container
  double? dx;
  double? dy;
  EdgeInsets? margin;
  EdgeInsets? padding;
  AlignmentGeometry? alignment = Alignment.topLeft;

  /// for Positioned
  set x(double? v) => left = v;

  set y(double? v) => top = v;

  double? get x => left;

  double? get y => top;

  double? top;
  double? left;
  double? right;
  double? bottom;
  double? width;
  double? height;

  /// for set state
  GlobalKey get statefulKey => _statefulKey;
  final GlobalKey _statefulKey = GlobalKey();

  /// for Events
  void Function(OverlayShower shower)? onTapCallback;
  void Function(OverlayShower shower)? onShowCallBack;
  void Function(OverlayShower shower)? onDismissCallBack;

  List<void Function(OverlayShower shower)>? showCallbacks;
  List<void Function(OverlayShower shower)>? dismissCallbacks;

  void addShowCallBack(void Function(OverlayShower shower) cb) => (showCallbacks = showCallbacks ?? []).add(cb);

  void removeShowCallBack(void Function(OverlayShower shower) cb) => (showCallbacks = showCallbacks ?? []).remove(cb);

  void addDismissCallBack(void Function(OverlayShower shower) cb) => (dismissCallbacks = dismissCallbacks ?? []).add(cb);

  void removeDismissCallBack(void Function(OverlayShower shower) cb) => (dismissCallbacks = dismissCallbacks ?? []).remove(cb);

  /// holder object for various uses if you need ...
  Object? obj;

  // init methods ----------------------------------------

  static void init(BuildContext context) {
    if (gContext == context) {
      return;
    }
    gContext = context;
  }

  OverlayShower([BuildContext? ctx]) {
    name = 'LAYER-${DateTime.now().microsecondsSinceEpoch}';
    context = ctx ?? gContext;
  }

  // show ----------------------------------------

  OverlayShower show([Widget? child]) {
    isSyncShow ? showImmediately(child) : Future.microtask(() => showImmediately(child));
    return this;
  }

  OverlayShower showImmediately(Widget? child, {OverlayEntry? below, OverlayEntry? above}) {
    _isShowing = true;
    _entry = OverlayEntry(builder: (context) => body(child));
    parentOverlayState.insert(_entry, below: below, above: above);
    return this;
  }

  Widget body(Widget? child) {
    void _init(state) => _invokeShowCallbacks();

    void _dispose(state) => _invokeDismissCallbacks();

    Widget _builder(state) => isWrappedNothing ? _rawChild(child) : _getRebuildWidget(child);

    // will rebuild with statefulKey
    GlobalKey mKey = _statefulKey;
    if (isWithTicker) {
      return BuilderWithTicker(key: mKey, init: _init, dispose: _dispose, builder: _builder);
    }
    return BuilderEx(key: mKey, init: _init, dispose: _dispose, builder: _builder);
  }

  Widget _getRebuildWidget(Widget? child) {
    // 1. locating with Positioned
    bool isPositioned = top != null || left != null || right != null || bottom != null;
    if (isPositioned) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: _wrapperChild(child),
      );
    }
    // 2. locating by padding with Container, please set 'alignment = Alignment.topLeft;' if u want base on top left
    if (dx != null || dy != null) {
      padding = EdgeInsets.only(left: dx ?? padding?.left ?? 0, top: dy ?? padding?.top ?? 0);
    }
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      // color: Colors.black.withAlpha(128),
      child: _wrapperChild(child),
    );
  }

  Widget _wrapperChild(Widget? child) {
    GestureDetector gesture = GestureDetector(
      onTap: () => onTapCallback?.call(this),
      child: _rawChild(child),
    );
    return isWrappedMaterial ? Material(type: MaterialType.transparency, child: gesture) : gesture;
  }

  // dismiss ----------------------------------------

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      _dismiss();
    }
  }

  void _dismiss() {
    _entry.remove();
  }

  // setState ----------------------------------------

  Widget? newChild;

  Widget Function(OverlayShower shower)? builder;

  void setNewChild(Widget? child) {
    newChild = child;
    setState(() {});
  }

  void setBuilder(Widget Function(OverlayShower shower)? _builder) {
    builder = _builder;
    setState(() {});
  }

  Widget _rawChild(Widget? child) {
    return builder?.call(this) ?? newChild ?? child ?? const Offstage(offstage: true);
  }

  void setState(VoidCallback fn) {
    // _statefulKey.currentState?.setState(fn);
    (_statefulKey.currentState?.context as StatefulElement?)?.markNeedsBuild();
  }

  // others ----------------------------------------

  void _invokeShowCallbacks() {
    onShowCallBack?.call(this);
    for (int i = 0; i < (showCallbacks?.length ?? 0); i++) {
      showCallbacks?.elementAt(i).call(this);
    }
  }

  void _invokeDismissCallbacks() {
    onDismissCallBack?.call(this);
    for (int i = 0; i < (dismissCallbacks?.length ?? 0); i++) {
      dismissCallbacks?.elementAt(i).call(this);
    }
  }
}
