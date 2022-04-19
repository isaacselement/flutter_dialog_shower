import 'package:flutter/material.dart';

import '../dialog/dialog_shower.dart';

class OverlayShower {
  static BuildContext? gContext;

  String name = '';
  BuildContext? context;

  bool isSyncShow = false; // should assign value before show method
  bool isWithTicker = false; // should assign value before show method

  bool isUseRootOverlay = true;
  bool isWrappedMaterial = true;

  OverlayEntry? showBelow, showAbove; // insert below or above entry

  late OverlayEntry _entry;

  OverlayEntry get entry => _entry;

  bool _isShowing = false;

  bool get isShowing => _isShowing;

  /// for Container
  double? dx;
  double? dy;
  EdgeInsets? margin;
  EdgeInsets? padding;
  AlignmentGeometry? alignment = Alignment.topLeft;

  /// for Positioned
  double? x;
  double? y;
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
  Widget Function(OverlayShower shower)? builder;
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
    _entry = OverlayEntry(builder: (context) => _getBody(child));
    Overlay.of(context!, rootOverlay: isUseRootOverlay)!.insert(_entry, below: below, above: above);
    _invokeShowCallbacks();
    return this;
  }

  Widget _getBody(Widget? child) {
    // will rebuild with statefulKey
    GlobalKey mKey = _statefulKey;
    if (isWithTicker) {
      return StatefulBuilderEx(key: mKey, builder: (context, setState) => _getRebuildableWidget(child));
    }
    return StatefulBuilder(key: mKey, builder: (context, setState) => _getRebuildableWidget(child));
  }

  Widget _getRebuildableWidget(Widget? child) {
    // 1. locating with Positioned
    top ??= y;
    left ??= x;
    bool isPositioned = top != null || left != null || right != null || bottom != null || width != null || height != null;
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
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: _wrapperChild(child),
    );
  }

  Widget _wrapperChild(Widget? child) {
    GestureDetector gesture = GestureDetector(
      onTap: () => onTapCallback?.call(this),
      child: builder?.call(this) ?? _newChild ?? child,
    );
    return isWrappedMaterial ? Material(type: MaterialType.transparency, child: gesture) : gesture;
  }

  // dismiss ----------------------------------------

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      _dissmiss();
    }
  }

  void _dissmiss() {
    _entry.remove();
    _invokeDismissCallbacks();
  }

  // setState ----------------------------------------

  Widget? _newChild;

  void setNewChild(Widget? newChild) {
    _newChild = newChild;
    setState(() {});
  }

  void setState(VoidCallback fn) {
    _statefulKey.currentState?.setState(fn);
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
