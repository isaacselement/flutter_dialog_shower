import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/components/keyboard_widget.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/listener/keyboard_event_listener.dart';

import '../util/logger.dart';

class PageOfKeyboardView extends StatelessWidget {
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
          PageOfKeyboardView.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
        }
      }
    });
    // streamSubscription.cancel();   // need to cancel by yourself
  }

  static void rebuildShowerPositionTopOnKeyboardEvent(DialogShower shower, bool isKeyboardShow, {double? top}) {
    Logger.d("[PageOfInfoView] >>>>>>>>>>>> rebuildShowerPositionTopOnKeyboardEvent $isKeyboardShow !!!");
    shower.obj = shower.obj is List ? shower.obj : [shower.alignment, shower.margin];
    Alignment? aliOld = (shower.obj as List)[0];
    Alignment aliNew = Alignment(aliOld?.x ?? 0.0, -1.0); // Alignment topCenter = Alignment(0.0, -1.0);
    EdgeInsets? insOld = (shower.obj as List)[1];
    EdgeInsets insNew = EdgeInsets.only(
      left: insOld?.left ?? 0,
      right: insOld?.right ?? 0,
      bottom: insOld?.bottom ?? 0,
      top: top ?? MediaQuery.of(DialogShower.gContext!).padding.top,
    );
    shower.setState(() {
      shower.alignment = isKeyboardShow ? aliNew : aliOld;
      shower.margin = isKeyboardShow ? insNew : insOld;
    });
  }

  static void rebuildShowerPositionBottomOnKeyboardEvent(DialogShower shower, bool isKeyboardShow, {double? bottom, double? top}) {
    Logger.d("[PageOfInfoView] >>>>>>>>>>>> rebuildShowerPositionBottomOnKeyboardEvent $isKeyboardShow !!!");
    shower.obj = shower.obj is List ? shower.obj : [shower.alignment, shower.margin];
    Alignment? aliOld = (shower.obj as List)[0];
    Alignment aliNew = Alignment(aliOld?.x ?? 0.0, 1.0); // Alignment bottomCenter = Alignment(0.0, 1.0);
    EdgeInsets? insOld = (shower.obj as List)[1];
    EdgeInsets insNew = EdgeInsets.only(
      left: insOld?.left ?? 0,
      right: insOld?.right ?? 0,
      bottom: bottom ?? 20,
      top: top ?? MediaQuery.of(DialogShower.gContext!).padding.top,
    );
    shower.setState(() {
      shower.alignment = isKeyboardShow ? aliNew : aliOld;
      shower.margin = isKeyboardShow ? insNew : insOld;
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfInfoView] ----------->>>>>>>>>>>> build/rebuild!!!");
    PageOfKeyboardView.ensureInited();

    return Container(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(width: 500, height: 600),
                    isFixed: true,
                    // width: 500,
                    // height: 600,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                    isFixed: true,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                    isFixed: true,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    isFixed: true,
                    x: 200,
                    y: 200,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Un Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    x: 200,
                    y: 200,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Custome Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y Top'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    x: 200,
                    y: 200,
                  ).keyboardEventCallBack = (shower, isKeyboardShow) {
                    PageOfKeyboardView.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
                  };
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y Bottom'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(height: 300),
                    x: 200,
                    y: 200,
                  ).keyboardEventCallBack = (shower, isKeyboardShow) {
                    PageOfKeyboardView.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
                  };
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Keyboard Widgets: '),
              CupertinoButton(
                child: const Text('Show Invisible'),
                onPressed: () {
                  DialogWrapper.show(
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _getEditBox(width: 500, height: 300),
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
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show Visible'),
                onPressed: () {
                  DialogWrapper.show(
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _getEditBox(width: 500, height: 300),
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
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Keyboard Rebuilder Widget'),
                onPressed: () {
                  DialogWrapper.show(
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _getEditBox(width: 500, height: 100),
                          KeyboardRebuildWidget(
                            builder: (BuildContext context, bool isKeyboardVisible) {
                              return Container(
                                color: Colors.yellow,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(isKeyboardVisible ? '>>>>>Keyboard is Visible<<<<<' : '***Keyboard is Invisible***'),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    width: 500,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getEditBox({double width = 500, double height = 600}) {
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
