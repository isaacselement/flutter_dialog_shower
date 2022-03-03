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

class PageOfBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBubble] ----------->>>>>>>>>>>> build/rebuild!!!");
    return SingleChildScrollView(child: buildContainer());
  }

  Widget buildContainer() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            WidgetsUtil.newHeaderWithGradient('Bubble in shower. Shower in shower'),
            const SizedBox(height: 8),
            buildButtonsAboutBubble(),
            const SizedBox(height: 64),
          ],
        ));
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
              DialogWrapper.show(WidgetsUtil.newClickMeWidget(fnClickMe: (context) {
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
}
