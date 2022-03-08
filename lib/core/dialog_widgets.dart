import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';
import 'package:flutter_dialog_shower/view/rotate_widget.dart';
import 'dialog_wrapper.dart';

import 'dialog_shower.dart';

class DialogWidgets {
  static Widget? iconSuccessAlert;
  static Widget? iconFailedAlert;

  static Widget? iconLoading;

  static Widget? iconSuccess;
  static Widget? iconFailed;

  static Color? tipsDefBgColor;
  static TextStyle? tipsDefTextStyle;

  // Tips Of Loading, Success, Failed

  static DialogShower showFailed({Widget? icon, String? text = 'Failed', bool dismissible = true}) {
    Widget? widget = icon ?? iconFailed;
    return showTips(icon: widget, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showSuccess({Widget? icon, String? text = 'Success', bool dismissible = true}) {
    Widget? widget = icon ?? iconSuccess ?? CcWidgetUtils.getOneSuccessWidget();
    return showTips(icon: widget, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showLoading({Widget? icon, String? text = 'Loading', bool dismissible = false}) {
    Widget widget = RotateWidget(child: icon ?? iconLoading ?? CcWidgetUtils.getOneGappyCircle());
    return showTips(icon: widget, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showTips({
    double? width = 150,
    double? height = 150,
    double? iconTextGap = 6.0,
    Widget? icon,
    String? text,
    TextStyle? textStyle,
    Color? bgColor,
  }) {
    List<Widget> children = <Widget>[];
    if (icon != null) {
      children.add(icon);
      if (iconTextGap != null && iconTextGap != 0) {
        children.add(SizedBox(height: iconTextGap));
      }
    }
    if (text != null) {
      children.add(Text(text, style: textStyle ?? tipsDefTextStyle ?? const TextStyle(color: Colors.white, fontSize: 16)));
    }
    DialogShower dialog = DialogWrapper.show(
      Container(
        width: width,
        height: height,
        color: bgColor ?? tipsDefBgColor ?? Colors.black,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
      ),
    );

    // rewrite properties cause show actually in the next micro task :)
    dialog
      ..barrierDismissible = true
      ..alignment = Alignment.center
      ..barrierColor = Colors.black.withAlpha(64)
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
      };
    return dialog;
  }

  // Alert With Buttons Text
  static DialogShower showAlertFailed({
    String? text,
    TextStyle? textStyle,
    String? button1Text,
    TextStyle? button1TextStyle,
    Function(DialogShower dialog)? button1Event,
    String? button2Text,
    TextStyle? button2TextStyle,
    Function(DialogShower dialog)? button2Event,
  }) {
    return showAlertIcon(
      icon: iconFailedAlert,
      text: text,
      textStyle: textStyle,
      button1Text: button1Text,
      button1TextStyle: button1TextStyle,
      button1Event: button1Event,
      button2Text: button2Text,
      button2TextStyle: button2TextStyle,
      button2Event: button2Event,
    );
  }

  static DialogShower showAlertSuccess({
    String? text,
    TextStyle? textStyle,
    String? button1Text,
    TextStyle? button1TextStyle,
    Function(DialogShower dialog)? button1Event,
    String? button2Text,
    TextStyle? button2TextStyle,
    Function(DialogShower dialog)? button2Event,
  }) {
    return showAlertIcon(
      icon: iconSuccessAlert,
      text: text,
      textStyle: textStyle,
      button1Text: button1Text,
      button1TextStyle: button1TextStyle,
      button1Event: button1Event,
      button2Text: button2Text,
      button2TextStyle: button2TextStyle,
      button2Event: button2Event,
    );
  }

  static DialogShower showAlertIcon({
    Widget? icon,
    double? width,
    double? height,
    EdgeInsets? padding,
    String? text,
    TextStyle? textStyle,
    String? button1Text,
    TextStyle? button1TextStyle,
    Function(DialogShower dialog)? button1Event,
    String? button2Text,
    TextStyle? button2TextStyle,
    Function(DialogShower dialog)? button2Event,
  }) {
    return showAlert(
      width: width ?? 320,
      height: height ?? 214,
      padding: padding ?? const EdgeInsets.only(top: 28),
      icon: icon,
      text: text,
      textStyle: textStyle,
      button1Text: button1Text,
      button1TextStyle: button1TextStyle,
      button1Event: button1Event,
      button2Text: button2Text,
      button2TextStyle: button2TextStyle,
      button2Event: button2Event,
    );
  }

  static DialogShower showAlert({
    required double width,
    required double height,
    EdgeInsets? padding,
    Widget? icon,
    String? text,
    TextStyle? textStyle,
    String? button1Text,
    TextStyle? button1TextStyle,
    Function(DialogShower dialog)? button1Event,
    String? button2Text,
    TextStyle? button2TextStyle,
    Function(DialogShower dialog)? button2Event,
  }) {
    DialogShower dialog = DialogShower();
    DialogWrapper.showWith(
      dialog,
      Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: padding,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: padding == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  icon ?? const Offstage(offstage: true),
                  icon == null ? const Offstage(offstage: true) : const SizedBox(height: 12),
                  text == null ? const Offstage(offstage: true) : Text(text, style: textStyle ?? const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            button1Text == null && button2Text == null ? const Offstage(offstage: true) : const Divider(height: 1),
            IntrinsicHeight(
              child: Row(
                children: [
                  button1Text == null
                      ? const Offstage(offstage: true)
                      : Expanded(
                          child: CupertinoButton(
                              child: Text(button1Text, style: button1TextStyle ?? const TextStyle(fontSize: 17)),
                              onPressed: () => button1Event?.call(dialog))),
                  button1Text == null || button2Text == null ? const Offstage(offstage: true) : const VerticalDivider(width: 1),
                  button2Text == null
                      ? const Offstage(offstage: true)
                      : Expanded(
                          child: CupertinoButton(
                              child: Text(button2Text, style: button2TextStyle ?? const TextStyle(fontSize: 17)),
                              onPressed: () => button2Event?.call(dialog))),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // rewrite properties
    dialog
      ..alignment = Alignment.center
      ..barrierDismissible = button1Text == null && button2Text == null
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      };
    return dialog;
  }
}

/// Convenient Widget for being easy to use
class CommonStatefulWidget<T extends CommonStatefulWidgetState> extends StatefulWidget {
  CommonStatefulWidget({Key? key, this.builder, this.initState, this.dispose}) : super(key: key);

  void Function(T state)? initState;
  void Function(T state)? dispose;
  Widget Function(T state, BuildContext context)? builder;

  @override
  T createState() => CommonStatefulWidgetState() as T;
}

class CommonStatefulWidgetState extends State<CommonStatefulWidget> {
  @override
  void initState() {
    widget.initState?.call(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose?.call(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.builder != null, 'Cannot provide a null builder !!!');
    return widget.builder!(this, context);
  }
}

class CommonStatefulWidgetWithTicker extends CommonStatefulWidget {
  CommonStatefulWidgetWithTicker({Key? key, builder, initState, dispose})
      : super(key: key, builder: builder, initState: initState, dispose: dispose);

  @override
  CommonStatefulWidgetWithTickerState createState() => CommonStatefulWidgetWithTickerState();
}

class CommonStatefulWidgetWithTickerState extends CommonStatefulWidgetState with SingleTickerProviderStateMixin {}

class CommonStatefulWidgetWithTickers extends CommonStatefulWidget {
  CommonStatefulWidgetWithTickers({Key? key, builder, initState, dispose})
      : super(key: key, builder: builder, initState: initState, dispose: dispose);

  @override
  CommonStatefulWidgetWithTickersState createState() => CommonStatefulWidgetWithTickersState();
}

class CommonStatefulWidgetWithTickersState extends CommonStatefulWidgetState with TickerProviderStateMixin {}

/// Painters
// https://blog.codemagic.io/flutter-custom-painter/
// https://github.com/sbis04/custom_painter
// https://medium.com/flutter-community/playing-with-paths-in-flutter-97198ba046c8
// https://github.com/divyanshub024/flutter_path_animation
class YesIconPainter extends CustomPainter {
  double width, height;
  double? stroke;
  Color? color;
  double? progress;

  YesIconPainter({required this.width, required this.height, this.stroke, this.color, this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? 25
      ..color = color ?? Colors.white;

    if (progress != null) {
      double p = progress!;

      // the best ratio is width: height is 3 : 2
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

  @override
  bool shouldRepaint(covariant YesIconPainter oldDelegate) => oldDelegate.progress != progress;
}

class GappyCirclePainter extends CustomPainter {
  double radius;
  double strokeWidth;

  // ARC
  Color? colorBig, colorSmall;
  double? startAngleBig, sweepAngleBig;
  double? startAngleSmall, sweepAngleBigSmall;

  GappyCirclePainter(
      {required this.radius,
      required this.strokeWidth,
      this.colorBig,
      this.colorSmall,
      this.startAngleBig,
      this.sweepAngleBig,
      this.startAngleSmall,
      this.sweepAngleBigSmall});

  @override
  void paint(Canvas canvas, Size size) {
    double side = radius * 2 - strokeWidth;
    var paintOne = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorBig ?? Colors.white;
    var paintTow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorSmall ?? Colors.grey.withAlpha(128);
    canvas.drawArc(Rect.fromCenter(center: Offset.zero, width: side, height: side), startAngleBig ?? 0, sweepAngleBig ?? 2 * pi / 5 * 4,
        false, paintOne);
    canvas.drawArc(Rect.fromCenter(center: Offset.zero, width: side, height: side), startAngleSmall ?? 2 * pi / 5 * 4,
        sweepAngleBigSmall ?? 2 * pi / 5 * 1, false, paintTow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CcWidgetUtils {
  static Widget getOneGappyCircle({double? side, double? stroke}) {
    side ??= 64.0;
    stroke ??= 4.0;
    return Container(
      width: side,
      height: side,
      alignment: Alignment.center,
      child: CustomPaint(painter: GappyCirclePainter(radius: side / 2, strokeWidth: stroke)),
    );
  }

  static Widget getOneSuccessWidget() {
    return Container(
      width: 90,
      height: 90,
      padding: const EdgeInsets.only(left: 5, top: 10),
      child: CommonStatefulWidgetWithTicker(
        initState: (state) {
          AnimationController _controller = AnimationController(vsync: state, duration: const Duration(milliseconds: 500));
          Broker.setIfAbsent<AnimationController>(_controller, key: '_key_of_yes_animation_controller_');
          _controller.forward();
        },
        dispose: (state) {
          Broker.remove<AnimationController>('_key_of_yes_animation_controller_')?.dispose();
        },
        builder: (state, context) {
          AnimationController? _controller = Broker.get(key: '_key_of_yes_animation_controller_');
          assert(_controller != null, '_controller cannot be null, should init in initState');
          return AnimatedBuilder(
              animation: _controller!,
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: YesIconPainter(width: 90, height: 60, stroke: 16, progress: _controller.value),
                );
              });
        },
      ),
    );
  }
}
