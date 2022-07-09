import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class ShowerHelper {
  static void stopwatchTimer({int millis = 1000, required int count, required bool Function(int index) tik}) async {
    int index = 0;
    while (count-- > 0) {
      await Future.delayed(Duration(milliseconds: millis), () {
        if (tik(index++)) count = 0;
      });
    }
  }

  static AnimationController createAnimationController(DialogShower shower, {int duration = 500}) {
    assert(shower.isWithTicker, 'Your shower should assign isWithTicker property to true');
    AnimationController controller = AnimationController(
      vsync: shower.statefulKey.currentState! as BuilderWithTickerState,
      duration: Duration(milliseconds: duration),
    );
    shower.isAutoSizeForNavigator = false;
    shower.isSyncInvokeDismissCallback = true;
    shower.addDismissCallBack(
      (shower) {
        controller.dispose();
      },
    );
    return controller;
  }

  static AnimationController? expandWidth({required DialogShower shower, double? begin, double? end, void Function()? callback}) {
    if (!shower.isWithTicker) {
      return null;
    }
    AnimationController controller = createAnimationController(shower);
    Animation<double> animation = Tween<double>(begin: begin, end: end).chain(CurveTween(curve: Curves.ease)).animate(controller);
    animation.addListener(() {
      shower.width = animation.value;
      shower.setState();
    });
    controller.forward().then((value) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        callback?.call();
      });
    });
    return controller;
  }
}
