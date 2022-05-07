import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

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
            WidgetsUtil.newXpelTextButton('Show bubble on Dialog', onPressed: (state) {
              Btv<bool> isDisable = true.btv;
              Widget container = Container(
                padding: const EdgeInsets.only(bottom: 16, top: 32, left: 32, right: 32),
                child: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          CcTapWidget(onTap: (state){

                          })

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
                          isDisable: isDisable.value,
                          backgroundColor: null,
                          backgroundColorDisable: const Color(0xFFF5F5FA),
                          textStyleBuilder: (text, isTappingDown) {
                            if (isDisable.value) {
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
                          isDisable.value = !isDisable.value;

                          Offset position = OffsetUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizeUtil.getSizeS(state) ?? Size.zero;
                          DialogWrapper.show(
                            CcBubbleWidget(
                              width: 200,
                              height: 200,
                              bubbleTriangleTranslation: 20.0,
                              bubbleTriangleDirection: CcBubbleArrowDirection.top,
                              child: CcSelectListWidget(
                                values: const ['1', '2', '3', '4', '5'],
                              ),
                            ),
                            x: position.dx,
                            y: position.dy - size.height,
                          )
                            // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                            ..containerDecoration = null // BubbleWidget already has the shadow
                            ..transitionBuilder = null
                            ..barrierDismissible = true;
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ]),
              );
              DialogShower shower = DialogWrapper.showRight(container, width: 604);
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
