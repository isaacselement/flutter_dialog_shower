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
        if ((shower.obj is int || shower.obj is List) && (shower.keyboardEventCallBack == null)) {
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

    return Container(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Positioned: '),
              getButton('Show center', onPressed: () {
                DialogWrapper.show(
                  getEditBox(width: 500, height: 600),
                  isFixed: true,
                  // width: 500,
                  // height: 600,
                );
              }),
              const SizedBox(width: 20),
              getButton('Show left', onPressed: () {
                DialogWrapper.showLeft(
                  getEditBox(),
                  isFixed: true,
                );
              }),
              const SizedBox(width: 20),
              getButton('Show right', onPressed: () {
                DialogWrapper.showRight(
                  getEditBox(),
                  isFixed: true,
                );
              }),
              const SizedBox(width: 20),
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
              const Text('Un Positioned: '),
              getButton('Show center', onPressed: () {
                DialogWrapper.show(
                  getEditBox(),
                );
              }),
              const SizedBox(width: 20),
              getButton('Show left', onPressed: () {
                DialogWrapper.showLeft(
                  getEditBox(),
                );
              }),
              const SizedBox(width: 20),
              getButton('Show right', onPressed: () {
                DialogWrapper.showRight(
                  getEditBox(),
                );
              }),
              const SizedBox(width: 20),
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
              const Text('Custome Positioned: '),
              getButton('Show center', onPressed: () {
                DialogWrapper.show(
                  getEditBox(),
                ).obj = 1;
              }),
              const SizedBox(width: 20),
              getButton('Show left', onPressed: () {
                DialogWrapper.showLeft(
                  getEditBox(),
                ).obj = 1;
              }),
              const SizedBox(width: 20),
              getButton('Show right', onPressed: () {
                DialogWrapper.showRight(
                  getEditBox(),
                ).obj = 1;
              }),
              const SizedBox(width: 20),
              getButton('Show x/y Top', onPressed: () {
                DialogWrapper.show(
                  getEditBox(),
                  x: 200,
                  y: 200,
                ).keyboardEventCallBack = (shower, isKeyboardShow) {
                  PositionUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
                };
              }),
              const SizedBox(width: 20),
              getButton('Show x/y Bottom', onPressed: () {
                DialogWrapper.show(
                  getEditBox(height: 300),
                  x: 200,
                  y: 200,
                ).keyboardEventCallBack = (shower, isKeyboardShow) {
                  PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
                };
              }),
            ],
          ),
          Row(
            children: [
              const Text('Keyboard Widgets: '),
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
              const SizedBox(width: 20),
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
              const SizedBox(width: 20),
              getButton('Keyboard Rebuilder Widget', onPressed: () {
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
      ),
    );
  }

  /// Static Methods

  static CupertinoButton getButton(String buttonText, {void Function()? onPressed}) {
    return CupertinoButton(
      child: Text(buttonText),
      onPressed: () {
        onPressed?.call();
      },
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
}
