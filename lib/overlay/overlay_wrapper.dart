import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'overlay_shower.dart';

class OverlayWrapper {
  static OverlayShower showTop(Widget child, {double? width, double? height, String? key}) {
    OverlayShower shower = show(child, width: width, height: height, direction: const Offset(0.0, 1.0), key: key);
    shower.alignment = Alignment.topCenter;
    shower.padding = const EdgeInsets.only(top: 50);
    return shower;
  }

  static OverlayShower showBottom(Widget child, {double? width, double? height, String? key}) {
    OverlayShower shower = show(child, width: width, height: height, direction: const Offset(0.0, 1.0), key: key);
    shower.alignment = Alignment.bottomCenter;
    shower.padding = const EdgeInsets.only(bottom: 50);
    return shower;
  }

  static OverlayShower show(Widget child,
      {bool isFixed = false, double? x, double? y, double? width, double? height, Offset? direction, String? key}) {
    return showWith(OverlayShower(), child, x: x, y: y, key: key);
  }

  static OverlayShower showWith(OverlayShower shower, Widget child, {double? x, double? y, String? key}) {
    shower.alignment = Alignment.center;
    if (x != null && y != null) {
      shower
        ..alignment = Alignment.topLeft
        ..padding = EdgeInsets.only(left: x, top: y);
    }

    centralOfShower?.call(shower);

    shower.show(child);
    _addDialog(shower, key: key);
    shower.addDismissCallBack((d) {
      _remove(d);
    });
    return shower;
  }

  // control center for shower that showed by this wrapper
  static Function(OverlayShower shower)? centralOfShower;

  /// Appearing overlays management
  static List<OverlayShower>? appearingShowers;

  static Map<String, OverlayShower>? appearingShowersMappings;

  static List<OverlayShower> _list() {
    return (appearingShowers = appearingShowers ?? []);
  }

  static Map<String, OverlayShower> _map() {
    return (appearingShowersMappings = appearingShowersMappings ?? {});
  }

  static OverlayShower? getTopDialog() {
    return _list().isNotEmpty ? _list().last : null;
  }

  static OverlayShower? getDialogByIndex(int reverseIndex) {
    int index = (_list().length - 1) - reverseIndex; // reverse index
    return index >= 0 && index < _list().length ? _list()[index] : null;
  }

  static OverlayShower? getDialogByKey(String key) {
    return _map()[key];
  }

  static void iterateDialogs(bool Function(OverlayShower shower) handler) {
    List<OverlayShower> tmp = [..._list()];
    for (int i = tmp.length - 1; i >= 0; i--) {
      if (handler(tmp.elementAt(i))) {
        break;
      }
    }
  }

  static Future<void> dismissAppearingDialogs() async {
    List<OverlayShower> tmp = [..._list()];
    _list().clear();
    for (int i = tmp.length - 1; i >= 0; i--) {
      var shower = tmp[i];
      await _dismiss(shower);
    }

    // Map<String, OverlayShower> map = {}..addAll(_map());
    _map().clear(); // just clear, cause _addDialog entry method: _map element already in _list
    // map.forEach((key, shower) async {
    //   await _dismiss(shower);
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

  static Future<void> dismissDialog(OverlayShower? shower, {String? key}) async {
    // remove & dismiss from top to bottom
    if (shower != null) {
      List<OverlayShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        OverlayShower d = tmp.elementAt(i);
        _remove(d);
        await _dismiss(d);
        if (d == shower) {
          break;
        }
      }
    }
    if (key != null && (shower = _map()[key]) != null) {
      List<OverlayShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        OverlayShower d = tmp.elementAt(i);
        _remove(d);
        await _dismiss(d);
        if (d == shower) {
          break;
        }
      }
    }
  }

  // important!!! do not use this method unless you take management of your own shower
  static Future<void> _dismiss(OverlayShower? shower) async {
    if (shower != null) {
      await shower.dismiss();
    }
  }

  // shower management: add/remove/iterate in ordinal
  static void _remove(OverlayShower? shower) {
    _list().remove(shower);
    _map().removeWhere((key, value) => value == shower);
  }

  static void _addDialog(OverlayShower shower, {String? key}) {
    if (key != null) {
      _map()[key] = shower;
    }
    _list().add(shower);
  }
}
