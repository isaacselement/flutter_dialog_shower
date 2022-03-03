import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class WidgetsUtil {
  static XpTextButton newXpelTextButton(String text, {void Function()? onPressed, bool isSmallest = false}) {
    return XpTextButton(
      text,
      onPressed: onPressed,
      isAsSmallAsPossible: isSmallest,
      decorationBuilder: ThemesManager.builderXpButtonDecoration,
    );
  }

  static Widget newEditBox({double width = 500, double height = 600}) {
    return Container(
      width: width,
      height: height,
      // decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField(
              padding: const EdgeInsets.all(6.0),
              style: const TextStyle(fontSize: 15, color: Colors.black),
              placeholder: 'Click Here For Get Focus First Please ...',
              maxLines: 100,
              maxLength: 1000,
              onChanged: (str) {
                print('u enter: $str');
              },
            )
          ],
        ),
      ),
    );
  }

  static Widget newHeaderWithGradient(String titleText) {
    return Container(
      height: 32,
      alignment: Alignment.center,
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
        WidgetsUtil.newXpelTextButton('Dismiss', isSmallest: true, onPressed: () {
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
