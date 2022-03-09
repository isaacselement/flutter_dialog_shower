import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/view/bubble_widgets.dart';
import 'package:flutter_dialog_shower/view/selectable_list_widget.dart';

import '../util/logger.dart';
import 'widgets/cc_widgets.dart';

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
            WidgetsUtil.newXpelTextButton('Show on My Bottom', onPressedState: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getMenuBubble(
                    direction: TriangleArrowDirection.top,
                  ),
                  x: offset.dx,
                  y: offset.dy + size.height);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Top', onPressedState: (state) {
              // caculate the x & y by your selft here, ensure x >= 0 && y >= 0. I'm just messing around here.
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              // DialogShower shower = DialogWrapper.show(
              //     Container(
              //       width: 242,
              //       height: 60,
              //       child: Stack(
              //         clipBehavior: Clip.none,
              //         children: [
              //           Positioned(
              //             top: -100,
              //             child: WidgetsUtil.getMenuBubble(
              //               direction: TriangleArrowDirection.bottom,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     x: offset.dx - (242 - size.width) / 2,
              //     y: offset.dy - 60);

              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getMenuBubble(
                    direction: TriangleArrowDirection.bottom,
                  ),
                  x: offset.dx - (242 - size.width) / 2,
                  y: offset.dy - 161);

              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Left', onPressedState: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getMenuBubble(
                    direction: TriangleArrowDirection.right,
                    triangleOffset: 30.0,
                  ),
                  x: offset.dx - CcMenuPopup.currentMenuPopupWidth,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Right', onPressedState: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.getMenuBubble(
                    direction: TriangleArrowDirection.left,
                    triangleOffset: 30.0,
                  ),
                  x: offset.dx + size.width,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show bubble on Dialog', onPressed: () {
              DialogWrapper.show(WidgetsUtil.newClickMeWidget(fnClickMe: (context) {
                Offset position = OffsetUtil.getOffsetB(context) ?? Offset.zero;
                Size size = SizeUtil.getSizeB(context) ?? Size.zero;
                DialogWrapper.show(
                  BubbleWidget(
                    width: 200,
                    height: 200,
                    bubbleTriangleOffset: 20.0,
                    triangleDirection: TriangleArrowDirection.top,
                    child: SelectableListWidget(
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
              }));
            }),
          ],
        )
      ],
    );
  }
}
