import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dialog_shower.dart';

class DialogWrapper {
  /// Shower basic useage wrapper
  // Note, direction example:
  // Offset(1.0, 0.0) -> From Right, Offset(-1.0, 0.0) -> From Left
  // Offset(0.0, 1.0) -> From Bottom, Offset(0.0, -1.0) -> From Top
  // Offset(-1.0, -1.0) LeftTop to Destination ...

  // same ui effect as function [show] ...
  static DialogShower showCenter(Widget child, {required double width, required double height, String? key}) {
    MediaQueryData query = MediaQueryData.fromWindow(WidgetsBinding.instance?.window ?? ui.window);
    return show(child, x: (query.size.width - width) / 2, y: (query.size.height - height) / 2, width: width, height: height, key: key);
  }

  static DialogShower showRight(Widget child, {bool isFixed = false, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(1.0, 0.0), key: key);
    if (isFixed) {
      shower.alignment = Alignment.topRight;
      shower.margin = const EdgeInsets.only(top: -1, right: 16);
    } else {
      shower.alignment = Alignment.centerRight;
      shower.margin = const EdgeInsets.only(right: 16);
    }
    return shower;
  }

  static DialogShower showLeft(Widget child, {bool isFixed = false, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(-1.0, 0.0), key: key);
    if (isFixed) {
      shower.alignment = Alignment.topLeft;
      shower.margin = const EdgeInsets.only(top: -1, left: 16);
    } else {
      shower.alignment = Alignment.centerLeft;
      shower.margin = const EdgeInsets.only(left: 16);
    }
    return shower;
  }

  static DialogShower showBottom(Widget child, {double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(0.0, 1.0), key: key);
    shower.alignment = Alignment.bottomCenter;
    shower.margin = const EdgeInsets.only(bottom: 16);
    return shower;
  }

  static DialogShower show(Widget child,
      {bool isFixed = false, double? x, double? y, double? width, double? height, Offset? direction, String? key}) {
    return showWith(DialogShower(), child, isFixed: isFixed, x: x, y: y, width: width, height: height, direction: direction, key: key);
  }

  static DialogShower showWith(DialogShower shower, Widget child,
      {bool isFixed = false, double? x, double? y, double? width, double? height, Offset? direction, String? key}) {
    shower
      ..build()
      ..barrierDismissible = null // null indicate that: dimiss keyboard first while keyboard is showing, else dismiss dialog immediately
      ..containerShadowColor = Colors.grey
      ..containerShadowBlurRadius = 20.0
      ..containerBorderRadius = 10.0;

    if (direction != null) {
      shower.animationBeginOffset = direction;
    }

    if (isFixed) {
      shower
        ..alignment = null
        ..margin = const EdgeInsets.only(left: -1, top: -1);
    }
    if (x != null && y != null) {
      shower
        ..alignment = isFixed ? null : Alignment.topLeft
        ..margin = EdgeInsets.only(left: x, top: y);
    }

    centralOfShower?.call(shower);

    shower.show(child, width: width, height: height);
    _addDialog(shower, key: key);
    shower.addDismissCallBack((d) {
      _remove(d);
    });
    return shower;
  }

  // control center for shower that showed by this wrapper
  static Function(DialogShower shower)? centralOfShower;

  /// Navigator push and pop
  static DialogShower? getTopNavigatorDialog() {
    DialogShower? result;
    DialogWrapper.iterateDialogs((dialog) {
      bool isBingo = dialog.isWrappedByNavigator;
      result = isBingo ? dialog : null;
      return result != null;
    });
    return result;
  }

  static DialogShower pushRoot(Widget widget,
      {bool isFixed = false, double? x, double? y, double? width, double? height, Offset? direction, String? key}) {
    return DialogWrapper.show(widget, isFixed: isFixed, x: x, y: y, width: width, height: height, direction: direction, key: key)
      ..isWrappedByNavigator = true;
  }

  // should use 'pushRoot' first or that there is a shower with 'isWrappedByNavigator = true' on showing
  static Future<T?> push<T extends Object?>(
    Widget widget, {
    PageRouteBuilder<T>? routeBuilder,
    RoutePageBuilder? pageBuilder,
    RouteTransitionsBuilder? transition,

    // copy from PageRouteBuilder constructor
    RouteSettings? settings,
    double? duration,
    double? reverseDuration,
    bool? opaque,
    double? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState,
    bool? fullscreenDialog,
  }) {
    DialogShower? topNavigatorDialog = getTopNavigatorDialog();
    return topNavigatorDialog!.push(
      widget,
      duration: duration ?? const Duration(milliseconds: 200),
      reverseDuration: reverseDuration ?? const Duration(milliseconds: 200),
      transition: transition ??
          (BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animOne),
              child: child,
            );
          },
      routeBuilder: routeBuilder,
      pageBuilder: pageBuilder,
      settings: settings,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static void pop<T>({T? result}) {
    getTopNavigatorDialog()?.pop(result: result);
  }

  /// Appearing dialogs management
  static List<DialogShower>? appearingDialogs;

  static Map<String, DialogShower>? appearingDialogsMappings;

  static List<DialogShower> _list() {
    return (appearingDialogs = appearingDialogs ?? []);
  }

  // TODO ... insert a prefix into key for ordinal, then pop until ...
  static Map<String, DialogShower> _map() {
    return (appearingDialogsMappings = appearingDialogsMappings ?? {});
  }

  static DialogShower? getTopDialog() {
    return _list().isNotEmpty ? _list().last : null;
  }

  static DialogShower? getDialogByIndex(int reverseIndex) {
    int index = (_list().length - 1) - reverseIndex; // reverse index
    return index >= 0 && index < _list().length ? _list()[index] : null;
  }

  static DialogShower? getDialogByKey(String key) {
    return _map()[key];
  }

  static void iterateDialogs(bool Function(DialogShower dialog) handler) {
    List<DialogShower> tmp = [..._list()];
    for (int i = tmp.length - 1; i >= 0; i--) {
      if (handler(tmp.elementAt(i))) {
        break;
      }
    }
  }

  static Future<void> dismissAppearingDialogs() async {
    List<DialogShower> tmp = [..._list()];
    _list().clear();
    for (int i = tmp.length - 1; i >= 0; i--) {
      var dialog = tmp[i];
      await _dismiss(dialog);
    }

    // TODO ... not in top to bottom ordinal now ...
    Map<String, DialogShower> map = {}..addAll(_map());
    _map().clear();
    map.forEach((key, dialog) async {
      await _dismiss(dialog);
    });
  }

  static Future<void> dismissTopDialog({int? count}) async {
    if (count != null && count > 0) {
      for (int i = 0; i < count; i++) {
        await dismissDialog(_list().isNotEmpty ? _list().last : null);
      }
      return;
    }
    await dismissDialog(_list().isNotEmpty ? _list().last : null);
  }

  static Future<void> dismissDialog(DialogShower? dialog, {String? key}) async {
    // remove & dismiss from top to bottom
    if (dialog != null) {
      List<DialogShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        DialogShower d = tmp.elementAt(i);
        _remove(d);
        await _dismiss(d);
        if (d == dialog) {
          break;
        }
      }
    }
    if (key != null && (dialog = _map()[key]) != null) {
      List<DialogShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        DialogShower d = tmp.elementAt(i);
        _remove(d);
        await _dismiss(d);
        if (d == dialog) {
          break;
        }
      }
    }
  }

  // important!!! do not use this method unless you take management of your own dialog
  static Future<void> _dismiss(DialogShower? dialog) async {
    if (dialog != null) {
      await dialog.dismiss();
    }
  }

  // dialog management: add/remove/iterate in ordinal
  static void _remove(DialogShower? dialog) {
    _list().remove(dialog);
    _map().removeWhere((key, value) => value == dialog);
  }

  static void _addDialog(DialogShower dialog, {String? key}) {
    if (key != null) {
      _map()[key] = dialog;
    }
    _list().add(dialog);
  }
}
