import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/offset_util.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/brother.dart';
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
            WidgetsUtil.newXpelTextButton('Show menu using Builder', onPressed: (state) {
              bool isRight = Random().nextBool();
              Offset offsetS = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size sizeS = SizeUtil.getSizeS(state) ?? Size.zero;
              bool isGotSize = false;
              OverlayShower shower = OverlayShower();
              shower.builder = (context) {
                return Offstage(
                  offstage: !isGotSize,
                  child: GetSizeWidget(
                    onLayoutChanged: (box, legacy, size) {
                      Logger.d('👉👉👉>>>>> widget size is determined: $size');
                      shower.setState(() {
                        isGotSize = true;
                        shower.dx = offsetS.dx - (isRight ? size.width : -size.width);
                        shower.dy = offsetS.dy - (size.height - sizeS.height) / 2;
                      });
                    },
                    child: WidgetsUtil.getMenuPicker(
                      direction: isRight ? TriangleArrowDirection.right : TriangleArrowDirection.left,
                      onTap: (index, value, context) {
                        shower.dismiss();
                      },
                    ),
                  ),
                );
              };
              shower.show();
            }),
            WidgetsUtil.newXpelTextButton('Show menu using Btw', onPressed: (state) {
              bool isTop = Random().nextBool();
              Offset offsetS = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size sizeS = SizeUtil.getSizeS(state) ?? Size.zero;
              Btv<bool> isGotSize = false.btv;
              OverlayShower shower = OverlayShower();
              OverlayWrapper.showWith(
                shower,
                Btw(builder: (context) {
                  return Offstage(
                    offstage: !isGotSize.value,
                    child: GetSizeWidget(
                      onLayoutChanged: (box, legacy, size) {
                        Logger.d('👉👉👉>>>>> widget size is determined: $size');
                        shower.setState(() {
                          isGotSize.value = true;
                          shower.dx = offsetS.dx - (size.width - sizeS.width) / 2;
                          shower.dy = isTop ? offsetS.dy + sizeS.height : offsetS.dy - size.height;
                        });
                      },
                      child: WidgetsUtil.getMenuPicker(
                        direction: isTop ? TriangleArrowDirection.top : TriangleArrowDirection.bottom,
                        onTap: (index, value, context) {
                          OverlayWrapper.dismissAppearingLayers();
                        },
                      ),
                    ),
                  );
                }),
                dx: offsetS.dx,
                dy: offsetS.dy + sizeS.height,
              );
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show menu why Offstage first', onPressed: (state) {
              Offset offsetS = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size sizeS = SizeUtil.getSizeS(state) ?? Size.zero;
              OverlayShower shower = OverlayShower();
              OverlayWrapper.showWith(
                shower,
                GetSizeWidget(
                  onLayoutChanged: (box, legacy, size) {
                    Logger.d('👉👉👉>>>>> widget size is determined: $size');
                    shower.setState(() {
                      shower.dx = offsetS.dx - (size.width - sizeS.width) / 2;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetsUtil.getMenuPicker(
                        direction: TriangleArrowDirection.top,
                        onTap: (index, value, context) {
                          OverlayWrapper.dismissAppearingLayers();
                        },
                      ),
                      ColoredBox(
                        color: Colors.yellow,
                        child: Text(
                          'Cause after size determined shower.setState will have a flash/blink issue.',
                          style: WidgetsUtil.getTextStyleWithPassionOne(fontSize: 16),
                        ),
                      ),
                      ColoredBox(
                        color: Colors.yellow,
                        child: Text(
                          'So we need show Offstage true first.',
                          style: WidgetsUtil.getTextStyleWithPacifico(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                dx: offsetS.dx,
                dy: offsetS.dy + sizeS.height,
              );
            }),
            WidgetsUtil.newXpelTextButton('Show menu why Offstage first', onPressed: (state) {
              Offset offsetS = OffsetUtil.getOffsetS(state) ?? Offset.zero;
              Size sizeS = SizeUtil.getSizeS(state) ?? Size.zero;
              OverlayShower shower = OverlayShower();
              OverlayWrapper.showWith(
                shower,
                GetSizeWidget(
                  onLayoutChanged: (box, legacy, size) {
                    Logger.d('👉👉👉>>>>> widget size is determined: $size, $offsetS');
                    shower.setState(() {
                      shower.dx = offsetS.dx - (size.width - sizeS.width) / 2;
                      shower.dy = offsetS.dy - size.height;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColoredBox(
                        color: Colors.yellow,
                        child: Text(
                          'So we need show Offstage true first.',
                          style: WidgetsUtil.getTextStyleWithPacifico(fontSize: 14),
                        ),
                      ),
                      ColoredBox(
                        color: Colors.yellow,
                        child: Text(
                          'Cause after size determined shower.setState will have a flash/blink issue.',
                          style: WidgetsUtil.getTextStyleWithPassionOne(fontSize: 16),
                        ),
                      ),
                      WidgetsUtil.getMenuPicker(
                        direction: TriangleArrowDirection.bottom,
                        onTap: (index, value, context) {
                          OverlayWrapper.dismissAppearingLayers();
                        },
                      ),
                    ],
                  ),
                ),
                dx: offsetS.dx,
                dy: offsetS.dy,
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
