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

  static AnimationController? createAnimationController(DialogShower shower, {Duration? duration}) {
    assert(shower.isWithTicker, 'Your shower should assign isWithTicker property to true');
    if (!shower.isWithTicker) {
      return null;
    }
    if (shower.isPopped) {
      return null;
    }
    dynamic state = shower.statefulKey.currentState;
    if (state is! BuilderWithTickerState) {
      return null;
    }
    AnimationController controller = AnimationController(vsync: state, duration: duration ?? const Duration(milliseconds: 500));
    shower.isAutoSizeForNavigator = false;
    shower.addDisposeCallBack(
      (shower) {
        controller.dispose();
      },
    );
    return controller;
  }

  static AnimationController? transformWidth({
    required DialogShower shower,
    double? begin,
    double? end,
    Duration? duration,
    void Function()? onFinish,
    void Function(double value)? onDuring,
  }) {
    AnimationController? controller = createAnimationController(shower);
    if (controller == null) {
      return null;
    }
    Animation<double> animation = Tween<double>(begin: begin, end: end).chain(CurveTween(curve: Curves.ease)).animate(controller);
    animation.addListener(() {
      shower.width = animation.value;
      onDuring?.call(animation.value);
      shower.setState();
    });
    controller.forward().then((value) {
      onFinish?.call();
    });
    return controller;
  }
}
