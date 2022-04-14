import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/dialog/dialog_shower.dart';
import 'package:flutter_dialog_shower/overlay/overlay_shower.dart';
import 'package:flutter_dialog_shower/overlay/overlay_widgets.dart';

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
        demoUsageOfOverlayShower(),
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('Toast'),
        demoUsageOfToasts(),
      ],
    );
  }

  Column demoUsageOfOverlayShower() {
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
                ..padding = const EdgeInsets.only(top: 20)
                ..alignment = Alignment.topCenter
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show with opacity animation', onPressed: () {
              OverlayShower shower = OverlayShower()
                ..alignment = Alignment.bottomCenter
                ..margin = const EdgeInsets.only(bottom: 50)
                ..isWithTicker = true; // key point !!!
              shower.show(const Offstage(offstage: true)); // tricky, generate the StatefulBuilderExState instance first

              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                AnimationController animationController = AnimationController(
                  vsync: shower.statefulKey.currentState as StatefulBuilderExState,
                  duration: const Duration(milliseconds: 5 * 1000),
                  reverseDuration: const Duration(milliseconds: 1 * 1000),
                );
                Animation animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(curve: const Interval(0.0, 1.0, curve: Curves.linearToEaseOut), parent: animationController),
                );
                animationController.addListener(() {
                  shower.setState(() {}); // will rebuild with builder belowed
                });
                animationController.forward();
                shower.onTapCallback = (shower) {
                  animationController.reverse().then((value) {
                    animationController.dispose();
                    shower.dismiss();
                  });
                };

                shower.builder = (shower) {
                  return Opacity(
                    opacity: animation.value,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 20.0, offset: Offset(5.0, 5.0))],
                      ),
                      child: const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)),
                    ),
                  );
                };
              });
            }),
          ],
        ),
      ],
    );
  }

  Column demoUsageOfToasts() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show Toast on Top', onPressed: () {
              OverlayWidgets.showToast('You are heading to mogelia city, please take the books on board!').margin =
                  const EdgeInsets.only(top: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Bottom', onPressed: () {
              OverlayWidgets.showToast('You are heading to mogelia city, please take the books on board!')
                ..alignment = Alignment.bottomCenter
                ..margin = const EdgeInsets.only(bottom: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Center', onPressed: () {
              OverlayWidgets.showToast('You are heading to mogelia city, please take the books on board!')
                ..alignment = Alignment.center
                ..margin = EdgeInsets.zero;
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Top Queue', onPressed: () {
              OverlayWidgets.showToastInQueue(
                'You are heading to mogelia city, please click button again and again!',
                increaseOffset: const EdgeInsets.only(top: 45),
              )
                ..alignment = Alignment.topCenter
                ..margin = const EdgeInsets.only(top: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Bottom Queue', onPressed: () {
              OverlayWidgets.showToastInQueue(
                'You are heading to mogelia city, please click button again and again!',
                increaseOffset: const EdgeInsets.only(bottom: 45),
              )
                ..alignment = Alignment.bottomCenter
                ..margin = const EdgeInsets.only(bottom: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Left Queue', onPressed: () {
              OverlayWidgets.showToastInQueue(
                'You are heading to mogelia city, please click button again and again!',
                increaseOffset: const EdgeInsets.only(top: 45, left: 18),
              )
                ..alignment = Alignment.topLeft
                ..margin = const EdgeInsets.only(top: 220, left: 20);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Right Queue', onPressed: () {
              OverlayWidgets.showToastInQueue(
                'You are heading to mogelia city, please click button again and again!',
                increaseOffset: const EdgeInsets.only(top: 45, right: 18),
              )
                ..alignment = Alignment.topRight
                ..margin = const EdgeInsets.only(top: 220, right: 20);
            }),
          ],
        ),
      ],
    );
  }
}
