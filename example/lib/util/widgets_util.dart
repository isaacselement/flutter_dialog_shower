import 'package:example/util/logger.dart';
import 'package:example/util/size_util.dart';
import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/cc_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/dialog/dialog_shower.dart';
import 'package:flutter_dialog_shower/dialog/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/view/cc_bubble_widgets.dart';

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

  static CcTextButton newXpelTextButton(String text, {void Function(State state)? onPressed}) {
    return CcTextButton(
      text,
      onPressed: (state) {
        onPressed?.call(state);
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
                Logger.d('u enter text: $str');
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

  static Widget newDescriptions(String desc, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0xFFF5F5FA)),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF8181A5))),
    );
  }

  static Widget newClickMeWidget({
    required Map<String, Function(BuildContext context)> clickMeFunctions,
  }) {
    List<Widget> children = [];
    children.add(
      WidgetsUtil.newXpelTextButton('Dismiss', onPressed: (state) {
        DialogWrapper.dismissTopDialog();
      }),
    );

    List<Widget> clickMeWidgets = clickMeFunctions
        .map((key, value) {
          return MapEntry(key, LayoutBuilder(builder: (context, constraints) {
            return CupertinoButton(
              child: Text(key),
              onPressed: () {
                value.call(context);
              },
            );
          }));
        })
        .values
        .toList();
    children.addAll(clickMeWidgets);

    children.add(const SizedBox(width: 400, height: 400, child: Center(child: Text('Placeholder'))));
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // as small as possible
        children: children,
      ),
    );
  }

  /// Bubble Menus
  static Widget getMenuPicker({
    TriangleArrowDirection direction = TriangleArrowDirection.top,
    Function(int index, Object value, BuildContext context)? onTap,
  }) {
    return CcBubbleWidget(
      bubbleColor: Colors.black, // triangle color
      triangleDirection: direction,
      child: CcMenuPopup(
        popupBackGroundColor: Colors.green, // spacing line color
        values: const [
          [Icons.local_print_shop_sharp, 'Print'],
          [Icons.home_sharp, 'Home'],
          [Icons.mail_sharp, 'Mail'],
          [Icons.qr_code_sharp, 'QRCode'],
          [Icons.settings_sharp, 'Settings'],
          [Icons.menu_sharp, 'More'],
        ],
        onTap: (index, value, context) {
          Logger.d('👉👉👉>>>>> u tap index: $index, value: $value, toString(): ${value.toString()}');
          onTap?.call(index, value, context);
        },
      ),
    );
  }

  static Widget getMenuBubble({TriangleArrowDirection direction = TriangleArrowDirection.left, double? triangleOffset}) {
    return CcBubbleWidget(
      bubbleColor: Colors.black, // triangle color
      triangleDirection: direction,
      bubbleTriangleOffset: triangleOffset,
      child: CcMenuPopup(
        popupBackGroundColor: Colors.green, // spacing line color
        values: const [
          [Icons.local_print_shop_sharp, 'Print'],
          [Icons.home_sharp, 'Home'],
          [Icons.mail_sharp, 'Mail'],
          [Icons.qr_code_sharp, 'QRCode'],
          [Icons.settings_sharp, 'Settings'],
          [Icons.menu_sharp, 'More'],
        ],
        onTap: (index, value, context) {
          Logger.d('👉👉👉>>>>> u tap $index, value: $value, toString(): ${value.toString()}');
          if (value.toString().contains('More')) {
            Offset offset = OffsetUtil.getOffsetB(context) ?? Offset.zero;
            Size size = SizeUtil.getSizeB(context) ?? Size.zero;

            double x = 0;
            double y = 0;
            if (direction == TriangleArrowDirection.left) {
              x = offset.dx + size.width;
              y = offset.dy - (CcMenuPopup.currentMenuPopupHeight / 2 - size.height / 2);
            } else if (direction == TriangleArrowDirection.right) {
              x = offset.dx - size.width;
              y = offset.dy - (CcMenuPopup.currentMenuPopupHeight / 2 - size.height / 2);
            } else if (direction == TriangleArrowDirection.top) {
              x = offset.dx - (CcMenuPopup.currentMenuPopupWidth / 2 - size.width / 2);
              y = offset.dy + size.height;
            } else if (direction == TriangleArrowDirection.bottom) {
              x = offset.dx - (CcMenuPopup.currentMenuPopupWidth / 2 - size.width / 2);
              y = offset.dy - size.height;
            }
            DialogShower shower = DialogWrapper.show(WidgetsUtil.getMenuBubble(direction: direction), x: x, y: y);
            shower.transitionBuilder = null;
            shower.containerDecoration = null;
          }
        },
      ),
    );
  }
}
