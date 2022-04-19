import 'package:example/util/logger.dart';
import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/widgets/cc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialog_shower/dialog/dialog_shower.dart';
import 'package:flutter_dialog_shower/overlay/overlay_shower.dart';
import 'package:flutter_dialog_shower/overlay/overlay_widgets.dart';
import 'package:flutter_dialog_shower/overlay/overlay_wrapper.dart';
import 'package:flutter_dialog_shower/view/cc_bubble_widgets.dart';

class PageOfOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBasic] ----------->>>>>>>>>>>> build/rebuild!!!");

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
          WidgetsUtil.newHeaderWithGradient('Overlay shower'),
          const SizedBox(height: 16),
          buildButtonsAboutOverlayShower(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutOverlayShower() {
    return Column(
      children: [
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Overlay'),
        const SizedBox(height: 12),
        demoUsageOfBasic(),
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('Menu'),
        demoUsageOfMenu(),
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('Toast'),
        demoUsageOfToasts(),
      ],
    );
  }

  Column demoUsageOfBasic() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show center', onPressed: (state) {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..alignment = Alignment.center
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show dx dy', onPressed: (state) {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..dx = 200
                ..dy = 200
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show x y positioned', onPressed: (state) {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..x = 200
                ..y = 100
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show padding aligment', onPressed: (state) {
              OverlayShower().show(const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)))
                ..padding = const EdgeInsets.only(top: 20)
                ..alignment = Alignment.topCenter
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Show with opacity animation', onPressed: (state) {
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

  Column demoUsageOfMenu() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show menu', onPressed: (state) {
              Offset offsetS = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size sizeS = SizeUtil.getSizeS(state) ?? Size.zero;
              OverlayShower shower = OverlayShower();
              OverlayWrapper.showWith(
                shower,
                GetSizeWidget(
                  onLayoutChanged: (box, legacy, size) {
                      Logger.d('👉👉👉>>>>> onLayoutChanged: $size');
                      shower.setState(() {
                        shower.dx = offsetS.dx - (size.width - sizeS.width) / 2;
                      });
                  },
                  child: CcBubbleWidget(
                    bubbleColor: Colors.black, // triangle color
                    triangleDirection: TriangleArrowDirection.top,
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
                        OverlayWrapper.dismissAppearingLayers();
                      },
                    ),
                  ),
                ),
                dx: offsetS.dx - (100 - sizeS.width) / 2,
                dy: offsetS.dy + sizeS.height,
              );
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
            WidgetsUtil.newXpelTextButton('Show Toast on Top', onPressed: (state) {
              OverlayWidgets.showToast('You are heading to mogelia city, please on board at ${DateTime.now()} ...')
                ..alignment = Alignment.topCenter
                ..margin = const EdgeInsets.only(top: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Bottom', onPressed: (state) {
              OverlayWidgets.showToast('You are heading to mogelia city, please on board at ${DateTime.now()} ...')
                ..alignment = Alignment.bottomCenter
                ..margin = const EdgeInsets.only(bottom: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Center', onPressed: (state) {
              OverlayWidgets.showToast('You are heading to mogelia city, please on board at ${DateTime.now()} ...')
                ..alignment = Alignment.center
                ..margin = EdgeInsets.zero;
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show Toast on Top Queue', onPressed: (state) {
              OverlayWidgets.showToastInQueue(
                'Here is mogelia, please click button again and again ${DateTime.now()} ...',
                increaseOffset: const EdgeInsets.only(top: 45),
              )
                ..alignment = Alignment.topCenter
                ..margin = const EdgeInsets.only(top: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Bottom Queue', onPressed: (state) {
              OverlayWidgets.showToastInQueue(
                'Here is mogelia, please click button again and again ${DateTime.now()} ...',
                increaseOffset: const EdgeInsets.only(bottom: 45),
                slideBegin: const Offset(0, -1000),
                dismissAnimatedBuilder: (shower, controller, child) {
                  Animation<Offset>? slide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1000)).animate(controller);
                  Widget? widgetSlide;
                  widgetSlide = AnimatedBuilder(
                    animation: slide,
                    builder: (context, child) => Transform.translate(offset: slide.value, child: child),
                    child: child,
                  );
                  return widgetSlide;
                },
              )
                ..alignment = Alignment.bottomCenter
                ..margin = const EdgeInsets.only(bottom: 80);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Left Queue', onPressed: (state) {
              OverlayWidgets.showToastInQueue(
                'Here is mogelia, please click button again and again ${DateTime.now()} ...',
                increaseOffset: const EdgeInsets.only(top: 45, left: 18),
                slideBegin: const Offset(-1000, 0),
              )
                ..alignment = Alignment.topLeft
                ..margin = const EdgeInsets.only(top: 220, left: 20);
            }),
            WidgetsUtil.newXpelTextButton('Show Toast on Right Queue', onPressed: (state) {
              OverlayWidgets.showToastInQueue(
                'Here is mogelia, please click button again and again ${DateTime.now()} ...',
                increaseOffset: const EdgeInsets.only(top: 45, right: 18),
                slideBegin: const Offset(1000, 0),
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
