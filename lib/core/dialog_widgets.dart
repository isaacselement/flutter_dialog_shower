import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/view/rotate_widget.dart';
import 'dialog_wrapper.dart';

import 'dialog_shower.dart';

class DialogWidgets {

  static Widget? iconSuccessAlert = null;
  static Widget? iconFailedAlert = null;

  static Widget? iconLoading = null;
  static Widget? iconSuccess = null;
  static Widget? iconFailed = null;

  static Color? tipsDefColor = null;
  static TextStyle? tipsDefTextStyle = null;

  // Tips Of Loading, Success, Failed

  static DialogShower showFailed({String? text = 'Failed'}) {
    return showTips(icon: iconFailed, text: text);
  }

  static DialogShower showSuccess({String? text = 'Success'}) {
    return showTips(icon: iconSuccess!, text: text);
  }

  static DialogShower showLoading({String? text = 'Loading', bool dismissible = false}) {
    return showTips(
      icon: RotateWidget(child: iconLoading!),
      text: text,
    )..barrierDismissible = dismissible;
  }

  static DialogShower showTips({
    double? width = 150,
    double? height = 150,
    Widget? icon,
    String? text,
    TextStyle? textStyle,
    Color? color,
    double? iconTextGap = 6.0,
  }) {
    List<Widget> children = <Widget>[];
    if (icon != null) {
      children.add(icon);
      if (iconTextGap != null && iconTextGap != 0) {
        children.add(SizedBox(height: iconTextGap));
      }
    }
    if (text != null) {
      children.add(
        Text(text, style: textStyle ?? tipsDefTextStyle),
      );
    }
    DialogShower dialog = DialogWrapper.show(
      Container(
        width: width,
        height: height,
        color: color ?? tipsDefColor,
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
