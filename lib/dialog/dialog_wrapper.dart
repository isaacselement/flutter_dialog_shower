import 'package:flutter/material.dart';


import '../core/boxes.dart';
import 'dialog_shower.dart';

class DialogWrapper {
  /// Shower basic useage wrapper
  // Note, direction example:
  // Offset(1.0, 0.0) -> From Right, Offset(-1.0, 0.0) -> From Left
  // Offset(0.0, 1.0) -> From Bottom, Offset(0.0, -1.0) -> From Top
  // Offset(-1.0, -1.0) LeftTop to Destination ...

  // same ui effect as function [show] ...
  static DialogShower showCenter(Widget child, {required double width, required double height, String? key}) {
    MediaQueryData query = MediaQueryData.fromWindow(Boxes.getWindow());
    return show(child, x: (query.size.width - width) / 2, y: (query.size.height - height) / 2, width: width, height: height, key: key);
  }

  static DialogShower showRight(Widget child, {bool isFixed = false, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(1.0, 0.0), key: key);
    if (isFixed) {
      shower.alignment = Alignment.topRight;
      shower.padding = const EdgeInsets.only(top: -1, right: 16);
    } else {
      shower.alignment = Alignment.centerRight;
      shower.padding = const EdgeInsets.only(right: 16);
    }
    return shower;
  }

  static DialogShower showLeft(Widget child, {bool isFixed = false, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(-1.0, 0.0), key: key);
    if (isFixed) {
      shower.alignment = Alignment.topLeft;
      shower.padding = const EdgeInsets.only(top: -1, left: 16);
    } else {
      shower.alignment = Alignment.centerLeft;
      shower.padding = const EdgeInsets.only(left: 16);
    }
    return shower;
  }

  static DialogShower showBottom(Widget child, {double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, direction: const Offset(0.0, 1.0), key: key);
    shower.alignment = Alignment.bottomCenter;
    shower.padding = const EdgeInsets.only(bottom: 16);
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
        ..padding = const EdgeInsets.only(left: -1, top: -1);
    }
    if (x != null && y != null) {
      shower
        ..alignment = isFixed ? null : Alignment.topLeft
        ..padding = EdgeInsets.only(left: x, top: y);
    }

    Widget? widget = centralOfShower?.call(shower, child: child) ?? child;

    shower.show(widget, width: width, height: height);
    add(shower, key: key);
    shower.addDismissCallBack((d) {
      remove(d);
    });
    return shower;
  }

  // control center for shower that showed by this wrapper
  static Widget? Function(DialogShower shower, {Widget? child})? centralOfShower;

  /// Navigator push and pop
  static DialogShower? getTopNavigatorDialog() {
    DialogShower? shower;
    DialogWrapper.iterateDialogs((dialog) {
      bool isBingo = dialog.isWrappedByNavigator;
      shower = isBingo ? dialog : null;
      return shower != null;
    });
    return shower;
  }

  static DialogShower pushRoot(
    Widget widget, {
    RouteSettings? settings,
    bool isFixed = false,
    double? x,
    double? y,
    double? width,
    double? height,
    Offset? direction,
    String? key,
  }) {
    return DialogWrapper.show(widget, isFixed: isFixed, x: x, y: y, width: width, height: height, direction: direction, key: key)
      ..isWrappedByNavigator = true
      ..wrappedNavigatorInitialName = settings?.name;
  }

  // should use 'pushRoot' first or that there is a shower with 'isWrappedByNavigator = true' on showing
  static Future<T?> push<T extends Object?>(
    Widget widget, {
    PageRouteBuilder<T>? routeBuilder,
    RoutePageBuilder? pageBuilder,
    RouteTransitionsBuilder? transition,

    // copy from PageRouteBuilder constructor
    RouteSettings? settings,
    Duration? duration,
    Duration? reverseDuration,
    bool? opaque,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState,
    bool? fullscreenDialog,
  }) {
    DialogShower? shower = getTopNavigatorDialog();
    return shower!.push(
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

    // Map<String, DialogShower> map = {}..addAll(_map());
    _map().clear(); // just clear, cause _addDialog entry method: _map element already in _list
    // map.forEach((key, dialog) async {
    //   await _dismiss(dialog);
    // });
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
    // remove & dismiss from top to bottom if dialog in list
    if (dialog != null && (_list().contains(dialog))) {
      List<DialogShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        DialogShower d = tmp.elementAt(i);
        remove(d);
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
        remove(d);
        await _dismiss(d);
        if (d == dialog) {
          break;
        }
      }
    }
  }

  // important!!! do not use this method unless you take management of your own shower
  static Future<void> _dismiss(DialogShower? dialog) async {
    if (dialog != null) {
      await dialog.dismiss();
    }
  }

  // shower management: add/remove/iterate in ordinal
  static void remove(DialogShower? dialog) {
    _list().remove(dialog);
    _map().removeWhere((key, value) => value == dialog);
  }

  static void add(DialogShower dialog, {String? key}) {
    if (key != null) {
      _map()[key] = dialog;
    }
    _list().add(dialog);
  }
}
