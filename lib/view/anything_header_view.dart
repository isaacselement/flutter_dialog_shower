import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

//ignore: must_be_immutable
class AnythingHeader extends StatelessWidget {
  String? title;

  AnythingHeaderOptions? options;

  AnythingHeader({
    Key? key,
    this.title,
    this.options,
  }) : super(key: key);

  AnythingHeaderOptions get kOptions => options ?? AnythingHeaderOptions();

  @override
  Widget build(BuildContext context) {
    return buildContainer();
  }

  Widget buildContainer() {
    return Container(
      width: kOptions.headerWidth,
      height: kOptions.headerHeight,
      decoration: kOptions.headerDecoration,
      child: Stack(
        children: [
          // center
          Container(
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: kOptions.titleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // left
          Positioned(
            child: kOptions.leftBuilder?.call() ??
                Container(
                  width: kOptions.leftWidth,
                  color: Colors.transparent,
                  child: CupertinoButton(
                    alignment: Alignment.center,
                    pressedOpacity: kOptions.leftPressedOpacity,
                    padding: kOptions.leftPadding ?? EdgeInsets.zero,
                    child: kOptions.leftWidget ?? Text(kOptions.leftTitle ?? '', style: kOptions.leftTitleStyle),
                    onPressed: () {
                      if (kOptions.leftEvent != null) {
                        kOptions.leftEvent?.call();
                      } else {
                        DialogWrapper.dismissTopDialog();
                      }
                    },
                  ),
                ),
            top: 0,
            left: 0,
            bottom: 0,
          ),
          // right
          Positioned(
            child: kOptions.rightBuilder?.call() ??
                Container(
                  width: kOptions.rightWidth,
                  color: Colors.transparent,
                  child: CupertinoButton(
                    alignment: Alignment.center,
                    pressedOpacity: kOptions.rightPressedOpacity,
                    padding: kOptions.rightPadding ?? EdgeInsets.zero,
                    child: kOptions.rightWidget ?? Text(kOptions.rightTitle ?? '', style: kOptions.rightTitleStyle),
                    onPressed: () {
                      kOptions.rightEvent?.call();
                    },
                  ),
                ),
            top: 0,
            right: 0,
            bottom: 0,
          ),
        ],
      ),
    );
  }
}

class AnythingHeaderOptions {
  // header
  double? headerWidth;
  double? headerHeight;
  BoxDecoration? headerDecoration = const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0XFFF0F0F0))));

  // title
  TextStyle? titleStyle = const TextStyle(fontSize: 17, color: Color(0xFF1C1D21), fontWeight: FontWeight.bold);

  // left
  double? leftWidth;
  String? leftTitle = 'Cancel';
  double? leftPressedOpacity = 0.4;
  EdgeInsets? leftPadding = const EdgeInsets.only(left: 28, right: 28);
  TextStyle? leftTitleStyle = const TextStyle(fontSize: 17, color: Color(0xFF3C78FE));

  Widget? leftWidget;
  void Function()? leftEvent;
  Widget? Function()? leftBuilder;

  // right
  double? rightWidth;
  String? rightTitle = 'Save';
  double? rightPressedOpacity = 0.4;
  EdgeInsets? rightPadding = const EdgeInsets.only(left: 28, right: 28);
  TextStyle? rightTitleStyle = const TextStyle(fontSize: 17, color: Color(0xFF3C78FE));

  Widget? rightWidget;
  void Function()? rightEvent;
  Widget? Function()? rightBuilder;

  AnythingHeaderOptions();

  AnythingHeaderOptions clone() {
    AnythingHeaderOptions newInstance = AnythingHeaderOptions();
    // header
    newInstance.headerWidth = headerWidth;
    newInstance.headerHeight = headerHeight;
    newInstance.headerDecoration = headerDecoration;

    // title
    newInstance.titleStyle = titleStyle;

    // left
    newInstance.leftWidth = leftWidth;
    newInstance.leftTitle = leftTitle;
    newInstance.leftPressedOpacity = leftPressedOpacity;
    newInstance.leftPadding = leftPadding;
    newInstance.leftTitleStyle = leftTitleStyle;
    newInstance.leftWidget = leftWidget;
    newInstance.leftEvent = leftEvent;
    newInstance.leftBuilder = leftBuilder;

    // right
    newInstance.rightWidth = rightWidth;
    newInstance.rightTitle = rightTitle;
    newInstance.rightPressedOpacity = rightPressedOpacity;
    newInstance.rightPadding = rightPadding;
    newInstance.rightTitleStyle = rightTitleStyle;
    newInstance.rightWidget = rightWidget;
    newInstance.rightEvent = rightEvent;
    newInstance.rightBuilder = rightBuilder;

    return newInstance;
  }
}
