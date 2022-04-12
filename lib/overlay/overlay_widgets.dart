import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? duration,
    Curves? curves,
  }) {
    return showOpacity(
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      duration: duration,
      curves: curves,
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
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? duration,
    Curves? curves,
  }) {
    OverlayShower shower = OverlayWrapper.showTop(const Offstage(offstage: true));
    shower.isWithTicker = true;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      AnimationController animationController = AnimationController(
        vsync: shower.statefulKey.currentState as StatefulBuilderExState,
        duration: appearDuraion ?? const Duration(milliseconds: 500),
        reverseDuration: dismissDuraion ?? const Duration(milliseconds: 500),
      );
      Animation animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Interval(0.0, 1.0, curve: (curves ?? Curves.linearToEaseOut) as Curve), parent: animationController),
      );
      animationController.addListener(() {
        shower.setState(() {}); // will rebuild with builder belowed
      });
      animationController.forward();

      Future.delayed(duration ?? const Duration(milliseconds: 2000), () {
        animationController.reverse().then((value) {
          animationController.dispose();
          shower.dismiss();
        });
      });

      shower.builder = (shower) {
        return Opacity(opacity: animation.value, child: child);
      };
    });

    return shower;
  }

}
