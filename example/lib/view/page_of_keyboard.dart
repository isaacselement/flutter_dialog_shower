import 'dart:async';

import 'package:example/util/insets_util.dart';
import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfKeyboard extends StatelessWidget {
  const PageOfKeyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfKeyboard] ----------->>>>>>>>>>>> build/rebuild!!!");

    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
            return SingleChildScrollView(child: buildContainer());
          },
        );
      },
    );
  }

  Widget buildContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          WidgetsUtil.newHeaderWithGradient('You can tap the edit box to see the behaviour when keyboard showed'),
          const SizedBox(height: 16),
          buildButtonsAboutKeyboard(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutKeyboard() {
    return Column(
      children: [
        WidgetsUtil.newHeaderWithLine('Fixed position: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox(width: 500, height: 600), fixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: (state) {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox(), fixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: (state) {
              DialogWrapper.showRight(WidgetsUtil.newEditBox(), fixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox(), fixed: true, x: 20, y: 40);
            }),
          ],
        ),
        const SizedBox(height: 16),
        WidgetsUtil.newHeaderWithLine('Unfixed Position: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: (state) {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: (state) {
              DialogWrapper.showRight(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox(), x: 20, y: 40).keyboardEventCallBack = (shower, isKeyboardShow) {
                shower.setState(() {
                  shower.padding = isKeyboardShow ? const EdgeInsets.only(left: 200) : const EdgeInsets.only(left: 200, top: 200);
                });
              };
            }),
          ],
        ),
        const SizedBox(height: 16),
        WidgetsUtil.newHeaderWithLine('Custome Position: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox()).obj = flagStickToTopGlobalSetting;
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: (state) {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox()).obj = flagStickToTopGlobalSetting;
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: (state) {
              DialogWrapper.showRight(WidgetsUtil.newEditBox()).keyboardEventCallBack = (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Top', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox(), x: 20, y: 40).keyboardEventCallBack = (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Bottom 1', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newEditBox(width: 400, height: 100), x: 20, y: 40).keyboardEventCallBack =
                  (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Bottom 2', onPressed: (state) {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetsUtil.newEditBox(width: 400, height: 100),
                      Container(
                        color: Colors.yellow,
                        height: 100,
                        width: 400,
                        alignment: Alignment.center,
                        child: const Text('I will be stick bottom when keyboard show up'),
                      )
                    ],
                  ),
                ),
                x: 20,
                y: 40,
              ).keyboardEventCallBack = (shower, isKeyboardShow) {
                Future.delayed(isKeyboardShow ? const Duration(milliseconds: 200) : const Duration(milliseconds: 50), () {
                  InsetsUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow, bottom: 0);
                });
              };
            }),
          ],
        ),
        const SizedBox(height: 16),
        WidgetsUtil.newHeaderWithLine('Keyboard Responsive Widgets: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show Invisible', onPressed: (state) {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetsUtil.newEditBox(width: 500, height: 300),
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
            WidgetsUtil.newXpelTextButton('Show Visible', onPressed: (state) {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetsUtil.newEditBox(width: 500, height: 300),
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
            WidgetsUtil.newXpelTextButton('Rebuilder Widget', onPressed: (state) {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetsUtil.newEditBox(width: 500, height: 100),
                      KeyboardRebuildWidget(
                        builder: (BuildContext context, bool isKeyboardVisible) {
                          return Container(
                            color: Colors.yellow,
                            height: 100,
                            alignment: Alignment.center,
                            child:
                                Text(!isKeyboardVisible ? '>>>>>Text will rebuild on keyboard showed<<<<<' : '***Text is changed :)***'),
                          );
                        },
                      )
                    ],
                  ),
                ),
                width: 500,
              );
            }),
            WidgetsUtil.newXpelTextButton('Visibility Builder', onPressed: (state) {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetsUtil.newEditBox(width: 500, height: 100),
                      KeyboardVisibilityBuilder(
                        builder: (BuildContext context, bool isKeyboardVisible) {
                          return Container(
                            color: Colors.yellow,
                            height: 100,
                            alignment: Alignment.center,
                            child: Text(!isKeyboardVisible
                                ? '>>>>>Text will rebuild according by keyboard visibility<<<<<'
                                : '***isKeyboardVisible is $isKeyboardVisible :)***'),
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
  static double getMaxWidth4Texts(List<String> texts, TextStyle style) {
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

  /// for keyboard manually amendment
  static bool isInited = false;

  static Object flagStickToTopGlobalSetting = Object();

  static void ensureInited() {
    Logger.d('PageOfInfoView ensureInited---> $isInited');
    if (isInited) {
      return;
    }
    isInited = !isInited;
    // set up appearence for keyboard showed up in one place
    KeyboardEventListener.listen((isKeyboardShow) {
      Logger.d('PageOfInfoView 【keyboard visibility】---> isKeyboardShow: $isKeyboardShow');
      DialogShower? topDialog = DialogWrapper.getTopDialog();
      if (topDialog != null) {
        DialogShower shower = topDialog;
        if ((shower.obj == flagStickToTopGlobalSetting || shower.obj is List) && (shower.keyboardEventCallBack == null)) {
          Logger.d('PageOfInfoView 【keyboard visibility】---> come in ...');
          InsetsUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
        }
      }
    });
    // streamSubscription.cancel();   // need to cancel by yourself
  }
}
