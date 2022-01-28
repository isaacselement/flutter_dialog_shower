import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'dialog_shower.dart';

class DialogWrapper {
  static double? defaultWidth = null;
  static double? defaultHeight = null;

  // same as just show ...
  static DialogShower showCenter({required Widget child, required double width, required double height}) {
    ui.SingletonFlutterWindow _window = WidgetsBinding.instance?.window ?? ui.window;
    MediaQueryData query = MediaQueryData.fromWindow(_window);
    double qWidth = query.size.width;
    double qHeight = query.size.height;
    double x = qWidth / 2 - width / 2;
    double y = qHeight / 2 - height / 2;
    return showDefault(child, x: x, y: y, width: width, height: height);
  }

  static DialogShower showRight(Widget child, {double? width, double? height, String? key}) {
    return showDefault(child, width: width, height: height, direction: TextDirection.rtl);
  }

  static DialogShower showLeft(Widget child, {double? width, double? height, String? key}) {
    return showDefault(child, width: width, height: height, direction: TextDirection.ltr);
  }

  static DialogShower showDefault(Widget child,
      {double? x, double? y, double? width, double? height, TextDirection? direction, String? key}) {
    width = width ?? defaultWidth;
    height = height ?? defaultHeight;
    return showWith(DialogShower(), child, x: x, y: y, width: width, height: height);
  }

  static DialogShower show(Widget child,
      {bool isFixed = false, double? x, double? y, double? width, double? height, TextDirection? direction, String? key}) {
    return showWith(DialogShower(), child, isFixed: isFixed, x: x, y: y, width: width, height: height);
  }

  static DialogShower showWith(DialogShower shower, Widget child,
      {bool isFixed = false, double? x, double? y, double? width, double? height, String? key}) {
    shower
      ..build()
      ..barrierDismissible = true
      ..containerShadowColor = Colors.grey
      ..containerBorderRadius = 10.0
      ..containerShadowBlurRadius = 20.0;
    if (isFixed) {
      shower
        ..alignment = null
        ..margin = const EdgeInsets.only(left: -1, top: -1)
      ;
    }
    if (x != null && y != null) {
      shower
        ..alignment = isFixed ? null : Alignment.topLeft
        ..margin = EdgeInsets.only(left: x, top: y)
      ;
    }

    shower.show(child, width: width, height: height);
    _addDialog(shower, key: key);
    shower.addDismissCallBack((d) {
      _remove(d);
    });
    return shower;
  }

  // appearing dialogs management
  static List<DialogShower>? appearingDialogs;

  static Map<String, DialogShower>? appearingDialogsMappings;

  static List<DialogShower> _list() {
    return (appearingDialogs = appearingDialogs ?? []);
  }

  /// TODO ... insert a prefix into key for ordinal, then pop until ...
  static Map<String, DialogShower> _map() {
    return (appearingDialogsMappings = appearingDialogsMappings ?? {});
  }

  static DialogShower? getTopDialog() {
    return _list().isNotEmpty ? _list().last : null;
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

    /// TODO ... not in top to bottom ordinal now ...
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
