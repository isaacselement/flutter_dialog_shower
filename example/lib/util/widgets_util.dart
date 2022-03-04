import 'package:example/util/size_util.dart';
import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class WidgetsUtil {
  static get _editorBoxWidth => 400 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 400.toDouble();

  static get _editorBoxHeight => 300 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 300.toDouble();

  static XpTextButton newXpelTextButton(String text, {void Function()? onPressed}) {
    return XpTextButton(
      text,
      onPressed: onPressed,
      decorationBuilder: ThemesManager.builderXpButtonDecoration,
    );
  }

  static Widget newEditBotxWithBottomTips({String? hint}) {
    TextStyle tipTopStyle = const TextStyle(fontSize: 18, fontFamily: 'PassionOne-Regular');
    TextStyle tipBottomStyle = const TextStyle(fontSize: 14, fontFamily: 'Pacifico-Regular');
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
}
