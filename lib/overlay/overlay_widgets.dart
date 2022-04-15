import 'package:flutter/material.dart';
import 'dart:math' as math;

import "../dialog/dialog_shower.dart";
import 'overlay_shower.dart';
import 'overlay_wrapper.dart';

class OverlayWidgets {
  /// Toast in Queue
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
    // animation settings
    Offset? slideBegin,
    double? opacityBegin,
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
      slideBegin: slideBegin,
      opacityBegin: opacityBegin,
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

  /// Toast
  static OverlayShower showToast(
    String text, {
    TextStyle? textStyle,
    // text in padding
    EdgeInsets? padding,
    // container decoration
    Decoration? decoration,
    Color? backgroundColor,
    BorderRadius? radius,
    BoxShadow? shadow,
    // animation
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration, // if == Duration.zero, please dimiss manually ~~~
    // animation settings
    Offset? slideBegin,
    double? opacityBegin,
  }) {
    return show(
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
      slideBegin: slideBegin,
      opacityBegin: opacityBegin,
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

  /// Basic
  static OverlayShower show({
    required Widget child,
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    // animation settings: only support slide & opacity now // default is opcity animation
    Offset? slideBegin,
    double? opacityBegin,
  }) {
    opacityBegin = opacityBegin == null && slideBegin == null ? 0.0 : opacityBegin;
    return showWithAnimation(
      child: child,
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
      appearAnimatedBuilder: (shower, controller) {
        Curve curve = Interval(0.0, 1.0, curve: (curves ?? Curves.linearToEaseOut) as Curve);
        Animation<double> animateCurve = CurvedAnimation(curve: curve, parent: controller);
        Animation<double>? opacity = opacityBegin == null ? null : Tween(begin: opacityBegin, end: 1.0).animate(animateCurve);
        // Animation<Offset> slide = Tween<Offset>(begin: slideBegin, end:  Offset.zero).animate(controller);
        Animation<Offset>? slide = slideBegin == null ? null : Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(animateCurve);

        // 1. Using AnimatedWidget
        // Widget widgetSlide = SlideTransition(position: slide, child: child);
        Widget? widgetSlide;
        if (slide != null) {
          widgetSlide = AnimatedBuilder(
            animation: slide,
            builder: (context, child) => Transform.translate(offset: slide.value, child: child),
            child: child,
          );
        }

        // 2. Using [__property__]Transition
        Widget? widgetFade;
        if (opacity != null) {
          widgetFade = FadeTransition(opacity: opacity, child: widgetSlide ?? child);
        }

        return widgetFade ?? widgetSlide ?? child;
      },
    );
  }

  static OverlayShower showWithAnimation({
    required Widget child,
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    required Widget Function(OverlayShower shower, AnimationController controller) appearAnimatedBuilder,
    // Widget Function(OverlayShower shower, AnimationController controller)? dimissAnimatedBuilder,
  }) {
    const Duration defDuration = Duration(milliseconds: 500);
    return showWithTicker(tickerBuilder: (shower, vsync) {
      AnimationController controller = AnimationController(
        vsync: vsync,
        duration: appearDuraion ?? defDuration,
        reverseDuration: dismissDuraion ?? defDuration,
      );

      controller.forward();
      if (onScreenDuration == Duration.zero) {
        // if onScreenDuration == Duration.zero, put the controller to caller
        shower.obj = controller;
      } else {
        // default dimiss in 2 seconds
        Future.delayed(onScreenDuration ?? const Duration(milliseconds: 2000), () {
          controller.reverse().then((value) {
            shower.dismiss();
          });

          // AnimationController dimissController = AnimationController(
          //   vsync: vsync,
          //   duration: dismissDuraion ?? defDuration,
          // );

        });
      }
      shower.addDismissCallBack((shower) {
        controller.dispose();
      });

      // 1. Using Opacity & Shower's builder
      // controller.addListener(() {
      //   shower.setState(() {});
      // });
      // shower.builder = (shower) {
      //   return Opacity(opacity: opacityAnimation.value, child: child);
      // };

      // 2. Using animation widget
      shower.setNewChild(appearAnimatedBuilder(shower, controller));
    });
  }

  static OverlayShower showWithTicker({
    required void Function(OverlayShower shower, TickerProviderStateMixin vsync) tickerBuilder,
  }) {
    OverlayShower shower = OverlayWrapper.showTop(const Offstage(offstage: true));
    shower.isWithTicker = true;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      StatefulBuilderExState tickerState = shower.statefulKey.currentState as StatefulBuilderExState;
      tickerBuilder(shower, tickerState);
    });
    return shower;
  }
}
