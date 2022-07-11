// ignore_for_file: must_be_immutable

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';
import 'package:flutter_dialog_shower/core/broker.dart';
import 'package:flutter_dialog_shower/util/elements_util.dart';
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

  static DialogShower showLoading({
    Widget? icon,
    String? text = 'Loading',
    bool dismissible = false,
    // --------- For Loading Painter -----------
    bool? isPaintAnimation,
    bool? isPaintStartStiff,
    bool? isPaintWrapRotate,
    double? side,
    double? stroke,
    Duration? duration,
    // --------- For Loading Painter -----------
  }) {
    Widget widget;
    icon ??= defIconLoading;
    if (icon != null) {
      widget = RotateWidget(child: icon);
    } else {
      widget = PainterWidgetUtil.getOneLoadingCircleWidget(
        isPaintAnimation: isPaintAnimation,
        isPaintStartStiff: isPaintStartStiff,
        isPaintWrapRotate: isPaintWrapRotate,
        side: side,
        stroke: stroke,
        duration: duration,
      );
    }
    return showIconText(icon: widget, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showSuccess({Widget? icon, String? text = 'Success', bool dismissible = true}) {
    Widget? w = icon ??
        defIconSuccess ??
        PainterWidgetUtil.getOnePainterWidget(size: const Size(70, 46), painter: (v) => SuccessIconPainter(progress: v));
    return showIconText(icon: w, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showFailed({Widget? icon, String? text = 'Failed', bool dismissible = true}) {
    Widget? w = icon ??
        defIconFailed ??
        PainterWidgetUtil.getOnePainterWidget(
          size: const Size(60, 60),
          painter: (v) => FailedIconPainter(progress: v),
          onAnimation: (controller) {
            return Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOutCubic)).animate(controller);
          },
        );
    return showIconText(icon: w, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showIconText({Widget? icon, String? text, Function(AnyIconTextOptions options)? onOptions}) {
    AnyIconTextOptions options = AnyIconTextOptions();
    options.textStyle = defIconTextStyle;
    options.backgroundColor = defIconBgColor;
    onOptions?.call(options);
    DialogShower shower = DialogWrapper.show(AnyIconTextWidget(icon: icon, text: text, options: options));
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

  static void setLoadingText(String text) {
    DialogShower? shower = DialogWrapper.getTopDialog();
    BuildContext? context = shower?.containerKey.currentContext;
    AnyIconTextWidget? widget = ElementsUtil.getWidgetOfType<AnyIconTextWidget>(context);
    widget?.text = text;
    ElementsUtil.rebuildWidgetOfType<AnyIconTextWidget>(context);
  }

  // Show Alert With Texts & Buttons
  static DialogShower showAlert({
    String? title,
    Widget? icon,
    String? text,
    double? width,
    double? height,
    String? buttonLeftTitle,
    String? buttonRightTitle,
    Function(DialogShower dialog)? buttonLeftEvent,
    Function(DialogShower dialog)? buttonRightEvent,
    Function(AnyAlertTextOptions options)? onOptions,
  }) {
    DialogShower shower = DialogShower();
    AnyAlertTextOptions options = AnyAlertTextOptions();
    width != null ? options.width = width : null;
    height != null ? options.height = height : null;
    buttonLeftTitle != null ? options.buttonLeftText = buttonLeftTitle : null;
    buttonRightTitle != null ? options.buttonRightText = buttonRightTitle : null;
    options.buttonLeftEvent = () {
      buttonLeftEvent?.call(shower);
    };
    options.buttonRightEvent = () {
      buttonRightEvent?.call(shower);
    };
    onOptions?.call(options);
    Widget widget = AnyAlertTextWidget(title: title, icon: icon, text: text, options: options);

    DialogWrapper.showWith(shower, widget);
    // rewrite properties
    shower
      ..alignment = Alignment.center
      ..barrierDismissible = buttonLeftEvent == null && buttonRightEvent == null
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
      };
    return shower;
  }
}

/// Widgets

/// AnyIconTextWidget
class AnyIconTextWidget extends StatefulWidget {
  AnyIconTextWidget({Key? key, this.icon, this.text, this.options}) : super(key: key);

  Widget? icon;
  String? text;
  AnyIconTextOptions? options;

  @override
  State<AnyIconTextWidget> createState() => AnyIconTextState();
}

class AnyIconTextState extends State<AnyIconTextWidget> {
  AnyIconTextOptions? _options;

  AnyIconTextOptions get options => widget.options ?? (_options ??= AnyIconTextOptions());

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    if (widget.icon != null) {
      children.add(widget.icon!);
    }
    if (options.spacing != null) {
      children.add(SizedBox(height: options.spacing!));
    }
    if (widget.text != null) {
      children.add(Text(widget.text!, style: options.textStyle ?? const TextStyle(color: Colors.white, fontSize: 16)));
    }
    return Container(
      width: options.width,
      height: options.height,
      padding: options.padding,
      decoration: options.decoration ?? BoxDecoration(color: options.backgroundColor ?? Colors.black),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
    );
  }
}

class AnyIconTextOptions {
  double? spacing = 16.0;
  TextStyle? textStyle;

  double? width = 150.0;
  double? height = 150.0;
  EdgeInsets? padding;
  Color? backgroundColor;
  BoxDecoration? decoration;
}

/// AnyAlertTextWidget
class AnyAlertTextWidget extends StatefulWidget {
  AnyAlertTextWidget({Key? key, this.icon, this.title, this.text, this.options}) : super(key: key);

  Widget Function(AnyAlertTextState state)? builder;
  Widget? icon;
  String? title;
  String? text;
  AnyAlertTextOptions? options;

  @override
  State<AnyAlertTextWidget> createState() => AnyAlertTextState();
}

class AnyAlertTextState extends State<AnyAlertTextWidget> {
  AnyAlertTextOptions? _options;

  AnyAlertTextOptions get options => widget.options ?? (_options ??= AnyAlertTextOptions());

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(this);
    }

    bool isNotNullZero(double? d) {
      return d != null && d != 0.0;
    }

    // contents
    List<Widget> children = <Widget>[];
    String? title = widget.title;
    Widget? icon = widget.icon ?? options.icon;
    String? text = widget.text;
    if (title != null) {
      children.add(Text(title, style: options.titleStyle));
    }
    if (icon != null) {
      if (children.isNotEmpty && isNotNullZero(options.iconSpacing)) children.add(SizedBox(height: options.iconSpacing));
      children.add(icon);
    }
    if (text != null) {
      if (children.isNotEmpty && isNotNullZero(options.textSpacing)) children.add(SizedBox(height: options.textSpacing));
      children.add(Text(text, style: options.textStyle));
    }
    Widget? contents;
    if (children.isNotEmpty) {
      contents = Padding(padding: options.padding, child: Column(mainAxisAlignment: options.alignment, children: children));
    }

    // buttons
    List<Widget> row = <Widget>[];
    void _addButton(String? title, TextStyle? titleStyle, Function()? event) {
      if (title != null) {
        row.add(
          Expanded(
            child: CupertinoButton(child: Text(title, style: titleStyle), onPressed: () => event?.call()),
          ),
        );
      }
    }

    _addButton(options.buttonLeftText, options.buttonLeftTextStyle, options.buttonLeftEvent);
    _addButton(options.buttonRightText, options.buttonRightTextStyle, options.buttonRightEvent);
    if (row.length == 2) {
      row.insert(1, const VerticalDivider(width: 1));
    }
    Widget? buttons;
    if (row.isNotEmpty) {
      buttons = IntrinsicHeight(child: Row(children: row));
    }

    // whole structure
    List<Widget> list = <Widget>[];
    if (contents != null) {
      list.add(Expanded(child: contents));
    }
    if (buttons != null) {
      if (isNotNullZero(options.buttonsSpacing)) children.add(SizedBox(height: options.buttonsSpacing));
      list.add(const Divider(height: 1));
      list.add(buttons);
    }

    return Container(
      width: options.width,
      height: options.height,
      decoration: options.decoration,
      child: Column(children: list),
    );
  }
}

class AnyAlertTextOptions {
  Widget? icon;
  double? iconSpacing = 12.0;
  double? textSpacing = 12.0;
  TextStyle? titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle? textStyle = const TextStyle(fontSize: 16);

  EdgeInsets padding = EdgeInsets.zero;
  MainAxisAlignment alignment = MainAxisAlignment.center;

  double? buttonsSpacing;
  String? buttonLeftText;
  String? buttonRightText;
  Function()? buttonLeftEvent;
  Function()? buttonRightEvent;
  TextStyle? buttonLeftTextStyle = const TextStyle(fontSize: 17);
  TextStyle? buttonRightTextStyle = const TextStyle(fontSize: 17);

  double? width = 320.0;
  double? height = 220.0;
  BoxDecoration? decoration = const BoxDecoration(color: Colors.white);
}

/// Painters

// https://github.com/divyanshub024/flutter_path_animation
// https://medium.com/flutter-community/playing-with-paths-in-flutter-97198ba046c8
// https://github.com/sbis04/custom_painter & https://blog.codemagic.io/flutter-custom-painter/

class LoadingIconPainter extends CustomPainter {
  double radius, strokeWidth;

  // ARC
  double ratioStart; // [0.0 - 1.0] // big start ratio
  double ratioLength; // [0.0 - 1.0] // big sweep angle length, if > 1.0, will reverse if odd
  Color? colorBig, colorSmall;
  double? startAngleBig, sweepAngleBig, startAngleSmall, sweepAngleSmall;

  final double _circle = 2 * math.pi;

  LoadingIconPainter({
    required this.radius,
    required this.strokeWidth,
    this.ratioStart = 0.0,
    this.ratioLength = 4.0 / 5.0,
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

    // ratio big
    int i = ratioLength.toInt();
    double fraction = ratioLength - i;
    double ratioDistance = i % 2 == 0 ? fraction : 1.0 - fraction;

    var paintBig = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorBig ?? Colors.white;
    var paintSmall = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorSmall ?? Colors.grey.withAlpha(128);

    double startAngleB = startAngleBig ?? _circle * ratioStart;
    double sweepAngleB = sweepAngleBig ?? _circle * ratioDistance;
    canvas.drawArc(Rect.fromLTWH(0, 0, width, height), startAngleB, sweepAngleB, false, paintBig);

    double startAngleS = startAngleSmall ?? startAngleB + sweepAngleB;
    double sweepAngleS = sweepAngleSmall ?? _circle - sweepAngleB;
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

/// Utils

class PainterWidgetUtil {
  static Widget getOneLoadingCircleWidget({
    bool? isPaintAnimation,
    bool? isPaintStartStiff,
    bool? isPaintWrapRotate,
    double? side,
    double? stroke,
    Duration? duration,
  }) {
    isPaintAnimation ??= false;
    isPaintStartStiff ??= false;
    isPaintWrapRotate ??= true;
    side ??= 64.0;
    stroke ??= 4.0;
    double radius = side / 2;
    double strokeWidth = stroke;
    Size size = Size(side, side);
    Duration time = duration ?? const Duration(milliseconds: 1000);

    if (!isPaintAnimation) {
      return RotateWidget(child: CustomPaint(size: size, painter: LoadingIconPainter(radius: radius, strokeWidth: strokeWidth)));
    }
    Widget paintView;
    Widget getPainterView(bool isRepeatWithReverse, List<double> Function(double progress) getAngels) {
      return getOnePainterWidget(
        size: size,
        isRepeat: true,
        duration: time,
        isRepeatWithReverse: isRepeatWithReverse,
        painter: (progress) {
          List<double> ratios = getAngels(progress);
          return LoadingIconPainter(radius: radius, strokeWidth: strokeWidth, ratioStart: ratios.first, ratioLength: ratios.last);
        },
      );
    }

    if (isPaintStartStiff) {
      double _previous = 0;
      int repeatCount = 0;
      paintView = getPainterView(false, (progress) {
        if (_previous > progress) {
          repeatCount++;
        }
        _previous = progress;
        double start = 0.0;
        double length = progress + repeatCount;
        return [start, length];
      });
    } else {
      double _previous = 0;
      bool isReversing = false;
      paintView = getPainterView(true, (progress) {
        isReversing = _previous > progress;
        _previous = progress;
        double start = isReversing ? 1.0 - progress : 0.0;
        double length = isReversing ? 1.0 - start : progress;
        return [start, length];
      });
    }
    return isPaintWrapRotate ? RotateWidget(child: paintView, isClockwise: true) : paintView;
  }

  static Widget getOnePainterWidget({
    required Size size,
    required CustomPainter Function(double progress) painter,
    bool isRepeat = false,
    bool isRepeatWithReverse = false,
    Duration duration = const Duration(milliseconds: 200),
    Animation<double>? Function(AnimationController controller)? onAnimation,
  }) {
    String controllerKey = 'Painter_${DateTime.now().millisecondsSinceEpoch}_${shortHash(UniqueKey())}';
    return BuilderWithTicker(
      init: (state) {
        BuilderWithTickerState vsync = state as BuilderWithTickerState;
        AnimationController controller = AnimationController(vsync: vsync, duration: duration);
        Broker.setIfAbsent<AnimationController>(controller, key: controllerKey);
        Future.delayed(const Duration(milliseconds: 200), () {
          AnimationController? controller = Broker.getIf<AnimationController>(key: controllerKey);
          isRepeat == true ? controller?.repeat(reverse: isRepeatWithReverse) : controller?.forward();
        });
      },
      dispose: (state) {
        AnimationController? controller = Broker.getIf<AnimationController>(key: controllerKey);
        controller?.stop();
        controller?.dispose();
      },
      builder: (state) {
        AnimationController? controller = Broker.getIf(key: controllerKey);
        assert(controller != null, 'AnimationController cannot be null, should init in initState');
        if (controller == null) {
          return CustomPaint(painter: painter(1.0));
        }
        Animation<double> animation = onAnimation?.call(controller) ?? controller;
        return AnimatedBuilder(
          animation: animation,
          builder: (context, snapshot) {
            return CustomPaint(size: size, painter: painter(animation.value));
          },
        );
      },
    );
  }
}
