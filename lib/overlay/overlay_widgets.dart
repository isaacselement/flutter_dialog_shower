import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

import 'overlay_shower.dart';
import 'overlay_wrapper.dart';

class OverlayWidgets {
  /// Toast in Queue
  static Map<String, List<OverlayShower?>> sharedToastQueue = {};

  static OverlayShower showToastInQueue(
    String text, {
    String? key,
    TextStyle? textStyle,
    // text in padding
    EdgeInsets? padding,
    // container decoration;
    Decoration? decoration,
    Color? backgroundColor,
    BorderRadius? radius,
    BoxShadow? shadow,
    // animation
    Curve? curve,
    Duration? appearDuration,
    Duration? dismissDuration,
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
      key: key,
      textStyle: textStyle,
      padding: padding,
      decoration: decoration,
      backgroundColor: backgroundColor,
      radius: radius,
      shadow: shadow,
      curve: curve,
      appearDuration: appearDuration,
      dismissDuration: dismissDuration,
      onScreenDuration: onScreenDuration,
      slideBegin: slideBegin,
      opacityBegin: opacityBegin,
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
    );
    // Use micro, for the caller will modified properties(i.e margin, alignment) outside
    // The appear animation controller will setState, don't worry
    Future.microtask(() {
      String keyInQueue = shower.alignment?.toString() ?? '__Shared_Key__';
      List<OverlayShower?> queue = (sharedToastQueue[keyInQueue] ?? (sharedToastQueue[keyInQueue] = []));

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

      // 2. calculate the position
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
    String? key,
    bool isStateful = false,
    // widget properties
    BoxShadow? shadow,
    EdgeInsets? padding,
    TextStyle? textStyle,
    BorderRadius? radius,
    Decoration? decoration,
    Color? backgroundColor,
    void Function(Widget widget)? onWidgetBuild,
    // animation properties
    Curve? curve,
    Duration? appearDuration,
    Duration? dismissDuration,
    Duration? onScreenDuration, // if set to Duration.zero, should dismiss manually
    // animation settings
    Offset? slideBegin,
    double? opacityBegin,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    Widget widget = isStateful ? AnyToastWidget(text: text) : AnyToastView(text: text);
    (widget as AnyToastWidgetProperties)
      ..radius = radius
      ..shadow = shadow
      ..padding = padding
      ..textStyle = textStyle
      ..decoration = decoration
      ..backgroundColor = backgroundColor;
    onWidgetBuild?.call(widget);
    return show(
      key: key,
      child: widget,
      curve: curve,
      appearDuration: appearDuration,
      dismissDuration: dismissDuration,
      onScreenDuration: onScreenDuration,
      slideBegin: slideBegin,
      opacityBegin: opacityBegin,
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
    );
  }

  /// Basic show with animation
  static OverlayShower show({
    required Widget child,
    String? key,
    Curve? curve,
    Duration? appearDuration,
    Duration? dismissDuration,
    Duration? onScreenDuration,
    // animation settings: only support slide & opacity now // default is opacity animation
    Offset? slideBegin,
    double? opacityBegin,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    opacityBegin ??= (slideBegin == null ? 0.0 : opacityBegin);
    appearAnimatedBuilder ??= (shower, controller, widget) {
      Curve _curve = Interval(0.0, 1.0, curve: curve ?? Curves.linearToEaseOut);
      Animation<double> animateCurve = CurvedAnimation(curve: _curve, parent: controller);
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
      key: key,
      child: child,
      appearDuration: appearDuration,
      dismissDuration: dismissDuration,
      onScreenDuration: onScreenDuration,
      appearAnimatedBuilder: appearAnimatedBuilder,
      dismissAnimatedBuilder: dismissAnimatedBuilder,
    );
  }

  static OverlayShower showWithAnimation({
    required Widget child,
    String? key,
    Duration? appearDuration,
    Duration? dismissDuration,
    Duration? onScreenDuration,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? appearAnimatedBuilder,
    Widget Function(OverlayShower shower, AnimationController controller, Widget widget)? dismissAnimatedBuilder,
  }) {
    const Duration defaultDuration = Duration(milliseconds: 500);
    return showWithTickerVsyncBuilder(
        key: key,
        tickerBuilder: (shower, vsync) {
          AnimationController appearController = AnimationController(
            vsync: vsync,
            duration: appearDuration ?? defaultDuration,
            reverseDuration: dismissDuration ?? defaultDuration,
          );

          void dismiss() {
            if (dismissAnimatedBuilder != null) {
              AnimationController dismissController = AnimationController(vsync: vsync, duration: dismissDuration ?? defaultDuration);
              shower.setNewChild(dismissAnimatedBuilder(shower, dismissController, child));
              dismissController.forward().then((value) {
                shower.dismiss();
              });
            } else {
              if (shower.isShowing) {
                appearController.reverse().then((value) {
                  shower.dismiss();
                });
              }
            }
          }

          if (onScreenDuration == Duration.zero) {
            // put the controller to caller, if onScreenDuration == Duration.zero
            shower.obj = [appearController, dismiss];
          } else {
            // default dismiss in 3 seconds
            Duration duration = onScreenDuration ?? const Duration(milliseconds: 3000);
            Timer dismissTimer = Timer(duration, () {
              dismiss();
            });
            // put the timer to caller, if onScreenDuration != Duration.zero
            shower.obj = [dismissTimer, dismiss];
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

          // start the show animation
          appearController.forward();
        });
  }

  static OverlayShower showWithTickerVsyncBuilder({
    String? key,
    required void Function(OverlayShower shower, TickerProviderStateMixin vsync) tickerBuilder,
  }) {
    // Tricky: show a Offstage first, then we got the vsync state :)
    OverlayShower shower = OverlayWrapper.show(const Offstage(offstage: true), key: key);
    shower.isWithTicker = true;
    shower.addShowCallBack((shower) {
      State? state = shower.statefulKey.currentState;
      if (state is BuilderWithTickerState) {
        // type and not-null checked
        tickerBuilder(shower, state);
      }
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

/// Widgets

mixin AnyToastWidgetProperties {
  double? width;
  double? height;

  // text
  late String text;
  TextStyle? textStyle;

  // text in padding
  EdgeInsets? padding;

  // container decoration
  BoxShadow? shadow;
  BorderRadius? radius;
  Color? backgroundColor;
  Decoration? decoration;
  Clip clipBehavior = Clip.antiAlias;
  Widget? Function(AnyToastWidgetProperties widget)? builder;

  Widget createToastWidget() {
    decoration ??= BoxDecoration(
      color: backgroundColor ?? Colors.black,
      borderRadius: radius ?? const BorderRadius.all(Radius.circular(6)),
      boxShadow: [shadow ?? const BoxShadow(color: Colors.grey, blurRadius: 25.0 /*, offset: Offset(4.0, 4.0)*/)],
    );
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding ??= const EdgeInsets.all(8.0),
        child: builder?.call(this) ?? Text(text, style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}

/// AnyToastView
class AnyToastView extends StatelessWidget with AnyToastWidgetProperties {
  AnyToastView({Key? key, required String text}) : super(key: key) {
    this.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return createToastWidget();
  }
}

/// AnyToastWidget
class AnyToastWidget extends StatefulWidget with AnyToastWidgetProperties {
  AnyToastWidget({Key? key, required String text}) : super(key: key) {
    this.text = text;
  }

  @override
  State<AnyToastWidget> createState() => AnyToastState();
}

class AnyToastState extends State<AnyToastWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.createToastWidget();
  }
}
