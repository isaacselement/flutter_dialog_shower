import 'package:example/util/logger.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';
import 'package:flutter_dialog_shower/overlay/overlay_shower.dart';

class PageOfOverlay extends StatelessWidget {
  static late BuildContext context;

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBasic] ----------->>>>>>>>>>>> build/rebuild!!!");

    PageOfOverlay.context = context;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Overlay'),
        const SizedBox(height: 12),
        demoUsageOfDialogShower(),
        const SizedBox(height: 32),
      ],
    );
  }

  Column demoUsageOfDialogShower() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: () {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..alignment = Alignment.center
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show x y positioned', onPressed: () {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..x = 200
                ..y = 100
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show padding aligment', onPressed: () {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..padding = EdgeInsets.only(top: 20)
                ..alignment = Alignment.topCenter
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show with animation', onPressed: () {
              OverlayShower shower = OverlayShower()
                ..alignment = Alignment.center
                ..isWithTicker = true; // key point !!!
              shower.show(Offstage(offstage: true));  // tricky, generate the StatefulBuilderExState instance first

              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                AnimationController animationController = AnimationController(
                  vsync: shower.statefulKey.currentState as StatefulBuilderExState,
                  duration: const Duration(milliseconds: 5 * 1000),
                );
                Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(curve: Interval(0.0, 1.0, curve: Curves.linearToEaseOut), parent: animationController),
                );
                animationController.addListener(() {
                  shower.setState(() {});
                });

                shower.builder = (shower) {
                  return Opacity(
                      opacity: animation.value, child: const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)));
                };
                animationController.forward();
                shower.onTapCallback = (shower) {
                  animationController.dispose();
                  shower.dismiss();
                };
              });
            }),
            WidgetsUtil.newXpelTextButton('Show from top left', onPressed: () {}),
            WidgetsUtil.newXpelTextButton('Show from top right', onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
