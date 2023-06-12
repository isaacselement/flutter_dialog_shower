import 'package:flutter/material.dart';
import 'dialog_shower.dart';

typedef _ReInit = DialogShower? Function(DialogShower shower);

class DialogWrapper {
  /// Shower basic usage in wrapper

  static DialogShower showCenter(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    DialogShower shower = show(child, fixed: fixed, width: width, height: height, key: key);
    shower.transitionBuilder = ShowerTransitionBuilder.fadeIn;
    return shower;
  }

  static DialogShower showRight(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, key: key);
    if (fixed == true) {
      shower.alignment = Alignment.topRight;
      shower.padding = const EdgeInsets.only(top: -1, right: 16);
    } else {
      shower.alignment = Alignment.centerRight;
      shower.padding = const EdgeInsets.only(right: 16);
    }
    shower.transitionBuilder = ShowerTransitionBuilder.slideFromRight;
    return shower;
  }

  static DialogShower showLeft(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, key: key);
    if (fixed == true) {
      shower.alignment = Alignment.topLeft;
      shower.padding = const EdgeInsets.only(top: -1, left: 16);
    } else {
      shower.alignment = Alignment.centerLeft;
      shower.padding = const EdgeInsets.only(left: 16);
    }
    shower.transitionBuilder = ShowerTransitionBuilder.slideFromLeft;
    return shower;
  }

  static DialogShower showTop(Widget child, {double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, key: key);
    shower.alignment = Alignment.topCenter;
    shower.padding = const EdgeInsets.only(top: 16);
    shower.transitionBuilder = ShowerTransitionBuilder.slideFromTop;
    return shower;
  }

  static DialogShower showBottom(Widget child, {double? width, double? height, String? key}) {
    DialogShower shower = show(child, width: width, height: height, key: key);
    shower.alignment = Alignment.bottomCenter;
    shower.padding = const EdgeInsets.only(bottom: 16);
    shower.transitionBuilder = ShowerTransitionBuilder.slideFromBottom;
    return shower;
  }

  static DialogShower show(Widget child, {bool? fixed, double? x, double? y, double? width, double? height, String? key, _ReInit? init}) {
    DialogShower shower = DialogShower();
    if (fixed == true) {
      shower
        ..alignment = null
        ..padding = const EdgeInsets.only(left: -1, top: -1);
    }
    if (x != null && y != null) {
      shower
        ..alignment = fixed == true ? null : Alignment.topLeft
        ..padding = EdgeInsets.only(left: x, top: y);
    }
    shower = init?.call(shower) ?? shower;
    return showWith(shower, child, width: width, height: height, key: key);
  }

  static DialogShower showWith(DialogShower shower, Widget child, {double? width, double? height, String? key}) {
    Widget? widget = centralOfShower?.call(shower, child: child) ?? child;
    shower.show(widget, width: width, height: height);
    addToRepo(shower, key: key);
    /// sync delete
    shower.addDismissCallBack((d) {
      deleteInRepo(d);
    });
    /// make sure deleted in dispose
    shower.addDisposeCallBack((d) {
      deleteInRepo(d);
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

  // if you want to a new navigator then use [pushRoot], if you want to use current navigator then use [push]
  // Use DialogShower.future.then((result) => ...) to get result
  static DialogShower pushRoot(
    Widget widget, {
    RouteSettings? settings,
    bool? fixed,
    double? x,
    double? y,
    double? width,
    double? height,
    String? key,
  }) {
    return DialogWrapper.show(widget, fixed: fixed, x: x, y: y, width: width, height: height, key: key)
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
    assert(shower != null, 'You should ensure already have a navigator-shower popup, using pushRoot or isWrappedByNavigator = true.');
    return shower!.push(
      widget,
      duration: duration ?? const Duration(milliseconds: 200),
      reverseDuration: reverseDuration ?? const Duration(milliseconds: 200),
      transition: transition ?? ShowerTransitionBuilder.slideFromRight,
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
    getTopNavigatorDialog()?.pop<T>(result: result);
  }

  static void popOrDismiss<T>({T? result}) {
    DialogShower? dialog = DialogWrapper.getTopDialog();
    if (dialog?.isWrappedByNavigator ?? false) {
      if (getTopNavigatorDialog()?.getNavigator()?.canPop() ?? false) {
        pop<T>(result: result);
        return;
      }
    }
    DialogWrapper.dismissDialog(dialog, result: result);
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
    List<DialogShower> list = _list();
    for (int i = list.length - 1; i >= 0; i--) {
      if (handler(list.elementAt(i))) {
        break;
      }
    }
  }

  // shower management: add/remove/iterate in ordinal
  static void deleteInRepo(DialogShower? dialog) {
    _list().remove(dialog);
    _map().removeWhere((key, value) => value == dialog);
  }

  static void addToRepo(DialogShower dialog, {String? key}) {
    if (key != null) {
      _map()[key] = dialog;
    }
    _list().add(dialog);
  }

  // dismiss methods
  static Future<void> dismissAppearingDialogs() async {
    List<DialogShower> tmp = [..._list()];
    _list().clear();
    _map().clear();

    for (int i = tmp.length - 1; i >= 0; i--) {
      var dialog = tmp[i];
      await _dismiss(dialog);
    }
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

  static Future<void> dismissDialog<T extends Object?>(DialogShower? dialog, {String? key, T? result}) async {
    // dismiss from top to bottom if dialog in list
    Future<void> deleteWithDismiss(DialogShower dialog) async {
      List<DialogShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        DialogShower d = tmp.elementAt(i);
        deleteInRepo(d);
        await _dismiss<T>(d, result: result);
        if (d == dialog) {
          break;
        }
      }
    }

    if (dialog != null && (_list().contains(dialog))) {
      await deleteWithDismiss(dialog);
    }
    if (key != null && (dialog = _map()[key]) != null) {
      await deleteWithDismiss(dialog!);
    }
  }

  // important!!! do not use this method independently unless you take management of your own shower
  static Future<void> _dismiss<T extends Object?>(DialogShower? dialog, {T? result}) async {
    if (dialog != null) {
      await dialog.dismiss<T>(result);
    }
  }
}
