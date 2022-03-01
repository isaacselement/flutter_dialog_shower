import 'dart:async';

import 'package:example/util/position_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/event/keyboard_event_listener.dart';
import 'package:flutter_dialog_shower/view/bubble_widgets.dart';
import 'package:flutter_dialog_shower/view/keyboard_widgets.dart';
import 'package:flutter_dialog_shower/view/selectable_list_widget.dart';

import '../util/logger.dart';

class PageOfKeyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfKeyboard] ----------->>>>>>>>>>>> build/rebuild!!!");
    PageOfKeyboard.ensureInited();
    return SingleChildScrollView(child: buildContainer());
  }

  Widget buildContainer() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            getHeaderWidget('You can tap the edit box to see the behaviour when keyboard showed'),
            const SizedBox(height: 8),
            buildButtonsAboutKeyboard(),
            const SizedBox(height: 64),
            getHeaderWidget('Bubble in shower. Shower in shower'),
            const SizedBox(height: 8),
            buildButtonsAboutBubble(),
            const SizedBox(height: 64),
          ],
        ));
  }

  Widget buildButtonsAboutKeyboard() {
    List<String> titles = ['Positioned: ', 'Un Positioned: ', 'Custome Positioned: ', 'Keyboard Widgets: '];
    TextStyle titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    double maxTitleWidth = getMaxWidth4Texts(titles, titleStyle);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[0], style: titleStyle)),
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              DialogWrapper.show(getEditBoxWidget(width: 500, height: 600), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: () {
              DialogWrapper.showLeft(getEditBoxWidget(), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: () {
              DialogWrapper.showRight(getEditBoxWidget(), isFixed: true);
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: () {
              DialogWrapper.show(
                getEditBoxWidget(),
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
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              DialogWrapper.show(getEditBoxWidget());
            }),
            WidgetsUtil.newXpelTextButton('Show left', onPressed: () {
              DialogWrapper.showLeft(getEditBoxWidget());
            }),
            WidgetsUtil.newXpelTextButton('Show right', onPressed: () {
              DialogWrapper.showRight(getEditBoxWidget());
            }),
            WidgetsUtil.newXpelTextButton('Show x/y', onPressed: () {
              DialogWrapper.show(getEditBoxWidget(), x: 200, y: 200).keyboardEventCallBack = (shower, isKeyboardShow) {
                shower.setState(() {
                  shower.margin = isKeyboardShow ? const EdgeInsets.only(left: 200) : const EdgeInsets.only(left: 200, top: 200);
                });
              };
            }),
          ],
        ),
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[2], style: titleStyle)),
            Expanded(
              child: Wrap(
                children: [
                  WidgetsUtil.newXpelTextButton('Show center', isSmallest: true, onPressed: () {
                    DialogWrapper.show(getEditBoxWidget()).obj = flagStickToTopGlobalSetting;
                  }),
                  WidgetsUtil.newXpelTextButton('Show left', isSmallest: true, onPressed: () {
                    DialogWrapper.showLeft(getEditBoxWidget()).obj = flagStickToTopGlobalSetting;
                  }),
                  WidgetsUtil.newXpelTextButton('Show right', isSmallest: true, onPressed: () {
                    DialogWrapper.showRight(getEditBoxWidget()).keyboardEventCallBack = (shower, isKeyboardShow) {
                      PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
                    };
                  }),
                  WidgetsUtil.newXpelTextButton('x/y Stick Top', isSmallest: true, onPressed: () {
                    DialogWrapper.show(
                      getEditBoxWidget(),
                      x: 200,
                      y: 200,
                    ).keyboardEventCallBack = (shower, isKeyboardShow) {
                      PositionUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
                    };
                  }),
                  WidgetsUtil.newXpelTextButton('x/y Stick Bottom', isSmallest: true, onPressed: () {
                    DialogWrapper.show(
                      getEditBoxWidget(width: 500, height: 300),
                      x: 200,
                      y: 200,
                    ).keyboardEventCallBack = (shower, isKeyboardShow) {
                      PositionUtil.rebuildShowerPositionBottomOnKeyboardEvent(shower, isKeyboardShow);
                    };
                  }),
                  WidgetsUtil.newXpelTextButton('x/y Stick Bottom', isSmallest: true, onPressed: () {
                    DialogWrapper.show(
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            getEditBoxWidget(width: 500, height: 300),
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
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: maxTitleWidth, child: Text(titles[3], style: titleStyle)),
            WidgetsUtil.newXpelTextButton('Show Invisible', onPressed: () {
              DialogWrapper.show(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      getEditBoxWidget(width: 500, height: 300),
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
                      getEditBoxWidget(width: 500, height: 300),
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
                      getEditBoxWidget(width: 500, height: 100),
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

  Widget buildButtonsAboutBubble() {
    return Column(
      children: [
        Row(
          children: [
            WidgetsUtil.newXpelTextButton('Show bubble', onPressed: () {
              DialogShower shower = DialogWrapper.show(BubbleWidget(
                width: 200,
                height: 200,
                child: SelectableListWidget(
                  values: const ['1', '2', '3', '4', '5'],
                ),
              ));
              shower.containerDecoration = null;
              // shower.containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
            }),
            WidgetsUtil.newXpelTextButton('Show bubble on Dialog', onPressed: () {
              DialogWrapper.show(getClickMeWidget(fnClickMe: (context) {
                RenderBox renderBox = context.findRenderObject()! as RenderBox;
                Offset position = renderBox.localToGlobal(Offset.zero);
                Size size = renderBox.size;
                DialogWrapper.show(
                  BubbleWidget(
                    width: 200,
                    height: 200,
                    triangleDirection: TriangleArrowDirection.top,
                    bubbleTriangleOffset: 20.0,
                    child: SelectableListWidget(
                      values: const ['1', '2', '3', '4', '5'],
                    ),
                  ),
                  x: position.dx,
                  y: position.dy + size.height,
                )
                  ..containerDecoration = null
                  ..transitionBuilder = null
                  ..barrierDismissible = true;
              }));
            }),
          ],
        )
      ],
    );
  }

  /// Static Methods

  static Column getClickMeWidget({required Function(BuildContext context) fnClickMe}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // as small as possible
      children: [
        CupertinoButton(
          child: const Text('Dismiss'),
          onPressed: () {
            DialogWrapper.dismissTopDialog();
          },
        ),
        Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: LayoutBuilder(builder: (context, constraints) {
            return CupertinoButton(
              child: const Text('Click me'),
              onPressed: () {
                fnClickMe.call(context);
              },
            );
          }),
        ),
        Container(
          width: 400,
          height: 500,
          color: Colors.yellow,
          child: const Center(child: Text('I\'m the place holder for more space :P')),
        ),
      ],
    );
  }

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

  static Widget getHeaderWidget(String titleText) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.25, 0.25, 0.5, 0.5, 0.75, 0.75, 1],
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFF8181A5),
            Color(0xFF8181A5),
            Color(0xFF8181A5),
            Color(0xFF8181A5),
            Color(0xFF8181A5),
            Color(0xFF8181A5),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Text(
        titleText,
        style: const TextStyle(fontSize: 16, color: Colors.white, overflow: TextOverflow.ellipsis, shadows: <Shadow>[
          Shadow(offset: Offset(3.0, 3.0), blurRadius: 2.0, color: Color.fromARGB(255, 0, 0, 0)),
          Shadow(offset: Offset(5.0, 5.0), blurRadius: 8.0, color: Color.fromARGB(125, 177, 239, 83)),
        ]),
      ),
    );
  }

  static Widget getEditBoxWidget({double width = 500, double height = 600}) {
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
          PositionUtil.rebuildShowerPositionTopOnKeyboardEvent(shower, isKeyboardShow);
        }
      }
    });
    // streamSubscription.cancel();   // need to cancel by yourself
  }
}
