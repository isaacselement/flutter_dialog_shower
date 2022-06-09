import 'package:example/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class InsetsUtil {
  static void rebuildShowerPositionTopOnKeyboardEvent(DialogShower shower, bool isKeyboardShow, {double? top}) {
    Logger.console(() => '[PositionUtil] -> rebuildShowerPositionTopOnKeyboardEvent $isKeyboardShow');
    shower.obj = shower.obj is List ? shower.obj : [shower.alignment, shower.padding];
    Alignment? aliOld = (shower.obj as List)[0];
    Alignment aliNew = Alignment(aliOld?.x ?? 0.0, -1.0); // Alignment topCenter = Alignment(0.0, -1.0);
    EdgeInsets? insOld = (shower.obj as List)[1];
    EdgeInsets insNew = EdgeInsets.only(
      left: insOld?.left ?? 0,
      right: insOld?.right ?? 0,
      bottom: insOld?.bottom ?? 0,
      top: top ?? MediaQuery.of(DialogShower.gContext!).padding.top,
    );
    shower.setState(() {
      shower.alignment = isKeyboardShow ? aliNew : aliOld;
      shower.padding = isKeyboardShow ? insNew : insOld;
    });
  }

  static void rebuildShowerPositionBottomOnKeyboardEvent(DialogShower shower, bool isKeyboardShow, {double? bottom, double? top}) {
    Logger.console(() => '[PositionUtil] -> rebuildShowerPositionBottomOnKeyboardEvent $isKeyboardShow');
    shower.obj = shower.obj is List ? shower.obj : [shower.alignment, shower.padding];
    Alignment? aliOld = (shower.obj as List)[0];
    Alignment aliNew = Alignment(aliOld?.x ?? 0.0, 1.0); // Alignment bottomCenter = Alignment(0.0, 1.0);
    EdgeInsets? insOld = (shower.obj as List)[1];
    EdgeInsets insNew = EdgeInsets.only(
      left: insOld?.left ?? 0,
      right: insOld?.right ?? 0,
      bottom: bottom ?? 20,
      top: top ?? MediaQuery.of(DialogShower.gContext!).padding.top,
    );
    shower.setState(() {
      shower.alignment = isKeyboardShow ? aliNew : aliOld;
      shower.padding = isKeyboardShow ? insNew : insOld;
    });
  }
}
