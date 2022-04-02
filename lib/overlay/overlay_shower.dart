import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';

class OverlayShower {
  static BuildContext? gContext;

  String name = '';
  BuildContext? context;

  bool isSyncShow = false; // should assign value before show method
  bool isWithTicker = false; // should assign value before show method
  bool isSyncDismiss = false;
  bool isSyncInvokeShowCallback = false;
  bool isSyncInvokeDismissCallback = false;

  bool isUseRootOverlay = false;

  OverlayEntry? showBelow, showAbove;  // insert below or above entry

  // for Container
  EdgeInsets? margin;
  EdgeInsets? padding;
  AlignmentGeometry? alignment = Alignment.topLeft;

  // for Positioned
  double? x;
  double? y;
  double? top;
  double? left;
  double? right;
  double? bottom;
  double? width;
  double? height;

  GlobalKey get statefulKey => _statefulKey;
  final GlobalKey _statefulKey = GlobalKey();

  bool _isShowing = false;

  bool get isShowing => _isShowing;

  late OverlayEntry _entry;

  OverlayEntry get entry => _entry;

  Widget Function(OverlayShower shower)? builder;
  void Function(OverlayShower shower)? onTapCallback;
  void Function(OverlayShower shower)? onShowCallBack;
  void Function(OverlayShower shower)? onDismissCallBack;

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
    if (onShowCallBack != null) {
      isSyncInvokeShowCallback ? onShowCallBack?.call(this) : Future.microtask(() => onShowCallBack?.call(this));
    }
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
    bool isPositioned =
        x != null || y != null || top != null || left != null || right != null || bottom != null || width != null || height != null;
    if (isPositioned) {
      return Positioned(
        top: x ?? top,
        left: y ?? left,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: _wrapperChild(child),
      );
    }
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: _wrapperChild(child),
    );
  }

  Widget _wrapperChild(Widget? child) {
    return GestureDetector(
      onTap: () => onTapCallback?.call(this),
      child: builder?.call(this) ?? child,
    );
  }

  // dismiss ----------------------------------------

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      isSyncDismiss ? _dissmiss() : Future.microtask(() => _dissmiss());
    }
  }

  void _dissmiss() {
    _entry.remove();
    if (onDismissCallBack != null) {
      isSyncInvokeShowCallback ? onDismissCallBack?.call(this) : Future.microtask(() => onDismissCallBack?.call(this));
    }
  }

  // setState ----------------------------------------

  void setState(VoidCallback fn) {
    _statefulKey.currentState?.setState(fn);
  }
}
