import 'dart:async';

import 'package:example/util/logger.dart';
import 'package:example/util/toast_util.dart';
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

    // important!!! get your shower reference first ~~~, get with key once you have passed a key to shower wrapper
    OverlayShower? myShower = OverlayWrapper.getTopLayer();
    Object? obj = myShower?.obj;
    Logger.d('My Shower is: ${myShower.runtimeType} >>>>> ${myShower?.name}, obj: $obj');

    Function? dismissFn = obj is List && obj.lastSafe is Function ? obj.lastSafe : null;

    return GestureDetector(
      onTap: () {
        Object? obj = myShower?.obj;
        if (obj is List && obj.firstSafe is Timer) {
          Timer timer = obj.firstSafe;
          timer.cancel();
          Logger.d('obj is: ${timer.runtimeType} >>>>> $timer');
          ToastUtil.show('Clicked! You should dismiss this banner manually~~~').margin = const EdgeInsets.only(top: 200);
        }
        height.value = height.value != heightShrink ? heightShrink : heightExpanded;
      },
      onVerticalDragEnd: (details) {
        dismissFn?.call();
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
                  top: heightShrink + 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CcButtonWidget(
                        text: 'Dismiss',
                        onTap: (state) {
                          Logger.d('manually call dismiss animation !~~~~~');
                          dismissFn?.call();
                        },
                        options: CcButtonWidgetOptions()
                          ..width = 100
                          ..height = 40
                          ..textStyle = const TextStyle(color: Color(0xFF1C1D21), fontSize: 16)
                          ..decoration = BoxDecoration(
                            color: const Color(0xFFF5F5FA),
                            border: Border.all(color: const Color(0xFFDADAE8)),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                      ),
                      const SizedBox(width: 100),
                      CcButtonWidget(
                        text: 'Go',
                        onTap: (state) {
                          Logger.d('manually call dismiss animation !~~~~~');
                          dismissFn?.call();
                        },
                        options: CcButtonWidgetOptions()
                          ..width = 100
                          ..height = 40
                          ..textStyle = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
