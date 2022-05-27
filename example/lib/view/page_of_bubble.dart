import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';
import 'package:flutter_dialog_shower/view/cc_basic_widgets.dart';

import '../util/logger.dart';
import 'widgets/xp_widgets.dart';

class PageOfBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBubble] ----------->>>>>>>>>>>> build/rebuild!!!");

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
          WidgetsUtil.newHeaderWithGradient('Bubble in shower. Shower in shower'),
          const SizedBox(height: 16),
          buildButtonsAboutBubble(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutBubble() {
    void showBubble(State state, {required Widget child}) {
      Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
      Size size = SizeUtil.getSizeS(state) ?? Size.zero;
      double x = offset.dx;
      double y = offset.dy + size.height;
      DialogShower shower = DialogWrapper.show(child, x: x, y: y);
      shower.transitionBuilder = null;
      shower.containerDecoration = null;
    }

    return Column(
      children: [
        const SizedBox(height: 50),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Arrow None', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orangeAccent, child: SizedBox(width: 200, height: 200)),
                    bubbleShadowColor: Colors.purpleAccent,
                    bubbleTriangleDirection: CcBubbleArrowDirection.none,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Top', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.top,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Right', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.black,
                    bubbleTriangleDirection: CcBubbleArrowDirection.right,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Bottom', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.bottom,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Left', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.left,
                  ));
            }),
          ],
        ),
        const SizedBox(height: 50),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Arrow on topRight', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.topRight,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on bottomRight', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.bottomRight,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on bottomLeft', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.bottomLeft,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on topLeft', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.topLeft,
                  ));
            }),
          ],
        ),
        const SizedBox(height: 50),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Arrow on Top with translation', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.orange,
                    bubbleTriangleDirection: CcBubbleArrowDirection.top,
                    bubbleTriangleTranslation: 12,
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Top with arrow point', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.orange, child: SizedBox(width: 200, height: 200)),
                    bubbleColor: Colors.red,
                    bubbleTriangleDirection: CcBubbleArrowDirection.top,
                    bubbleTriangleLength: 20,
                    bubbleTrianglePointOffset: const Offset(10, -50),
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Left with arrow point', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.transparent, child: SizedBox(width: 200, height: 200)),
                    bubbleTriangleDirection: CcBubbleArrowDirection.left,
                    bubbleTriangleLength: 50,
                    bubbleTrianglePointOffset: const Offset(-50, 30),
                  ));
            }),
            WidgetsUtil.newXpelTextButton('Arrow on Left reverse direction', onPressed: (state) {
              showBubble(state,
                  child: CcBubbleWidget(
                    child: const ColoredBox(color: Colors.transparent, child: SizedBox(width: 200, height: 200)),
                    bubbleTriangleDirection: CcBubbleArrowDirection.left,
                    bubbleTriangleLength: 50,
                    bubbleTrianglePointOffset: const Offset(100, -25),
                    isTriangleOccupiedSpace: false,
                  ));
            }),
          ],
        ),
        const SizedBox(height: 50),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show on My Bottom', onPressed: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getBubblePicker(
                    direction: CcBubbleArrowDirection.top,
                  ),
                  x: offset.dx - (242 - size.width) / 2,
                  y: offset.dy + size.height);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Top', onPressed: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getBubblePicker(
                    direction: CcBubbleArrowDirection.bottom,
                  ),
                  x: offset.dx - (242 - size.width) / 2,
                  y: offset.dy - 161);

              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Left', onPressed: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getBubblePicker(
                    direction: CcBubbleArrowDirection.right,
                    bubbleTriangleTranslation: 35.0,
                  ),
                  x: offset.dx - 242,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Right', onPressed: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getBubblePicker(
                    direction: CcBubbleArrowDirection.left,
                    bubbleTriangleTranslation: 100.0,
                  ),
                  x: offset.dx + size.width,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
          ],
        ),
        const SizedBox(height: 50),
        Wrap(
          children: [
            CcTapWidget(
              child: const Icon(Icons.info, color: Colors.blue),
              onTap: (state) {
                Offset position = OffsetUtil.getOffsetS(state) ?? Offset.zero;
                Size size = SizeUtil.getSizeS(state) ?? Size.zero;
                TipsUtil.showTips(
                  'You know that ~~~~~~~~~~~~~~~~~~!!!!!',
                  x: position.dx + size.width,
                  y: position.dy - 8,
                );
              },
            ),
            WidgetsUtil.newXpelTextButton('Show bubble on Dialog', onPressed: (state) {
              DialogShower shower = DialogWrapper.showRight(BubbleSliderWidget(), width: 604);
              shower.padding = const EdgeInsets.only(right: 0);
              shower
                ..containerBoxShadow = []
                ..containerBorderRadius = 8.0
                ..barrierColor = const Color(0x4D1C1D21)
                ..dismissCallBack = (shower) {};
            }),
          ],
        ),
      ],
    );
  }
}

class BubbleSliderWidget extends StatelessWidget {
  Btv<bool> isResetButtonDisable = true.btv;
  Btv<String> selectCountryValue = ''.btv;

  BubbleSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        CcActionHeaderWidget()
          ..title = 'LayerLinker'
          ..height = 40
          ..titleStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
          ..leftButtonPadding = const EdgeInsets.only(top: 2, bottom: 2, left: 8)
          ..leftButtonBuilder = () {
            return XpTextButton(
              'Back',
              width: 200,
              height: 50,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              borderColor: const Color(0xFFDADAE8),
              backgroundColor: Colors.redAccent,
              textStyleBuilder: (text, isTappingDown) {
                Color color = Colors.white;
                color = isTappingDown ? color.withAlpha(128) : color;
                return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
              },
              onPressed: (state) {
                DialogWrapper.dismissTopDialog();
              },
            );
          }
          ..rightButtonPadding = const EdgeInsets.only(top: 2, bottom: 2, right: 8)
          ..rightButtonBuilder = () {
            return XpTextButton(
              'Done',
              width: 200,
              height: 54,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              borderColor: const Color(0xFFDADAE8),
              backgroundColor: Colors.lightBlue,
              textStyleBuilder: (text, isTappingDown) {
                Color color = Colors.white;
                color = isTappingDown ? color.withAlpha(128) : color;
                return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
              },
              onPressed: (state) {
                isResetButtonDisable.value = !isResetButtonDisable.value;
              },
            );
          },
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
            child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      CcTapWidget(
                        onTap: (state) {
                          Offset position = OffsetUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizeUtil.getSizeS(state) ?? Size.zero;
                          TipsUtil.showTips(
                            'You know that ~~~~~~~~~~~~\n HahuaHuHuaHaHua~~~~~~~ \n I don\'t know that !',
                            x: position.dx + size.width,
                            y: position.dy - 25,
                          );
                        },
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 150),
                      getOneSelectWidget(
                        title: 'Country: ',
                        btValue: selectCountryValue,
                        onTap: (state) {
                          Offset position = OffsetUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizeUtil.getSizeS(state) ?? Size.zero;
                          DialogWrapper.show(
                            CcBubbleWidget(
                              bubbleTriangleTranslation: 20.0,
                              bubbleTriangleDirection: CcBubbleArrowDirection.top,
                              child: CcSelectListWidget(
                                values: const [
                                  'India',
                                  'UK',
                                  'USA',
                                  'Russia',
                                  'Korea',
                                  'Mexico',
                                  'Italy',
                                  'Japan',
                                  'Ukraine',
                                  'Germany',
                                ],
                                onSelectedEvent: (state, index, value, values) {
                                  selectCountryValue.value = value as String;
                                  DialogWrapper.dismissTopDialog();
                                },
                              ),
                            ),
                            x: position.dx,
                            y: position.dy + size.height + 5,
                            width: size.width,
                            height: size.width,
                          )
                            // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                            ..containerDecoration = null // BubbleWidget already has the shadow
                            ..transitionBuilder = null
                            ..barrierDismissible = true;
                        },
                      ),
                      const SizedBox(height: 300),
                      getOneSelectWidget(
                        title: 'Country: ',
                        btValue: selectCountryValue,
                        onTap: (state) {
                          Offset position = OffsetUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizeUtil.getSizeS(state) ?? Size.zero;
                          DialogWrapper.show(
                            CcBubbleWidget(
                              bubbleTriangleTranslation: size.width - 40,
                              bubbleTriangleDirection: CcBubbleArrowDirection.bottom,
                              child: CcSelectListWidget(
                                values: const [
                                  'India',
                                  'UK',
                                  'USA',
                                  'Russia',
                                  'Korea',
                                  'Mexico',
                                  'Italy',
                                  'Japan',
                                  'Ukraine',
                                  'Germany',
                                ],
                                onSelectedEvent: (state, index, value, values) {
                                  selectCountryValue.value = value as String;
                                  DialogWrapper.dismissTopDialog();
                                },
                              ),
                            ),
                            x: position.dx,
                            y: position.dy - size.width - 5,
                            width: size.width,
                            height: size.width,
                          )
                            // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                            ..containerDecoration = null // BubbleWidget already has the shadow
                            ..transitionBuilder = null
                            ..barrierDismissible = true;
                        },
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  Btw(builder: (context) {
                    return XpTextButton(
                      'Reset',
                      width: 200,
                      height: 40,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      borderColor: const Color(0xFFDADAE8),
                      isDisable: isResetButtonDisable.value,
                      backgroundColor: null,
                      backgroundColorDisable: const Color(0xFFF5F5FA),
                      textStyleBuilder: (text, isTappingDown) {
                        if (isResetButtonDisable.value) {
                          return const TextStyle(color: Color(0xFFBFBFD2), fontSize: 16);
                        }
                        Color color = const Color(0xFF1C1D21);
                        return TextStyle(color: isTappingDown ? color.withAlpha(128) : color, fontSize: 16);
                      },
                      onPressed: (state) {},
                    );
                  }),
                  const SizedBox(width: 14),
                  XpTextButton(
                    'Save',
                    width: 200,
                    height: 40,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    borderColor: const Color(0xFFDADAE8),
                    textStyleBuilder: (text, isTappingDown) {
                      Color color = Colors.white;
                      color = isTappingDown ? color.withAlpha(128) : color;
                      return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
                    },
                    onPressed: (state) {
                      isResetButtonDisable.value = !isResetButtonDisable.value;
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget getOneSelectWidget({required String title, required Btv<String> btValue, required void Function(State state) onTap}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CcTapWidget(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Btw(
                      builder: (context) => Text(
                        btValue.value.isEmpty ? 'Select' : btValue.value,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  const Icon(Icons.select_all)
                ],
              ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class TipsUtil {
  static void showTips(
    String text, {
    required double x,
    required double y,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    Duration? onScreenDuration = const Duration(milliseconds: 2000),
  }) {
    OverlayWidgets.show(
      onScreenDuration: onScreenDuration,
      child: getBubbleTipsWidget(
        text: text,
        direction: direction,
        bubbleTriangleTranslation: bubbleTriangleTranslation,
      ),
    )
      ..alignment = Alignment.topLeft
      ..padding = EdgeInsets.only(left: x, top: y);
  }

  static Widget getBubbleTipsWidget({
    required String text,
    double? bubbleRadius,
    Color? bubbleColor,
    Color? bubbleShadowColor,
    double? bubbleTriangleLength,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    EdgeInsets? padding = const EdgeInsets.only(left: 19, right: 19, top: 11, bottom: 11),
    TextAlign? textAlign = TextAlign.left,
    TextStyle? textStyle = const TextStyle(color: Colors.white),
  }) {
    bubbleTriangleLength ??= 12.0;
    Offset bubbleTrianglePointOffset = Offset(-8.0, -bubbleTriangleLength / 2);
    if (direction == CcBubbleArrowDirection.left) {
      bubbleTrianglePointOffset = Offset(-8.0, -bubbleTriangleLength / 2);
    } else if (direction == CcBubbleArrowDirection.top) {
      bubbleTrianglePointOffset = Offset(bubbleTriangleLength / 2, -8.0);
    } else if (direction == CcBubbleArrowDirection.right) {
      bubbleTrianglePointOffset = Offset(8.0, bubbleTriangleLength / 2);
    } else if (direction == CcBubbleArrowDirection.bottom) {
      bubbleTrianglePointOffset = Offset(-bubbleTriangleLength / 2, 8.0);
    }
    return CcBubbleWidget(
      bubbleTriangleDirection: direction,
      bubbleTriangleLength: bubbleTriangleLength,
      bubbleTrianglePointOffset: bubbleTrianglePointOffset,
      bubbleTriangleTranslation: bubbleTriangleTranslation,
      bubbleColor: bubbleColor ?? const Color(0xFF1C1D21),
      bubbleShadowColor: bubbleShadowColor,
      bubbleRadius: bubbleRadius ?? 6.0,
      child: Container(
        padding: padding,
        child: Text(text, style: textStyle, textAlign: textAlign),
      ),
    );
  }
}
