// ignore_for_file: must_be_immutable

import 'package:example/util/logger.dart';
import 'package:example/util/toast_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfBubble extends StatelessWidget {
  const PageOfBubble({Key? key}) : super(key: key);

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
      Offset offset = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
      Size size = SizesUtil.getSizeS(state) ?? Size.zero;
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
              Offset offset = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizesUtil.getSizeS(state) ?? Size.zero;
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
              Offset offset = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizesUtil.getSizeS(state) ?? Size.zero;
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
              Offset offset = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
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
              Offset offset = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizesUtil.getSizeS(state) ?? Size.zero;
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
              child: Container(color: Colors.white, width: 30, height: 60, child: const Icon(Icons.info, color: Colors.grey)),
              onTap: (state) {
                Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
                Size size = SizesUtil.getSizeS(state) ?? Size.zero;
                ToastUtil.showWithArrow(
                  'You know that ~~~~~~~~~~~~~~~~~~!!!!!',
                  x: position.dx + size.width,
                  y: position.dy + (size.height - 40) / 2, // 40 is the height of tips
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
