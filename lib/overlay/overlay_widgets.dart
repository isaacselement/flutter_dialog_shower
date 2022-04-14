import 'package:flutter/material.dart';

import "../dialog/dialog_shower.dart";
import 'overlay_shower.dart';
import 'overlay_wrapper.dart';

class OverlayWidgets {
  static OverlayShower showToast(
    String text, {
    TextStyle? textStyle,
    // text in padding
    EdgeInsets? padding,
    // container decoration;
    Decoration? decoration,
    Color? backgroundColor,
    BorderRadius? radius,
    BoxShadow? shadow,
    // animation
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
  }) {
    return showOpacity(
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: decoration ??
            BoxDecoration(
              color: backgroundColor ?? Colors.black,
              borderRadius: radius ?? const BorderRadius.all(Radius.circular(6)),
              boxShadow: [shadow ?? const BoxShadow(color: Colors.grey, blurRadius: 25.0 /*, offset: Offset(4.0, 4.0)*/)],
            ),
        child: Material(
          type: MaterialType.transparency,
          // elevation: 1.0,
          // borderOnForeground: false,
          // color: Colors.black,
          // shadowColor: Colors.black,
          // clipBehavior: Clip.antiAlias,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  static OverlayShower showOpacity({
    required Widget child,
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    bool? isRecycleWhenShowed,
  }) {
    return showWithAnimation(animationBuilder: (shower, vsync) {
      AnimationController controller = AnimationController(
        vsync: vsync,
        duration: appearDuraion ?? const Duration(milliseconds: 500),
        reverseDuration: dismissDuraion ?? const Duration(milliseconds: 500),
      );
      Animation animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Interval(0.0, 1.0, curve: (curves ?? Curves.linearToEaseOut) as Curve), parent: controller),
      );
      controller.addListener(() {
        shower.setState(() {}); // will rebuild with builder belowed
      });

      TickerFuture forwardFuture = controller.forward();
      if (isRecycleWhenShowed ?? false) {
        forwardFuture.then((value) {
          controller.dispose();
        });
      } else {
        if (onScreenDuration == Duration.zero) {
          // if onScreenDuration == Duration.zero, put the controller to caller
          shower.obj = controller;
        } else {
          // default dimiss in 2 seconds
          Future.delayed(onScreenDuration ?? const Duration(milliseconds: 2000), () {
            controller.reverse().then((value) {
              controller.dispose();
              shower.dismiss();
            });
          });
        }
      }

      shower.builder = (shower) {
        return Opacity(opacity: animation.value, child: child);
      };

      // Animation animation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0)).animate(controller);

    });
  }

  static OverlayShower showWithAnimation({
    required void Function(OverlayShower shower, TickerProviderStateMixin vsync) animationBuilder,
  }) {
    OverlayShower shower = OverlayWrapper.showTop(const Offstage(offstage: true));
    shower.isWithTicker = true;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      StatefulBuilderExState tickerState = shower.statefulKey.currentState as StatefulBuilderExState;
      animationBuilder(shower, tickerState);
    });
    return shower;
  }

  /*
   * Toast in Queue
   */
  static List<OverlayShower?> toastQueue = [];

  static OverlayShower showToastInQueue(
    String text, {
    TextStyle? textStyle,
    // text in padding
    EdgeInsets? padding,
    // container decoration;
    Decoration? decoration,
    Color? backgroundColor,
    BorderRadius? radius,
    BoxShadow? shadow,
    // animation
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    // queue increment offset
    required EdgeInsets increaseOffset,
  }) {
    OverlayShower shower = showToast(
      text,
      textStyle: textStyle,
      padding: padding,
      decoration: decoration,
      backgroundColor: backgroundColor,
      radius: radius,
      shadow: shadow,
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
    );

    int index = -1;
    for (int i = 0; i < toastQueue.length; i++) {
      OverlayShower? obj = toastQueue[i];
      if (obj == null) {
        index = i;
        toastQueue[i] = shower;
        break;
      }
    }

    if (index == -1) {
      index = toastQueue.length;
      toastQueue.add(shower);
    }

    Future.microtask(() {
      EdgeInsets n = increaseOffset;
      EdgeInsets? m = shower.margin;
      shower.margin = EdgeInsets.only(
        left: n.left * index + (m?.left ?? 0),
        top: n.top * index + (m?.top ?? 0),
        right: n.right * index + (m?.right ?? 0),
        bottom: n.bottom * index + (m?.bottom ?? 0),
      );
    });

    shower.addDismissCallBack((shower) {
      var index = toastQueue.indexOf(shower);
      if (index != -1) {
        toastQueue[index] = null;
      }
      // if all null
      bool isNullALL = true;
      for (OverlayShower? s in toastQueue) {
        if (s != null) {
          isNullALL = false;
          break;
        }
      }
      if (isNullALL) {
        toastQueue.clear();
      }
    });

    return shower;
  }
}
