import 'dart:ffi';
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
import 'package:flutter_dialog_shower/view/cc_select_list_widgets.dart';

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
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('LayerLink'),
        const SizedBox(height: 2),
        demoUsageOfLayerLink(),
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
                ..padding = const EdgeInsets.only(bottom: 50)
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
                        shower.dx = max(0, offsetS.dx - (isRight ? size.width : -size.width));
                        shower.dy = max(0, offsetS.dy - (size.height - sizeS.height) / 2);
                      });
                    },
                    child: WidgetsUtil.getBubbleMenuPicker(
                      row: 2,
                      direction: isRight ? TriangleArrowDirection.right : TriangleArrowDirection.left,
                      itemOnTap: (index, value, context) {
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
              shower.show(
                Btw(builder: (context) {
                  return Offstage(
                    offstage: !isGotSize.value,
                    child: GetSizeWidget(
                      onLayoutChanged: (box, legacy, size) {
                        Logger.d('👉👉👉>>>>> widget size is determined: $size');
                        shower.setState(() {
                          isGotSize.value = true;
                          shower.dx = max(0, offsetS.dx - (size.width - sizeS.width) / 2);
                          shower.dy = max(0, isTop ? offsetS.dy + sizeS.height : offsetS.dy - size.height);
                        });
                      },
                      child: WidgetsUtil.getBubbleMenuPicker(
                        direction: isTop ? TriangleArrowDirection.top : TriangleArrowDirection.bottom,
                        itemOnTap: (index, value, context) {
                          shower.dismiss();
                        },
                      ),
                    ),
                  );
                }),
              );
            }),
          ],
        ),

        // Also a demo usage of OverlayWrapper ...
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
                      shower.dx = max(0, offsetS.dx - (size.width - sizeS.width) / 2);
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetsUtil.getBubbleMenuPicker(
                        direction: TriangleArrowDirection.top,
                        itemOnTap: (index, value, context) {
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
                      shower.dx = max(0, offsetS.dx - (size.width - sizeS.width) / 2);
                      shower.dy = max(0, offsetS.dy - size.height);
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
                      WidgetsUtil.getBubbleMenuPicker(
                        direction: TriangleArrowDirection.bottom,
                        itemOnTap: (index, value, context) {
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

  Widget demoUsageOfLayerLink() {
    return Column(
      children: [
        Wrap(
          children: [
            layerLinkOfPure(),
            layerLinkOfShower(),
          ],
        ),
      ],
    );
  }

  Widget layerLinkOfPure() {
    int __itemCount__ = 50;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 380,
        height: 520,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orangeAccent),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: const [BoxShadow(color: Colors.orange, blurRadius: 16.0)],
        ),
        child: ListView.builder(
          itemCount: __itemCount__,
          itemBuilder: (context, index) {
            return LayerLinkEntryWidget(index: index);
          },
        ),
      ),
    );
  }

  Widget layerLinkOfShower() {
    int __itemCount__ = 50;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 380,
        height: 520,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orangeAccent),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: const [BoxShadow(color: Colors.orange, blurRadius: 16.0)],
        ),
        child: ListView.builder(
          itemCount: __itemCount__,
          itemBuilder: (context, index) {
            LayerLink _layerLink = LayerLink();
            return StatefulBuilder(builder: (context, constraints) {
              return CompositedTransformTarget(
                link: _layerLink,
                child: CcTapWidget(
                  builder: () {
                    return Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: const [BoxShadow(color: Colors.red, blurRadius: 20.0)]),
                        child: Center(child: Text('$index', style: WidgetsUtil.getTextStyleWithPassionOne(fontSize: 15))));
                  },
                  onTap: () {
                    Container showedContainer = Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 25.0)],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print('$index you click the popup ~~~~~~');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 400,
                            child: Text(
                              'do you know it is very serious!!!\nPeople regard it as a matter of normality if a man takes the initiative in courtship, but if a...',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    );

                    // 1. Insert directly
                    // OverlayEntry _entry = OverlayEntry(builder: (context) {
                    //   return Positioned(
                    //     width: 400,
                    //     child: CompositedTransformFollower(
                    //       link: _layerLink,
                    //       showWhenUnlinked: false,
                    //       offset: const Offset(0, 60),
                    //       child: Material(child: showedContainer),
                    //     ),
                    //   );
                    // });
                    // Overlay.of(context, rootOverlay: true)!.insert(_entry);
                    // return;

                    // 2. Use OverlayShower
                    RenderBox? box = context.findRenderObject() as RenderBox?;
                    Size size = box?.size ?? Size.zero;
                    int randomIr = Random().nextInt(3);
                    int zRadius = (OverlayWrapper.appearingShowers?.length ?? 0) == 0 || randomIr == 0 ? 0 : (randomIr == 1 ? 15 : -15);

                    // TODO ... Wrapper OverlayWrapper.showWithLayerLink method ...
                    OverlayWrapper.show(
                      Positioned(
                        width: 400,
                        child: CompositedTransformFollower(
                          link: _layerLink,
                          showWhenUnlinked: false,
                          offset: Offset(0, size.height),
                          // child: Material(child: showedContainer),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(zRadius / 180 * pi),
                            child: Material(child: showedContainer),
                          ),
                        ),
                      ),
                    ).isWrappedNothing = true;
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

/// LayerLink Entry
class LayerLinkEntryWidget extends StatefulWidget {
  final int index;

  const LayerLinkEntryWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<LayerLinkEntryWidget> createState() => _LayerLinkEntryState();
}

class _LayerLinkEntryState extends State<LayerLinkEntryWidget> {
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        child: Container(
          height: 50,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: const [BoxShadow(color: Colors.red, blurRadius: 20.0)]),
          child: Center(child: Text('${widget.index}', style: WidgetsUtil.getTextStyleWithPassionOne(fontSize: 15))),
        ),
        onTap: () {
          overlayEntry?.remove();
          overlayEntry = null;
          overlayEntry = OverlayEntry(builder: (context) {
            return Positioned(
              width: 242,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 60),
                child: WidgetsUtil.getBubbleMenuPicker(
                  direction: TriangleArrowDirection.top,
                  itemOnTap: (index, value, context) {
                    overlayEntry?.remove();
                    overlayEntry = null;
                  },
                ),
              ),
            );
          });
          Overlay.of(context)!.insert(overlayEntry!);
        },
      ),
    );
  }
}
