import 'dart:convert';

import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

import '../util/logger.dart';
import 'page_of_keyboard.dart';

class PageOfNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfNavigator] ----------->>>>>>>>>>>> build/rebuild!!!");
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
          WidgetsUtil.newHeaderWithGradient('Navigator inner shower'),
          const SizedBox(height: 16),
          buildButtonsAboutNavigator(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutNavigator() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show with navigator with Width & Height', onPressed: () {
              DialogWrapper.pushRoot(
                WidgetsUtil.newClickMeWidget(clickMeFunctions: {
                  'Click me': (context) {
                    rootBundle.loadString('assets/json/CN.json').then((string) {
                      List<dynamic> value = json.decode(string);
                      DialogWrapper.push(PageOfKeyboard.getSelectableListWidget(value),
                          settings: const RouteSettings(name: '__root_route__'));
                    });
                  }
                }),
                width: 600,
                height: 600,
              );
            }),
            WidgetsUtil.newXpelTextButton('Show with navigator without W&H (Auto size)', onPressed: () {
              DialogWrapper.pushRoot(WidgetsUtil.newClickMeWidget(clickMeFunctions: {
                'Click me to push': (context) {
                  rootBundle.loadString('assets/json/CN.json').then((string) {
                    List<dynamic> value = json.decode(string);
                    DialogWrapper.push(PageOfKeyboard.getSelectableListWidget(value),
                        settings: const RouteSettings(name: '__root_route__'));
                  });
                },
                'Click me to setState': (context) {
                  DialogWrapper.getTopDialog()?.setState(() {});
                }
              }));
            }),
          ],
        )
      ],
    );
  }

// void animationDemo() {
//   AnimationController _controller = AnimationController(
//     vsync: shower.builderExKey.currentState!,
//     duration: const Duration(milliseconds: 200),
//   );
//   shower
//     ..isAutoSizeForNavigator = false
//     ..isSyncInvokeDismissCallback = true
//     ..dismissCallBack = (d) {
//       _controller.dispose();
//     };
//
//   Animation<double> _animation = Tween<double>(begin: AppConst.dialogViewWidth, end: XpSizeConst.bigDialogWidth)
//       .chain(CurveTween(curve: Curves.ease))
//       .animate(_controller);
//   _animation.addListener(() {
//     containerWidth = _animation.value;
//     print('_animation.value >>>>>>>> ${_animation.value}');
//     shower.width = _animation.value;
//     shower.setState(() {});
//   });
//   _controller.forward().then((value) {
//     print('>>>>>>>>>>>>>>>>> done!!!!!!');
//
//   });
//
// }
}
