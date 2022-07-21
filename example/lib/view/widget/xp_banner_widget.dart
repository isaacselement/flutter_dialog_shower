import 'dart:async';

import 'package:example/util/logger.dart';
import 'package:example/util/toast_util.dart';
import 'package:example/view/widget/xp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class XpBannerWidget extends StatelessWidget {
  const XpBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'What a nice day!';
    String subTitle = '${DateTime.now()}. Here. I got you a present. Tap me to view more>>>';

    double heightShrink = 50.0;
    double heightExpanded = 100.0;
    Btv<double> height = heightShrink.btv;

    // important!!! get your shower reference first ~~~
    OverlayShower? myShower = OverlayWrapper.getTopLayer();
    Logger.d('My Shower is: ${myShower.runtimeType} >>>>> ${myShower?.name}');

    return CcTapWidget(
      pressedOpacity: 1.0,
      onTap: (state) {
        Object? obj = myShower?.obj;
        if (obj is List && obj.firstSafe is Timer) {
          Timer timer = obj.firstSafe;
          timer.cancel();
          Logger.d('obj is: ${timer.runtimeType} >>>>> $timer');
          ToastUtil.show('Clicked! You should dismiss this banner manually~~~').margin = const EdgeInsets.only(top: 200);
        }
        height.value = height.value != heightShrink ? heightShrink : heightExpanded;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 25.0)],
        ),
        child: Btw(builder: (context) {
          height.eye;
          return AnimatedContainer(
            height: height.value,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Icon(Icons.info, size: 20), const SizedBox(width: 8), Text(subTitle)],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: heightShrink,
                  left: 0,
                  child: Row(
                    children: [
                      XpTextButton(
                        'Cancel',
                        width: 100,
                        height: 40,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        borderColor: const Color(0xFFDADAE8),
                        backgroundColor: null,
                        backgroundColorDisable: const Color(0xFFF5F5FA),
                        textStyleBuilder: (text, isTappingDown) {
                          Color color = const Color(0xFF1C1D21);
                          return TextStyle(color: isTappingDown ? color.withAlpha(128) : color, fontSize: 16);
                        },
                        onPressed: (state) {
                          Logger.d('state is: ${state.runtimeType} >>>>> $state');
                          Object? obj = myShower?.obj;
                          if (obj is List && obj.lastSafe is Function) {
                            Logger.d('state call dismiss !~~~~~');
                            (obj.lastSafe as Function).call();
                          }
                        },
                      ),
                      const SizedBox(width: 100),
                      XpTextButton(
                        'Go',
                        width: 100,
                        height: 40,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        borderColor: const Color(0xFFDADAE8),
                        textStyleBuilder: (text, isTappingDown) {
                          Color color = Colors.white;
                          color = isTappingDown ? color.withAlpha(128) : color;
                          return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
                        },
                        onPressed: (state) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
