import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

import '../util/logger.dart';

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
    return Column(
      children: [
        const SizedBox(height: 100),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show on My Bottom', onPressed: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getBubbleMenuPicker(
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
                  WidgetsUtil.getBubbleMenuPicker(
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
                  WidgetsUtil.getBubbleMenuPicker(
                    direction: CcBubbleArrowDirection.right,
                    triangleOffset: 35.0,
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
                  WidgetsUtil.getBubbleMenuPicker(
                    direction: CcBubbleArrowDirection.left,
                    triangleOffset: 35.0,
                  ),
                  x: offset.dx + size.width,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),

            /// TODO ........
            WidgetsUtil.newXpelTextButton('Show bubble on Dialog', onPressed: (state) {
              DialogWrapper.show(WidgetsUtil.newClickMeWidget(clickMeFunctions: {
                'Click me': (context) {
                  Offset position = OffsetUtil.getOffsetB(context) ?? Offset.zero;
                  Size size = SizeUtil.getSizeB(context) ?? Size.zero;
                  DialogWrapper.show(
                    CcBubbleWidget(
                      width: 200,
                      height: 200,
                      bubbleTriangleOffset: 20.0,
                      triangleDirection: CcBubbleArrowDirection.top,
                      child: CcSelectListWidget(
                        values: const ['1', '2', '3', '4', '5'],
                      ),
                    ),
                    x: position.dx,
                    y: position.dy + size.height,
                  )
                    ..containerDecoration = null // BubbleWidget already has the shadow
                    // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                    ..transitionBuilder = null
                    ..barrierDismissible = true;
                }
              }));
            }),
          ],
        )
      ],
    );
  }
}
