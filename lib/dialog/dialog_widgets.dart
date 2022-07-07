// ignore_for_file: must_be_immutable

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';
import 'package:flutter_dialog_shower/core/broker.dart';
import 'package:flutter_dialog_shower/view/cc_animate_widgets.dart';

import 'dialog_shower.dart';
import 'dialog_wrapper.dart';

class DialogWidgets {
  static Widget? defIconLoading;
  static Widget? defIconSuccess;
  static Widget? defIconFailed;
  static Color? defIconBgColor;
  static TextStyle? defIconTextStyle;

  static double? defAlertWidth;
  static double? defAlertHeight;

  // Indicator, Loading, Success, Failed

  static DialogShower showIndicator() {
    return DialogWrapper.show(const CupertinoActivityIndicator())
      ..alignment = Alignment.center
      ..containerDecoration = null
      ..barrierDismissible = true
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
      };
  }

  static DialogShower showLoading({Widget? icon, String? text = 'Loading', bool dismissible = false}) {
    Widget w = RotateWidget(child: icon ?? defIconLoading ?? CcWidgetUtils.getOneGappyCircle());
    return showIconText(icon: w, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showSuccess({Widget? icon, String? text = 'Success', bool dismissible = true}) {
    Widget? w = icon ??
        defIconSuccess ??
        SizedBox(width: 70, height: 46, child: CcWidgetUtils.getOnePainterWidget(painter: (v) => SuccessIconPainter(progress: v)));
    return showIconText(icon: w, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showFailed({Widget? icon, String? text = 'Failed', bool dismissible = true}) {
    Widget? w = icon ??
        defIconFailed ??
        SizedBox(width: 60, height: 60, child: CcWidgetUtils.getOnePainterWidget(painter: (v) => FailedIconPainter(progress: v)));
    return showIconText(icon: w, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showIconText({
    double? width = 150,
    double? height = 150,
    double? iconTextGap = 16.0,
    Widget? icon,
    String? text,
    TextStyle? textStyle,
    EdgeInsets? padding,
    Decoration? decoration,
    Color? backgroundColor,
  }) {
    List<Widget> children = <Widget>[];
    if (icon != null) {
      children.add(icon);
      if (iconTextGap != null && iconTextGap != 0) {
        children.add(SizedBox(height: iconTextGap));
      }
    }
    if (text != null) {
      children.add(Text(text, style: textStyle ?? defIconTextStyle ?? const TextStyle(color: Colors.white, fontSize: 16)));
    }
    Widget widget = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration ?? BoxDecoration(color: backgroundColor ?? defIconBgColor ?? Colors.black),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
    );
    DialogShower shower = DialogWrapper.show(widget);

    // rewrite properties cause show actually in the next micro task :)
    shower
      ..barrierDismissible = true
      ..alignment = Alignment.center
      ..barrierColor = Colors.black.withAlpha(64)
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
      };
    return shower;
  }

  // Show Alert With Texts & Buttons
  static DialogShower showAlert({
    double? width,
    double? height,
    Decoration? decoration = const BoxDecoration(color: Colors.white),
    EdgeInsets? padding,
    String? title,
    TextStyle? titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    Widget? icon,
    String? text,
    TextStyle? textStyle = const TextStyle(fontSize: 16),
    double? titleBottomGap = 12.0,
    double? iconBottomGap = 12.0,
    String? button1Text,
    TextStyle? button1TextStyle = const TextStyle(fontSize: 17),
    Function(DialogShower dialog)? button1Event,
    String? button2Text,
    TextStyle? button2TextStyle = const TextStyle(fontSize: 17),
    Function(DialogShower dialog)? button2Event,
  }) {
    DialogShower shower = DialogShower();

    List<Widget> children = <Widget>[];
    title != null ? children.add(Text(title, style: titleStyle)) : null;
    title != null ? children.add(SizedBox(height: titleBottomGap)) : null;

    icon != null ? children.add(icon) : null;
    icon != null ? children.add(SizedBox(height: iconBottomGap)) : null;

    text != null ? children.add(Text(text, style: textStyle)) : null;
    MainAxisAlignment columnMainAxis = padding == null ? MainAxisAlignment.center : MainAxisAlignment.start;

    // buttons
    List<Widget> buttonsRowChildren = <Widget>[];
    if (button1Text != null) {
      buttonsRowChildren.add(
        Expanded(
          child: CupertinoButton(child: Text(button1Text, style: button1TextStyle), onPressed: () => button1Event?.call(shower)),
        ),
      );
    }
    if (button1Text != null && button2Text != null) {
      buttonsRowChildren.add(const VerticalDivider(width: 1));
    }
    if (button2Text != null) {
      buttonsRowChildren.add(
        Expanded(
          child: CupertinoButton(child: Text(button2Text, style: button2TextStyle), onPressed: () => button2Event?.call(shower)),
        ),
      );
    }

    Widget widget = Container(
      width: width ?? defAlertWidth,
      height: height ?? defAlertHeight,
      decoration: decoration,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(0),
              child: Column(mainAxisAlignment: columnMainAxis, children: children),
            ),
          ),
          button1Text == null && button2Text == null ? const Offstage(offstage: true) : const Divider(height: 1),
          IntrinsicHeight(child: Row(children: buttonsRowChildren)),
        ],
      ),
    );

    DialogWrapper.showWith(shower, widget);
    // rewrite properties
    shower
      ..alignment = Alignment.center
      ..barrierDismissible = button1Event == null && button2Event == null
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
      };
    return shower;
  }
}

/// Painters

// https://github.com/sbis04/custom_painter
// https://blog.codemagic.io/flutter-custom-painter/
// https://github.com/divyanshub024/flutter_path_animation
// https://medium.com/flutter-community/playing-with-paths-in-flutter-97198ba046c8

class LoadingIconPainter extends CustomPainter {
  double radius, strokeWidth;

  // ARC
  double bigRatio; // [0.0 - 1.0]
  Color? colorBig, colorSmall;
  double? startAngleBig, sweepAngleBig, startAngleSmall, sweepAngleSmall;

  LoadingIconPainter({
    required this.radius,
    required this.strokeWidth,
    this.bigRatio = 4.0 / 5.0,
    this.colorBig,
    this.colorSmall,
    this.startAngleBig,
    this.sweepAngleBig,
    this.startAngleSmall,
    this.sweepAngleSmall,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double side = radius * 2;
    double width = size.width;
    width = width == 0 ? side : width;
    double height = size.height;
    height = height == 0 ? side : height;

    int i = bigRatio.toInt();
    bigRatio = i % 2 == 0 ? bigRatio - i : 1.0 - (bigRatio - i);
    double smallRatio = 1.0 - bigRatio;

    var paintBig = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorBig ?? Colors.white;
    var paintSmall = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorSmall ?? Colors.grey.withAlpha(128);

    double startAngleB = startAngleBig ?? 0;
    double sweepAngleB = sweepAngleBig ?? 2 * math.pi * bigRatio;
    canvas.drawArc(Rect.fromLTWH(0, 0, width, height), startAngleB, sweepAngleB, false, paintBig);

    double startAngleS = startAngleSmall ?? 2 * math.pi * bigRatio;
    double sweepAngleS = sweepAngleSmall ?? 2 * math.pi * smallRatio;
    canvas.drawArc(Rect.fromLTWH(0, 0, width, height), startAngleS, sweepAngleS, false, paintSmall);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}

abstract class ProgressIconPainter extends CustomPainter {
  Color? color;
  double? stroke;
  double? progress;

  ProgressIconPainter({this.color, this.stroke, this.progress = 1.0});

  @override
  bool shouldRepaint(covariant ProgressIconPainter oldDelegate) => oldDelegate.progress != progress;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? 11
      ..color = color ?? Colors.white;
    if (progress != null) {
      paintWithProgress(canvas, size, paint, progress!);
    }
  }

  void paintWithProgress(Canvas canvas, Size size, Paint paint, double p);
}

class FailedIconPainter extends ProgressIconPainter {
  FailedIconPainter({color = Colors.red, stroke, progress = 1.0}) : super(color: color, stroke: stroke, progress: progress);

  @override
  void paintWithProgress(Canvas canvas, Size size, Paint paint, double p) {
    double width = size.width;
    double height = size.height;

    // the best ratio is width: height => 1 : 1
    Path pathLeft = Path();
    pathLeft.moveTo(0, 0);
    pathLeft.lineTo(width * p, height * p);

    Path pathRight = Path();
    pathRight.moveTo(width, 0);
    pathRight.lineTo(width - (width * p), height * p);

    canvas.drawPath(pathLeft, paint);
    canvas.drawPath(pathRight, paint);
  }
}

class SuccessIconPainter extends ProgressIconPainter {
  SuccessIconPainter({color = Colors.green, stroke, progress = 1.0}) : super(color: color, stroke: stroke, progress: progress);

  @override
  void paintWithProgress(Canvas canvas, Size size, Paint paint, double p) {
    double width = size.width;
    double height = size.height;

    // the best ratio is width: height => 3 : 2
    Path path = Path();
    double shortLineX = 0;
    double shortLineY = height / 2;
    double shortLineW = width / 3;

    path.moveTo(shortLineX, shortLineY);

    double ratio = p * 2;
    double ratioShort = ratio <= 1 ? ratio : 1, ratioLong = ratio >= 1 ? ratio - 1 : 0;

    // draw short line & long line
    path.lineTo(shortLineX + (shortLineW - shortLineX) * ratioShort, shortLineY + (height - shortLineY) * ratioShort);
    if (ratioLong != 0) {
      path.lineTo(shortLineW + (width - shortLineW) * ratioLong, height - ratioLong * height);
    }
    canvas.drawPath(path, paint);
  }
}

class CcWidgetUtils {
  static Widget getOneGappyCircle({double? side, double? stroke}) {
    side ??= 64.0;
    stroke ??= 4.0;
    return CustomPaint(
      child: SizedBox(width: side, height: side),
      painter: LoadingIconPainter(radius: side / 2, strokeWidth: stroke),
    );
  }

  static Widget getOnePainterWidget({required CustomPainter Function(double progress) painter}) {
    String controllerKey = 'Painter_${DateTime.now().millisecondsSinceEpoch}_${shortHash(UniqueKey())}';
    return BuilderWithTicker(
      init: (state) {
        BuilderWithTickerState vsync = state as BuilderWithTickerState;
        AnimationController ctrl = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 300));
        Future.delayed(const Duration(milliseconds: 200), () {
          Broker.getIf<AnimationController>(key: controllerKey)?.forward();
        });
        Broker.setIfAbsent<AnimationController>(ctrl, key: controllerKey);
      },
      dispose: (state) {
        Broker.remove<AnimationController>(key: controllerKey)?.dispose();
      },
      builder: (state) {
        AnimationController? controller = Broker.getIf(key: controllerKey);
        assert(controller != null, '_controller cannot be null, should init in initState');
        return controller == null
            ? CustomPaint(painter: painter(1.0))
            : AnimatedBuilder(
                animation: controller,
                builder: (context, snapshot) {
                  return CustomPaint(painter: painter(controller.value));
                },
              );
      },
    );
  }
}
