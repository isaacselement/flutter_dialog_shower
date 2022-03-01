import 'package:example/view/manager/themes_manager.dart';
import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';

class WidgetsUtil {
  static XpTextButton newXpelTextButton(String text, {void Function()? onPressed, bool isSmallest = false}) {
    return XpTextButton(
      text,
      onPressed: onPressed,
      isAsSmallAsPossible: isSmallest,
      decorationBuilder: ThemesManager.builderXpButtonDecoration,
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
}
