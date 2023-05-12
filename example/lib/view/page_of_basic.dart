import 'package:example/util/logger.dart';
import 'package:example/util/shower_helper.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfBasic extends StatelessWidget {
  const PageOfBasic({Key? key}) : super(key: key);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('DialogShower'),
        const SizedBox(height: 12),
        demoUsageOfDialogShower(),
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('DialogWrapper'),
        WidgetsUtil.newDescriptions('DialogWrapper is a wrapper for DialogShower. '),
        WidgetsUtil.newDescriptions(
            'Using DialogWrapper, you can very easy to show a dialog and modify it\'s properties, and take the management of YOUR ALL showing dialogs'),
        const SizedBox(height: 12),
        demoUsageOfDialogWrapper(),
        const SizedBox(height: 32),
        WidgetsUtil.newHeaderWithLine('setState & animation'),
        demoUsageOfTickerAnimation(),
        const SizedBox(height: 12),
      ],
    );
  }

  Column demoUsageOfDialogShower() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show from bottom', onPressed: (state) {
              doBasicShow();
            }),
            WidgetsUtil.newXpelTextButton('Show from left', onPressed: (state) {
              doBasicShow().transitionBuilder = ShowerTransitionBuilder.slideFromLeft;
            }),
            WidgetsUtil.newXpelTextButton('Show from right', onPressed: (state) {
              doBasicShow().transitionBuilder = ShowerTransitionBuilder.slideFromRight;
            }),
            WidgetsUtil.newXpelTextButton('Show from top', onPressed: (state) {
              doBasicShow().transitionBuilder = ShowerTransitionBuilder.slideFromTop;
            }),
            WidgetsUtil.newXpelTextButton('Show from top left', onPressed: (state) {
              doBasicShow().transitionBuilder = ShowerTransitionBuilder.slideTransitionBuilder(const Offset(-1.0, -1.0));
            }),
            WidgetsUtil.newXpelTextButton('Show from top right', onPressed: (state) {
              doBasicShow().transitionBuilder = ShowerTransitionBuilder.slideTransitionBuilder(const Offset(1.0, -1.0));
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show in left', onPressed: (state) {
              DialogShower shower = doBasicShow();
              shower.transitionBuilder = ShowerTransitionBuilder.slideFromLeft;
              shower.alignment = Alignment.centerLeft;
              shower.padding = const EdgeInsets.only(left: 5);
            }),
            WidgetsUtil.newXpelTextButton('Show in right', onPressed: (state) {
              DialogShower shower = doBasicShow();
              shower.transitionBuilder = ShowerTransitionBuilder.slideFromRight;
              shower.alignment = Alignment.centerRight;
              shower.padding = const EdgeInsets.only(right: 5);
            }),
            WidgetsUtil.newXpelTextButton('Show in bottom', onPressed: (state) {
              DialogShower shower = doBasicShow();
              shower.transitionBuilder = ShowerTransitionBuilder.slideFromBottom;
              shower.alignment = Alignment.bottomCenter;
              shower.padding = const EdgeInsets.only(bottom: 5);
              // barrier color
              shower.barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('Show in top', onPressed: (state) {
              DialogShower shower = doBasicShow();
              shower.transitionBuilder = ShowerTransitionBuilder.slideFromTop;
              shower.alignment = Alignment.topCenter;
              shower.padding = EdgeInsets.only(top: ScreensUtils.statusBarHeight);
              // background color
              shower.scaffoldBackgroundColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('Show with position x y', onPressed: (state) {
              double x = 20;
              double y = 40;
              DialogShower shower = doBasicShow();
              shower
                ..alignment = Alignment.topLeft
                ..padding = EdgeInsets.only(left: x, top: y);
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Shower dismiss manually', onPressed: (state) {
              DialogShower shower = DialogShower();
              shower
                ..barrierDismissible = false
                ..dismissCallBack = (shower) {
                  Logger.d('shower dismissCallBack');
                };
              shower.show(Container(
                width: _showerWidth,
                height: _showerHeight,
                color: Colors.lightGreen,
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: WidgetsUtil.newXpelTextButton('Click to Dismiss', onPressed: (state) {
                  shower.dismiss();
                }),
              ));
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first using wholeOnTapCallback', onPressed: (state) {
              DialogShower shower = DialogShower();
              shower
                ..containerShadowColor = Colors.grey
                ..containerShadowBlurRadius = 20.0
                ..containerBorderRadius = 10.0
                ..isDismissKeyboardOnTapped = false // disable the default behavior
                ..wholeOnTapCallback = (shower, point, isTappedInside) {
                  Logger.d('shower wholeOnTapCallback');
                  if (DialogShower.isKeyboardShowing()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    shower.dismiss();
                  }
                  return true;
                };
              shower.show(WidgetsUtil.newEditBotxWithBottomTips(hint: 'Focus edit box first, then [Click Me]'));
            }),
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first using barrierOnTapCallback', onPressed: (state) {
              DialogShower shower = DialogShower();
              shower
                ..containerShadowColor = Colors.grey
                ..containerShadowBlurRadius = 20.0
                ..containerBorderRadius = 10.0
                ..barrierOnTapCallback = (shower, point) {
                  Logger.d('shower barrierOnTapCallback');
                  if (DialogShower.isKeyboardShowing()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    shower.dismiss();
                  }
                  return true;
                };
              shower.show(WidgetsUtil.newEditBotxWithBottomTips(hint: 'Focus edit box first, then [Click Me] / [Click Barrier]'));
            }),
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first with setting barrierDismissible to null', onPressed: (state) {
              DialogShower shower = DialogShower();
              shower
                ..containerShadowColor = Colors.grey
                ..containerShadowBlurRadius = 20.0
                ..containerBorderRadius = 10.0
                ..barrierDismissible = null; // will dismiss keyboard first, then click again will dismisss dialog
              // if you want to do not dismiss keyboard on [Click Me], disable the default behavior
              // ..isDismissKeyboardOnTapped = false
              shower.show(WidgetsUtil.newEditBotxWithBottomTips(hint: 'Focus edit box first, then [Click Me] / [Click Barrier]'));
            }),
          ],
        ),
      ],
    );
  }

  Column demoUsageOfDialogWrapper() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Just Show', onPressed: (state) {
              DialogWrapper.showCenter(_container(text: '1'), width: 200, height: 200);
            }),
            WidgetsUtil.newXpelTextButton('Just Show', onPressed: (state) {
              DialogWrapper.showCenter(_container(text: '1'), fixed: true, width: 200, height: 200).transitionBuilder =
                  ShowerTransitionBuilder.scaleIn;
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper Show Cupertino Indicator', onPressed: (state) {
              DialogShower dialog = DialogWrapper.show(const CupertinoActivityIndicator());
              // rewrite properties
              dialog
                ..alignment = Alignment.center
                ..containerDecoration = null
                ..barrierDismissible = true
                ..barrierColor = Colors.transparent
                ..transitionDuration = const Duration(milliseconds: 200)
                ..transitionBuilder =
                    (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                  return ScaleTransition(
                    child: child,
                    scale: Tween(begin: 0.0, end: 1.0).animate(animation),
                  );
                };
            }),
            WidgetsUtil.newXpelTextButton('Show with DialogWrapper', onPressed: (state) {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).poppedCompleter.future.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).poppedCompleter.future.then((value) {
                  DialogWrapper.showRight(_container(text: '3')).poppedCompleter.future.then((value) {
                    DialogWrapper.showBottom(_container(text: '4')).poppedCompleter.future.then((value) {
                      DialogWrapper.show(_container(text: 'Click any where out of this box'))
                        ..transitionBuilder = ShowerTransitionBuilder.slideFromTop
                        ..alignment = Alignment.topCenter
                        ..padding = EdgeInsets.only(top: ScreensUtils.statusBarHeight);
                    });
                  });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss all dialogs', onPressed: (state) {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).poppedCompleter.future.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).poppedCompleter.future.then((value) {
                  DialogWrapper.showRight(_container(text: '3')).poppedCompleter.future.then((value) {
                    DialogWrapper.showBottom(_container(text: '4')).poppedCompleter.future.then((value) {
                      DialogWrapper.show(_container(text: 'Click any where out of this box'))
                        ..transitionBuilder = ShowerTransitionBuilder.slideFromTop
                        ..alignment = Alignment.topCenter
                        ..padding = EdgeInsets.only(top: ScreensUtils.statusBarHeight)
                        ..future.then((value) => DialogWrapper.dismissAppearingDialogs());
                    });
                  });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss the dialog on top', onPressed: (state) {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).poppedCompleter.future.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).poppedCompleter.future.then((value) {
                  DialogWrapper.showRight(_container(text: 'Will auto dismiss after 2 seconds'))
                    ..barrierDismissible = false
                    ..pushedCompleter.future.then((value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        // DialogWrapper.dismissTopDialog();
                        DialogWrapper.getTopDialog()?.dismiss();
                      });
                    });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss the dialog With key', onPressed: (state) {
              DialogWrapper.show(_container(text: 'I\'m key1'), key: '__key1__', width: 200, height: 200)
                  .poppedCompleter
                  .future
                  .then((value) {
                DialogWrapper.showLeft(_container(text: 'I\'m key2'), key: '__key2__').poppedCompleter.future.then((value) {
                  DialogWrapper.showRight(_container(text: 'I\'m key3'), key: '__key3__')
                    ..barrierDismissible = false
                    ..pushedCompleter.future.then((value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        DialogWrapper.dismissDialog(null, key: '__key3__'); // will dismiss all dialog on top of me
                      });
                    });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('Remove specified shower', onPressed: (state) {
              DialogWrapper.show(_container(text: 'I\'m key1'), key: '__key1__', width: 700, height: 250)
                  .pushedCompleter
                  .future
                  .then((value) async {
                await Future.delayed(const Duration(seconds: 1));
                DialogWrapper.showLeft(_container(text: 'I\'m key2'), key: '__key2__').pushedCompleter.future.then((value) async {
                  await Future.delayed(const Duration(seconds: 1));
                  DialogWrapper.showRight(_container(text: 'I\'m key3'), key: '__key3__').pushedCompleter.future.then((value) {
                    Future.delayed(const Duration(seconds: 1), () {
                      DialogWrapper.getDialogByKey('__key1__')?.future.then((value) {
                        Logger.d('__key1__ is popped or removed');
                      });
                      DialogWrapper.getDialogByKey('__key1__')?.remove(result: '').then((value) async {
                        Logger.d('__key1__ is popped animation done!!!!');
                        await Future.delayed(const Duration(seconds: 1));
                        DialogWrapper.getDialogByKey('__key2__')?.remove(isAnimated: true).then((value) {
                          Logger.d('__key2__ is popped animation done!!!!');
                          DialogWrapper.getDialogByKey('__key3__')?.dismiss();
                        });
                      });
                    });
                  });
                });
              });
            }),
          ],
        )
      ],
    );
  }

  Column demoUsageOfTickerAnimation() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Expand width animation', onPressed: (state) {
              Btv<int> counter = 2.btv;
              DialogShower shower = DialogWrapper.show(Btw(
                builder: (context) {
                  String text = 'Will Expand in ${counter.value}s...';
                  text = counter.value == 0 ? 'Expanding...' : (counter.value < 0 ? 'Expanded' : text);
                  return Container(color: Colors.redAccent, alignment: Alignment.center, child: Text(text));
                },
              ), width: 200, height: 250);
              shower.isWithTicker = true;

              ShowerHelper.stopwatchTimer(
                count: counter.value,
                tik: (i) {
                  counter.value = --counter.value;
                  if (counter.value == 0) {
                    ShowerHelper.transformWidth(shower: shower, begin: 200, end: 750, onFinish: () => counter.value = -1);
                  }
                  return false;
                },
              );
            }),
            WidgetsUtil.newXpelTextButton('Expand width animation with reverse then dismiss', onPressed: (state) {
              Btv<int> counter = 2.btv;
              DialogShower shower = DialogWrapper.show(Btw(
                builder: (context) {
                  String text = 'Will Expand in ${counter.value}s...';
                  text = counter.value == 0 ? 'Expanding...' : (counter.value < 0 ? 'Expanded' : text);
                  return Container(color: Colors.redAccent, alignment: Alignment.center, child: Text(text));
                },
              ), width: 200, height: 250);
              shower.isWithTicker = true;
              shower.transitionBuilder = ShowerTransitionBuilder.slideFromTop;

              ShowerHelper.stopwatchTimer(
                count: counter.value,
                tik: (i) {
                  counter.value = --counter.value;
                  if (counter.value == 0) {
                    AnimationController? c =
                        ShowerHelper.transformWidth(shower: shower, begin: 200, end: 750, onFinish: () => counter.value = -1);
                    shower.dialogOnTapCallback = (shower, offset) {
                      c?.reverse().then((value) {
                        shower.dismiss();
                      });
                      return true;
                    };
                  }
                  return false;
                },
              );
            }),
            WidgetsUtil.newXpelTextButton('Dismiss with custom animation', onPressed: (state) {
              DialogShower shower = DialogWrapper.show(Btw(
                builder: (context) {
                  return Container(color: Colors.redAccent, alignment: Alignment.center, child: const Text('Hola! Tap barrier pls...'));
                },
              ), width: 700, height: 250);
              shower.isWithTicker = true;

              shower.barrierOnTapCallback = (shower, offset) {
                AnimationController controller =
                    ShowerHelper.createAnimationController(shower, duration: const Duration(milliseconds: 200))!;
                Animation<double> animate = Tween<double>(begin: 700, end: 0).chain(CurveTween(curve: Curves.ease)).animate(controller);
                animate.addListener(() {
                  shower.width = animate.value;
                  shower.setState();
                });
                controller.forward().then((value) {
                  shower.dismiss(); // shower.remove(); // or just user remove
                });
                return true;
              };
            }),
            WidgetsUtil.newXpelTextButton('Animate as you want', onPressed: (state) {
              DialogShower shower = DialogWrapper.show(
                Container(color: Colors.redAccent, alignment: Alignment.center, child: const Text('Hola! Tap barrier pls...')),
                width: 700,
                height: 250,
              )..transitionBuilder = null;
              shower.isWithTicker = true;

              int tapCount = 0;
              AnimationController? controller;
              shower.addShowCallBack((shower) {
                controller = ShowerHelper.createAnimationController(shower, duration: const Duration(milliseconds: 300));
                Animation<double> aniH = Tween<double>(begin: 1080, end: 250)
                    // .chain(CurveTween(curve: const Cubic(0.755, 0.05, 0.855, 0.06)))
                    .chain(CurveTween(curve: const Cubic(0.18, 1.0, 0.04, 1.0)))
                    .animate(controller!);
                Animation<double> aniW =
                    Tween<double>(begin: 0, end: 700).chain(CurveTween(curve: Curves.easeInSine)).animate(controller!);
                aniH.addListener(() {
                  shower.height = aniH.value;
                  shower.setState();
                });
                aniW.addListener(() {
                  shower.width = aniW.value;
                  shower.setState();
                });
                controller!.forward();
              });

              shower.barrierOnTapCallback = (shower, offset) {
                ++tapCount % 2 == 1 ? controller?.reverse() : controller?.forward();
                return true;
              };
              shower.dialogOnTapCallback = (shower, offset) {
                shower.dismiss();
                return false;
              };
            }),
            WidgetsUtil.newXpelTextButton('Animate with AnimatedContainer', onPressed: (state) {
              Btv<double> slideWidth = 150.0.btv;
              DialogShower shower = DialogWrapper.show(
                Btw(builder: (context) {
                  return Container(
                    color: Colors.redAccent,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      height: 200,
                      width: slideWidth.value,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [BoxShadow(color: Colors.green, blurRadius: 15.0)],
                      ),
                      duration: const Duration(milliseconds: 150),
                      child: const Text('Hola! Tap inside pls ...'),
                    ),
                  );
                }),
                width: 700,
                height: 250,
              )..transitionBuilder = null;
              shower.isWithTicker = true;

              int tapCount = 0;
              shower.dialogOnTapCallback = (shower, offset) {
                slideWidth.value = ++tapCount % 2 == 1 ? 500 : 150;
                return true;
              };
            }),
          ],
        ),
      ],
    );
  }

  DialogShower doBasicShow({Widget? child}) {
    DialogShower shower = DialogShower();
    shower
      ..barrierDismissible = true
      ..containerShadowColor = Colors.grey
      ..containerShadowBlurRadius = 50.0
      ..containerBorderRadius = 5.0
      ..showCallBack = (shower) {
        Logger.d('shower showCallBack');
      }
      ..dismissCallBack = (shower) {
        Logger.d('shower dismissCallBack');
      }
      ..wholeOnTapCallback = (shower, point, isTappedInside) {
        Logger.d('shower wholeOnTapCallback $point');
        return false;
      }
      ..dialogOnTapCallback = (shower, point) {
        Logger.d('shower dialogOnTapCallback $point');
        return false;
      }
      ..barrierOnTapCallback = (shower, point) {
        Logger.d('shower barrierOnTapCallback $point');
        return false;
      };
    shower.future.then((value) {
      Logger.d('shower future callback (on dismiss)');
    });
    shower.then((value) {
      Logger.d('shower then callback (on dismiss)');
    });
    shower.show(_container());
    return shower;
  }

  Container _container({String? text}) {
    return Container(
      width: _showerWidth,
      height: _showerHeight,
      alignment: Alignment.center,
      color: Colors.orangeAccent,
      child: Text(text ?? ''),
    );
  }

  get _showerWidth => 400 >= ScreensUtils.screenWidth ? ScreensUtils.screenWidth - 100 : 400.toDouble();

  get _showerHeight => 400 >= ScreensUtils.screenWidth ? ScreensUtils.screenWidth - 100 : 400.toDouble();
}
