import 'dart:async';

import 'package:example/util/insets_util.dart';
import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/event/keyboard_event_listener.dart';
import 'package:flutter_dialog_shower/view/bubble_widgets.dart';
import 'package:flutter_dialog_shower/view/keyboard_widgets.dart';
import 'package:flutter_dialog_shower/view/selectable_list_widget.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show on My Right', onPressedState: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.createMenuBubble(
                    triOffset: 30.0,
                  ),
                  x: offset.dx + size.width,
                  y: offset.dy - 20);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }),
            WidgetsUtil.newXpelTextButton('Show on My Bottom', onPressedState: (state) {
              Offset offset = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size size = SizeUtil.getSizeS(state) ?? Size.zero;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.createMenuBubble(
                    triDirection: TriangleArrowDirection.top,
                  ),
                  x: offset.dx - 20,
                  y: offset.dy + size.height);
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
