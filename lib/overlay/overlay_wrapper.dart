import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'overlay_shower.dart';

class OverlayWrapper {
  static OverlayShower showTop(Widget child, {String? key}) {
    OverlayShower shower = show(child, key: key);
    shower.alignment = Alignment.topCenter;
    shower.padding = const EdgeInsets.only(top: 64);
    return shower;
  }

  static OverlayShower showBottom(Widget child, {String? key}) {
    OverlayShower shower = show(child, key: key);
    shower.alignment = Alignment.bottomCenter;
    shower.padding = const EdgeInsets.only(bottom: 64);
    return shower;
  }

  static OverlayShower show(Widget child, {double? dx, double? dy, String? key}) {
    return showWith(OverlayShower(), child, dx: dx, dy: dy, key: key);
  }

  static OverlayShower showWith(OverlayShower shower, Widget? child, {double? dx, double? dy, String? key}) {
    shower.alignment = Alignment.center;
    if (dx != null && dy != null) {
      shower.dx = dx;
      shower.dy = dy;
      shower.alignment = Alignment.topLeft;
    }

    centralOfShower?.call(shower);

    shower.show(child);
    add(shower, key: key);
    shower.addDismissCallBack((d) {
      remove(d);
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

  static OverlayShower? getTopLayer() {
    return _list().isNotEmpty ? _list().last : null;
  }

  static OverlayShower? getLayerByIndex(int reverseIndex) {
    int index = (_list().length - 1) - reverseIndex; // reverse index
    return index >= 0 && index < _list().length ? _list()[index] : null;
  }

  static OverlayShower? getLayerByKey(String key) {
    return _map()[key];
  }

  static void iterateLayers(bool Function(OverlayShower shower) handler) {
    List<OverlayShower> tmp = [..._list()];
    for (int i = tmp.length - 1; i >= 0; i--) {
      if (handler(tmp.elementAt(i))) {
        break;
      }
    }
  }

  static Future<void> dismissAppearingLayers() async {
    List<OverlayShower> tmp = [..._list()];
    _list().clear();
    for (int i = tmp.length - 1; i >= 0; i--) {
      var shower = tmp[i];
      await _dismiss(shower);
    }

    // Map<String, OverlayShower> map = {}..addAll(_map());
    _map().clear(); // just clear, cause _addLayer entry method: _map element already in _list
    // map.forEach((key, shower) async {
    //   await _dismiss(shower);
    // });
  }

  static Future<void> dismissTopLayer({int? count}) async {
    if (count != null && count > 0) {
      for (int i = 0; i < count; i++) {
        await dismissLayer(_list().isNotEmpty ? _list().last : null);
      }
      return;
    }
    await dismissLayer(_list().isNotEmpty ? _list().last : null);
  }

  static Future<void> dismissLayer(OverlayShower? shower, {String? key}) async {
    // remove & dismiss from top to bottom
    if (shower != null) {
      List<OverlayShower> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        OverlayShower d = tmp.elementAt(i);
        remove(d);
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
        remove(d);
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
  static void remove(OverlayShower? shower) {
    _list().remove(shower);
    _map().removeWhere((key, value) => value == shower);
  }

  static void add(OverlayShower shower, {String? key}) {
    if (key != null) {
      _map()[key] = shower;
    }
    _list().add(shower);
  }
}
