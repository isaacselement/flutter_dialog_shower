import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

import 'overlay_shower.dart';
import 'overlay_wrapper.dart';

class OverlayWidgets {
  /// Toast in Queue
  static Map<String, List<OverlayShower?>> sharedToastQueue = {};

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
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
    // queue increment offset
    EdgeInsets increaseOffset = const EdgeInsets.only(top: 45),
    // List? queue,
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
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
    );
    // Use micro, for the caller will modified properties(i.e margin, aligment) outside
    // The appear animation controller will setState, don't worry
    Future.microtask(() {
      String key = shower.alignment?.toString() ?? '__Shared_Key__';
      List<OverlayShower?> queue = (sharedToastQueue[key] ?? (sharedToastQueue[key] = []));

      // 1. get the empty index
      int index = -1;
      for (int i = 0; i < queue.length; i++) {
        OverlayShower? obj = queue[i];
        if (obj == null) {
          index = i;
          queue[i] = shower;
          break;
        }
      }
      if (index == -1) {
        index = queue.length;
        queue.add(shower);
      }

      // 2. caculate the position
      EdgeInsets n = increaseOffset;
      EdgeInsets? m = shower.margin;
      shower.margin = EdgeInsets.only(
        left: n.left * index + (m?.left ?? 0),
        top: n.top * index + (m?.top ?? 0),
        right: n.right * index + (m?.right ?? 0),
        bottom: n.bottom * index + (m?.bottom ?? 0),
      );

      // 3. clear the queue when dismissed
      shower.addDismissCallBack((shower) {
        var index = queue.indexOf(shower);
        if (index != -1) {
          queue[index] = null;
        }
        // if all null
        bool isNullALL = true;
        for (OverlayShower? s in queue) {
          if (s != null) {
            isNullALL = false;
            break;
          }
        }
        if (isNullALL) {
          queue.clear();
        }
      });
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
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    return show(
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
      slideBegin: slideBegin,
      opacityBegin: opacityBegin,
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: decoration ??
            BoxDecoration(
              color: backgroundColor ?? Colors.black,
              borderRadius: radius ?? const BorderRadius.all(Radius.circular(6)),
              boxShadow: [shadow ?? const BoxShadow(color: Colors.grey, blurRadius: 25.0 /*, offset: Offset(4.0, 4.0)*/)],
            ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  /// Basic show with animation
  static OverlayShower show({
    required Widget child,
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    // animation settings: only support slide & opacity now // default is opcity animation
    Offset? slideBegin,
    double? opacityBegin,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    opacityBegin ??= (slideBegin == null ? 0.0 : opacityBegin);
    appearAnimatedBuilder ??= (shower, controller, widget) {
      Curve curve = Interval(0.0, 1.0, curve: (curves ?? Curves.linearToEaseOut) as Curve);
      Animation<double> animateCurve = CurvedAnimation(curve: curve, parent: controller);
      Animation<double>? opacity = opacityBegin == null ? null : Tween(begin: opacityBegin, end: 1.0).animate(animateCurve);
      Animation<Offset>? slide = slideBegin == null ? null : Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(animateCurve);
      // Animation<Offset> slide = Tween<Offset>(begin: slideBegin, end:  Offset.zero).animate(controller);

      // 1. Using AnimatedWidget
      Widget? widgetSlide;
      if (slide != null) {
        widgetSlide = AnimatedBuilder(
          animation: slide,
          builder: (context, child) => Transform.translate(offset: slide.value, child: widget),
          child: widget,
        );
      }

      // 2. Using [__property__]Transition
      // Widget widgetSlide = SlideTransition(position: slide, child: widget);
      Widget? widgetFade;
      if (opacity != null) {
        widgetFade = FadeTransition(opacity: opacity, child: widgetSlide ?? widget);
      }

      return widgetFade ?? widgetSlide ?? widget;
    };

    return showWithAnimation(
      child: child,
      curves: curves,
      appearDuraion: appearDuraion,
      dismissDuraion: dismissDuraion,
      onScreenDuration: onScreenDuration,
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
    );
  }

  static OverlayShower showWithAnimation({
    required Widget child,
    Curves? curves,
    Duration? appearDuraion,
    Duration? dismissDuraion,
    Duration? onScreenDuration,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    const Duration defDuration = Duration(milliseconds: 500);
    return showWithTicker(tickerBuilder: (shower, vsync) {
      AnimationController appearController = AnimationController(
        vsync: vsync,
        duration: appearDuraion ?? defDuration,
        reverseDuration: dismissDuraion ?? defDuration,
      );

      appearController.forward();
      if (onScreenDuration == Duration.zero) {
        // if onScreenDuration == Duration.zero, put the controller to caller
        shower.obj = appearController;
      } else {
        // default dimiss in 2 seconds
        Future.delayed(onScreenDuration ?? const Duration(milliseconds: 2000), () {
          if (dismissAnimatedBuilder != null) {
            AnimationController dimissController = AnimationController(vsync: vsync, duration: dismissDuraion ?? defDuration);
            shower.setNewChild(dismissAnimatedBuilder(shower, dimissController, child));
            dimissController.forward().then((value) {
              shower.dismiss();
            });
          } else {
            if (shower.isShowing) {
              appearController.reverse().then((value) {
                shower.dismiss();
              });
            }
          }
        });
      }
      shower.addDismissCallBack((shower) {
        appearController.dispose();
      });

      if (appearAnimatedBuilder == null) {
        // 1. Using Opacity & Shower's builder default
        appearController.addListener(() {
          shower.setState(() {});
        });
        Animation<double> opacity = Tween(begin: 0.0, end: 1.0).animate(appearController);
        shower.builder = (shower) {
          return Opacity(opacity: opacity.value, child: child);
        };
      } else {
        // 2. Using animation widget
        shower.setNewChild(appearAnimatedBuilder(shower, appearController, child));
      }
    });
  }

  static OverlayShower showWithTicker({
    required void Function(OverlayShower shower, TickerProviderStateMixin vsync) tickerBuilder,
  }) {
    OverlayShower shower = OverlayWrapper.show(const Offstage(offstage: true));
    shower.isWithTicker = true;
    Boxes.getWidgetsBinding().addPostFrameCallback((timeStamp) {
      Future.microtask(() { // microtask is  redundant if set shower.isSyncShow = true
        State? state = shower.statefulKey.currentState;
        if (state is BuilderWithTickerState) { // type and not-null check!!!
          tickerBuilder(shower, state);
        }
      });
    });
    return shower;
  }

  /// Show with LayerLinker
  static OverlayShower showWithLayerLink({
    required Widget child,
    required double width,
    required LayerLink layerLink,
    bool? showWhenUnlinked,
    Offset? offset,
    bool isWrappedMaterial = true,
  }) {
    return OverlayWrapper.show(
      Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: layerLink,
          offset: offset ?? Offset.zero,
          showWhenUnlinked: showWhenUnlinked ?? false,
          child: isWrappedMaterial ? Material(child: child, type: MaterialType.transparency) : child,
        ),
      ),
    )..isWrappedNothing = true;
  }
}
