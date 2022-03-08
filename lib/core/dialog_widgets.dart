import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Widget? widget = icon ?? iconSuccess;
    return showTips(icon: widget, text: text)..barrierDismissible = dismissible;
  }

  static DialogShower showLoading({Widget? icon, String? text = 'Loading', bool dismissible = false}) {
    Widget widget = RotateWidget(child: icon ?? iconLoading ?? GappyCirclePainter.getOneGappyCircle());
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

    // rewrite properties
    dialog
      ..barrierDismissible = true
      ..alignment = Alignment.center
      ..barrierColor = Colors.black.withAlpha(64)
      ..transitionDuration = const Duration(milliseconds: 200)
      ..transitionBuilder = (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
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

  static Widget getOneGappyCircle({double? side, double? stroke}) {
    side ??= 64.0;
    stroke ??= 4.0;
    return Container(
        width: side,
        height: side,
        alignment: Alignment.center,
        child: CustomPaint(painter: GappyCirclePainter(radius: side / 2, strokeWidth: stroke)));
  }
}
