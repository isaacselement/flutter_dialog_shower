import 'package:example/util/size_util.dart';
import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/view/bubble_widgets.dart';

import 'offset_util.dart';

class WidgetsUtil {
  static get _editorBoxWidth => 400 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 400.toDouble();

  static get _editorBoxHeight => 300 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 300.toDouble();

  static TextStyle getTextStyleWithPassionOne({required double fontSize, Color fontColor = Colors.black}) {
    return TextStyle(fontSize: fontSize, color: fontColor, fontFamily: 'PassionOne-Regular');
  }

  static TextStyle getTextStyleWithPacifico({required double fontSize, Color fontColor = Colors.black}) {
    return TextStyle(fontSize: fontSize, color: fontColor, fontFamily: 'Pacifico-Regular');
  }

  static XpTextButton newXpelTextButton(String text, {void Function()? onPressed, void Function(State state)? onPressedState}) {
    return XpTextButton(
      text,
      onPressed: (state) {
        onPressed?.call();
        onPressedState?.call(state);
      },
      decorationBuilder: ThemesManager.builderXpButtonDecoration,
    );
  }

  static Widget newEditBotxWithBottomTips({String? hint}) {
    TextStyle tipTopStyle = WidgetsUtil.getTextStyleWithPassionOne(fontSize: 18);
    TextStyle tipBottomStyle = WidgetsUtil.getTextStyleWithPacifico(fontSize: 14);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          newWidgetWithGradientBackground(
              child: Container(padding: const EdgeInsets.all(6), child: Text(hint ?? '', style: tipTopStyle))),
          WidgetsUtil.newEditBox(),
          newWidgetWithGradientBackground(
              child: Container(padding: const EdgeInsets.all(6), child: Text(hint ?? '', style: tipBottomStyle))),
        ],
      ),
    );
  }

  static Widget newEditBox({double? width, double? height}) {
    return Container(
      width: width ?? _editorBoxWidth,
      height: height ?? _editorBoxHeight,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      // decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField.borderless(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              padding: const EdgeInsets.all(6.0),
              placeholder: 'Click Here For Get Focus First ...',
              maxLines: 100,
              maxLength: 1000,
              onChanged: (str) {
                print('u enter text: $str');
              },
            )
          ],
        ),
      ),
    );
  }

  static Widget newWidgetWithGradientBackground({required Widget child}) {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 0.35, 0.5, 0.65, 1],
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFCD001),
            Color(0xFFFCD001),
            Color(0xFFFCD001),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: child,
    );
  }

  static Widget newHeaderWithGradient(String titleText) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
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
        maxLines: 8,
        style: const TextStyle(fontSize: 16, color: Colors.white, overflow: TextOverflow.ellipsis, shadows: <Shadow>[
          Shadow(offset: Offset(3.0, 3.0), blurRadius: 2.0, color: Color.fromARGB(255, 0, 0, 0)),
          Shadow(offset: Offset(5.0, 5.0), blurRadius: 8.0, color: Color.fromARGB(125, 177, 239, 83)),
        ]),
      ),
    );
  }

  static Widget newHeaderWithLine(String title) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.25, 0.5, 0.75, 1],
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0x888181A5),
                  Color(0xFF8181A5),
                  Color(0xAA8181A5),
                  Color(0xFF8181A5),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(title),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.25, 0.5, 0.75, 1],
                colors: [
                  Color(0xFF8181A5),
                  Color(0x888181A5),
                  Color(0xFF8181A5),
                  Color(0xAA8181A5),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget newDescptions(String desc, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0xFFF5F5FA)),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF8181A5))),
    );
  }

  static Column newClickMeWidget({required Function(BuildContext context) fnClickMe, String? text}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // as small as possible
      children: [
        WidgetsUtil.newXpelTextButton('Dismiss', onPressed: () {
          DialogWrapper.dismissTopDialog();
        }),
        LayoutBuilder(builder: (context, constraints) {
          return CupertinoButton(
            child: const Text('Click me'),
            onPressed: () {
              fnClickMe.call(context);
            },
          );
        }),
        SizedBox(width: 400, height: 400, child: Center(child: Text(text ?? ''))),
      ],
    );
  }

  /// Bubble Menus

  static Widget createMenuItem({required IconData icon, required String text, Function(BuildContext context)? onTap}) {
    Btv<bool> isHighlightedBtv = false.btv;
    return Btw(builder: (context) {
      return Listener(
        child: InkWell(
          child: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(color: isHighlightedBtv.value ? Colors.grey : Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 40.0, height: 40.0, child: Icon(icon, color: Colors.white, size: 30.0)),
                SizedBox(
                  height: 22.0,
                  child: Text(text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13)), //WidgetsUtil.getTextStyleWithPacifico(fontSize: 13, fontColor: Colors.white)),
                )
              ],
            ),
          ),
          onTap: () {
            onTap?.call(context);
          },
        ),
        onPointerDown: (event) {
          isHighlightedBtv.value = true;
        },
        onPointerUp: (event) {
          isHighlightedBtv.value = false;
        },
      );
    });
  }

  static Widget createMenuItems({
    required List<IconData> icons,
    required List<String> texts,
    Function(int index, String text, BuildContext context)? onTap,
  }) {
    assert(icons.length == texts.length, 'icons list length should be equals to texts list length');
    int size = icons.length;
    List<Widget> children = <Widget>[];
    for (int i = 0; i < size; i++) {
      String text = texts[i];
      children.add(createMenuItem(
          icon: icons[i],
          text: text,
          onTap: (context) {
            onTap?.call(i, text, context);
          }));
    }
    return Container(
      width: 242,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Wrap(spacing: 1.0, runSpacing: 1.0, children: children),
    );
  }

  static Widget createMenuBubble({TriangleArrowDirection triDirection = TriangleArrowDirection.left, double? triOffset}) {
    return BubbleWidget(
      width: 242,
      height: 161,
      bubbleColor: Colors.black,
      bubbleTriangleOffset: triOffset,
      triangleDirection: triDirection,
      child: createMenuItems(
          icons: [
            Icons.copy_sharp,
            Icons.home_sharp,
            Icons.mail_sharp,
            Icons.power_sharp,
            Icons.settings_sharp,
            Icons.menu_sharp,
          ],
          texts: [
            'Copy',
            'Home',
            'Mail',
            'Power',
            'Settings',
            'More',
          ],
          onTap: (index, text, context) {
            print('=========>>>>> you tap $index, title text is $text');
            if (text == 'More') {
              Offset offset = OffsetUtil.getOffsetB(context) ?? Offset.zero;
              Size size = SizeUtil.getSizeB(context) ?? Size.zero;
              double x = triDirection == TriangleArrowDirection.left ? offset.dx + size.width : offset.dx - 100;
              double y = triDirection == TriangleArrowDirection.left ? offset.dy - 20 : offset.dy + size.height;
              DialogShower shower = DialogWrapper.show(
                  WidgetsUtil.createMenuBubble(
                    triDirection: triDirection,
                    triOffset: triOffset,
                  ),
                  x: x,
                  y: y);
              shower.transitionBuilder = null;
              shower.containerDecoration = null;
            }
          }),
    );
  }
}
