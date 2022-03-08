import 'dart:async';

import 'package:example/util/insets_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/event/keyboard_event_listener.dart';
import 'package:flutter_dialog_shower/view/keyboard_widgets.dart';
import 'package:flutter_dialog_shower/view/selectable_list_widget.dart';

import '../util/logger.dart';

class PageOfKeyboard extends StatelessWidget {
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
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox(width: 500, height: 600), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: () {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox(), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: () {
              DialogWrapper.showRight(WidgetsUtil.newEditBox(), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox(), isFixed: true, x: 20, y: 40);
            }),
          ],
        ),
        const SizedBox(height: 16),
        WidgetsUtil.newHeaderWithLine('Unfixed Position: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: () {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: () {
              DialogWrapper.showRight(WidgetsUtil.newEditBox());
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox(), x: 20, y: 40).keyboardEventCallBack = (shower, isKeyboardShow) {
                shower.setState(() {
                  shower.margin = isKeyboardShow ? const EdgeInsets.only(left: 200) : const EdgeInsets.only(left: 200, top: 200);
                });
              };
            }),
          ],
        ),
        const SizedBox(height: 16),
        WidgetsUtil.newHeaderWithLine('Custome Positione: '),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox()).obj = flagStickToTopGlobalSetting;
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: () {
              DialogWrapper.showLeft(WidgetsUtil.newEditBox()).obj = flagStickToTopGlobalSetting;
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: () {
              DialogWrapper.showRight(WidgetsUtil.newEditBox()).keyboardEventCallBack = (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Top', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox(), x: 20, y: 40).keyboardEventCallBack = (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Bottom 1', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newEditBox(width: 400, height: 100), x: 20, y: 40).keyboardEventCallBack =
                  (shower, isKeyboardShow) {
                InsetsUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
              };
            }),
            WidgetsUtil.newXpelTextButton('x/y Stick Bottom 2', onPressed: () {
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
            WidgetsUtil.newXpelTextButton('Show Invisible', onPressed: () {
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
            WidgetsUtil.newXpelTextButton('Show Visible', onPressed: () {
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
            WidgetsUtil.newXpelTextButton('Rebuilder Widget', onPressed: () {
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
          ],
        ),
      ],
    );
  }

  /// Static Methods

  static void showCitiesOnClick(SelectableListState state, int index, Object value, List<Object>? selectedValues) {
    if (value is! Map) {
      return;
    }
    if (value['children'] == null || value['children']!.isEmpty) {
      DialogWrapper.getTopNavigatorDialog()!.getNavigator()!.popUntil((route) => route.settings.name == '__root_route__');
      DialogWrapper.pop();
      return;
    }
    DialogWrapper.push(getSelectableListWidget(value));
  }

  static SelectableListWidget getSelectableListWidget(Object value) {
    return SelectableListWidget(
      title: 'Select The City',
      values: ((value is Map ? value['children'] : value) as List<dynamic>).cast(),
      functionOfName: (s, i, e) => e is Map ? e['areaName'] : '',
      isSearchEnable: true,
      leftButtonEvent: (state) {
        DialogWrapper.pop();
      },
      itemSuffixBuilder: (state, index, value) {
        if (value is Map && value['children'] != null && value['children']!.isNotEmpty) {
          return const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
        }
        return null;
      },
      onSelectedEvent: showCitiesOnClick,
    );
  }

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
    StreamSubscription streamSubscription = KeyboardEventListener.listen((isKeyboardShow) {
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
