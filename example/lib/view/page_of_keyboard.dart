import 'dart:async';

import 'package:example/util/position_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/events/keyboard_event_listener.dart';
import 'package:flutter_dialog_shower/views/keyboard_widget.dart';

import '../util/logger.dart';

class PageOfKeyboard extends StatelessWidget {
  static bool isInited = false;

  static Object flagStickToTopGlobalSetting = Object();

  static void ensureInited() {
    Logger.d('PageOfInfoView ensureInited---> $isInited');
    if (isInited) {
      return;
    }
    isInited = !isInited;

    // set up appearence for keyboard showed up in one place
    StreamSubscription streamSubscription = KeyboardEventListener.listen((isKeyboardShow) {
      Logger.d('PageOfInfoView 【keyboard visibility】---> isKeyboardShow: $isKeyboardShow');
      DialogShower? topDialog = DialogWrapper.getTopDialog();
      if (topDialog != null) {
        DialogShower shower = topDialog;
        if ((shower.obj == flagStickToTopGlobalSetting || shower.obj is List) && (shower.keyboardEventCallBack == null)) {
          Logger.d('PageOfInfoView 【keyboard visibility】---> come in ...');
          PositionUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
        }
      }
    });
    // streamSubscription.cancel();   // need to cancel by yourself
  }

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfInfoView] ----------->>>>>>>>>>>> build/rebuild!!!");
    PageOfKeyboard.ensureInited();

    List<String> titles = ['Positioned: ', 'Un Positioned: ', 'Custome Positioned: ', 'Keyboard Widgets: '];
    TextStyle titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    double maxTitleWidth = getMaxTextWidth(titles, titleStyle);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[0], style: titleStyle)),
            getButton('Show center', onPressed: () {
              DialogWrapper.show(
                getEditBox(width: 500, height: 600),
                isFixed: true,
                // width: 500,
                // height: 600,
              );
            }),
            getButton('Show left', onPressed: () {
              DialogWrapper.showLeft(
                getEditBox(),
                isFixed: true,
              );
            }),
            getButton('Show right', onPressed: () {
              DialogWrapper.showRight(
                getEditBox(),
                isFixed: true,
              );
            }),
            getButton('Show x/y', onPressed: () {
              DialogWrapper.show(
                getEditBox(),
                isFixed: true,
                x: 200,
                y: 200,
              );
            }),
          ],
        ),
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[1], style: titleStyle)),
            getButton('Show center', onPressed: () {
              DialogWrapper.show(
                getEditBox(),
              );
            }),
            getButton('Show left', onPressed: () {
              DialogWrapper.showLeft(
                getEditBox(),
              );
            }),
            getButton('Show right', onPressed: () {
              DialogWrapper.showRight(
                getEditBox(),
              );
            }),
            getButton('Show x/y', onPressed: () {
              DialogWrapper.show(
                getEditBox(),
                x: 200,
                y: 200,
              );
            }),
          ],
        ),
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[2], style: titleStyle)),
            getButton('Show center', onPressed: () {
              DialogWrapper.show(
                getEditBox(),
              ).obj = flagStickToTopGlobalSetting;
            }),
            getButton('Show left', onPressed: () {
              DialogWrapper.showLeft(
                getEditBox(),
              ).obj = flagStickToTopGlobalSetting;
            }),
            getButton('Show right', onPressed: () {
              DialogWrapper.showRight(
                getEditBox(),
              ).keyboardEventCallBack = (shower, isKeyboardShow) {
                PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            getButton('x/y stick Top', onPressed: () {
              DialogWrapper.show(
                getEditBox(),
                x: 200,
                y: 200,
              ).keyboardEventCallBack = (shower, isKeyboardShow) {
                PositionUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            getButton('x/y stick Bottom', width: 160, onPressed: () {
              DialogWrapper.show(
                getEditBox(width: 500, height: 300),
                x: 200,
                y: 200,
              ).keyboardEventCallBack = (shower, isKeyboardShow) {
                PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            getButton('x/y stick Bottom', width: 160, onPressed: () {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      getEditBox(width: 500, height: 300),
                      Container(
                        color: Colors.yellow,
                        height: 50,
                        width: 500,
                        alignment: Alignment.center,
                        child: const Text('I will be stick bottom when keyboard show up'),
                      )
                    ],
                  ),
                ),
                x: 200,
                y: 200,
              ).keyboardEventCallBack = (shower, isKeyboardShow) {
                Future.delayed(isKeyboardShow ? const Duration(milliseconds: 200) : const Duration(milliseconds: 50), () {
                  PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
                });
              };
            }),
          ],
        ),
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[3], style: titleStyle)),
            getButton('Show Invisible', onPressed: () {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      getEditBox(width: 500, height: 300),
                      KeyboardInvisibleWidget(
                        child: Container(
                          color: Colors.yellow,
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text('I will be invisible'),
                        ),
                      )
                    ],
                  ),
                ),
                width: 500,
              );
            }),
            getButton('Show Visible', onPressed: () {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      getEditBox(width: 500, height: 300),
                      KeyboardInvisibleWidget(
                        child: Container(
                          color: Colors.yellow,
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text('I will be invisible'),
                        ),
                        isReverse: true,
                      )
                    ],
                  ),
                ),
                width: 500,
              );
            }),
            getButton('Rebuilder Widget', width: 160, onPressed: () {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      getEditBox(width: 500, height: 100),
                      KeyboardRebuildWidget(
                        builder: (BuildContext context, bool isKeyboardVisible) {
                          return Container(
                            color: Colors.yellow,
                            height: 100,
                            alignment: Alignment.center,
                            child: Text(!isKeyboardVisible ? '>>>>>Text will changed on rebuild<<<<<' : '***Text is changed :)***'),
                          );
                        },
                      )
                    ],
                  ),
                ),
                width: 500,
              );
            }),
          ],
        ),
      ],
    );
  }

  /// Static Methods

  static Widget getButton(String buttonText, {void Function()? onPressed, double? width}) {
    return Container(
      width: width ?? 130,
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 8),
        child: Text(
          buttonText,
          textAlign: TextAlign.left,
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }

  static Widget getEditBox({double width = 500, double height = 600}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(border: Border.all(color: Colors.lightGreen, width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField(
              padding: const EdgeInsets.all(6.0),
              style: const TextStyle(fontSize: 15, color: Colors.black),
              maxLines: 100,
              maxLength: 1000,
              onChanged: (str) {},
            )
          ],
        ),
      ),
    );
  }

  static double getMaxTextWidth(List<String> texts, TextStyle style) {
    double max = 0;
    for (String text in texts) {
      final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      double width = textPainter.size.width;
      if (max < width) {
        max = width;
      }
    }
    return max;
  }
}
