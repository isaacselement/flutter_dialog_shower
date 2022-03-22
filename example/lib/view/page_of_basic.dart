import 'package:example/util/logger.dart';
import 'package:example/util/size_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class PageOfBasic extends StatelessWidget {
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
        WidgetsUtil.newDescptions('DialogWrapper is a wrapper for DialogShower. '),
        WidgetsUtil.newDescptions(
            'Using DialogWrapper, you can very easy to show a dialog and modify it\'s properties, and take the management of Your ALL Showing Dialogs'),
        const SizedBox(height: 12),
        demoUsageOfDialogWrapper(),
        const SizedBox(height: 12),
      ],
    );
  }

  Column demoUsageOfDialogShower() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show from bottom', onPressed: () {
              doBasicShow();
            }),
            WidgetsUtil.newXpelTextButton('Show from left', onPressed: () {
              doBasicShow().animationBeginOffset = const Offset(-1.0, 0.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from right', onPressed: () {
              doBasicShow().animationBeginOffset = const Offset(1.0, 0.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top', onPressed: () {
              doBasicShow().animationBeginOffset = const Offset(0.0, -1.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top left', onPressed: () {
              doBasicShow().animationBeginOffset = const Offset(-1.0, -1.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top right', onPressed: () {
              doBasicShow().animationBeginOffset = const Offset(1.0, -1.0);
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show in left', onPressed: () {
              DialogShower shower = doBasicShow();
              shower.animationBeginOffset = const Offset(-1.0, 0.0);
              shower.alignment = Alignment.centerLeft;
              shower.padding = const EdgeInsets.only(left: 5);
            }),
            WidgetsUtil.newXpelTextButton('Show in right', onPressed: () {
              DialogShower shower = doBasicShow();
              shower.animationBeginOffset = const Offset(1.0, 0.0);
              shower.alignment = Alignment.centerRight;
              shower.padding = const EdgeInsets.only(right: 5);
            }),
            WidgetsUtil.newXpelTextButton('Show in bottom', onPressed: () {
              DialogShower shower = doBasicShow();
              shower.animationBeginOffset = const Offset(0.0, 1.0);
              shower.alignment = Alignment.bottomCenter;
              shower.padding = const EdgeInsets.only(bottom: 5);
              // barrier color
              shower.barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('Show in top', onPressed: () {
              DialogShower shower = doBasicShow();
              shower.animationBeginOffset = const Offset(0.0, -1.0);
              shower.alignment = Alignment.topCenter;
              shower.padding = EdgeInsets.only(top: SizeUtil.statuBarHeight);
              // background color
              shower.scaffoldBackgroundColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('Show with position x y', onPressed: () {
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
            WidgetsUtil.newXpelTextButton('Shower dismiss manually', onPressed: () {
              DialogShower shower = DialogShower();
              shower
                ..build()
                ..barrierDismissible = false
                ..dismissCallBack = (shower) {
                  Logger.d('shower dismissCallBack');
                };
              shower.show(Container(
                width: _showerWidth,
                height: _showerHeight,
                color: Colors.lightGreen,
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: WidgetsUtil.newXpelTextButton('Click to Dismiss', onPressed: () {
                  shower.dismiss();
                }),
              ));
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first using wholeOnTapCallback', onPressed: () {
              DialogShower shower = DialogShower();
              shower
                ..build()
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
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first using barrierOnTapCallback', onPressed: () {
              DialogShower shower = DialogShower();
              shower
                ..build()
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
            WidgetsUtil.newXpelTextButton('Shower dismiss keyboard first with setting barrierDismissible to null', onPressed: () {
              DialogShower shower = DialogShower();
              shower
                ..build()
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
            WidgetsUtil.newXpelTextButton('DialogWrapper Show Cupertino Indicator', onPressed: () {
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
            WidgetsUtil.newXpelTextButton('Show with DialogWrapper', onPressed: () {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).futurePushed.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).futurePushed.then((value) {
                  DialogWrapper.showRight(_container(text: '3')).futurePushed.then((value) {
                    DialogWrapper.showBottom(_container(text: '4')).futurePushed.then((value) {
                      DialogWrapper.show(_container(text: 'Click any where out of this box'))
                        ..animationBeginOffset = const Offset(0.0, -1.0)
                        ..alignment = Alignment.topCenter
                        ..padding = EdgeInsets.only(top: SizeUtil.statuBarHeight);
                    });
                  });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss all dialogs', onPressed: () {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).futurePushed.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).futurePushed.then((value) {
                  DialogWrapper.showRight(_container(text: '3')).futurePushed.then((value) {
                    DialogWrapper.showBottom(_container(text: '4')).futurePushed.then((value) {
                      DialogWrapper.show(_container(text: 'Click any where out of this box'))
                        ..animationBeginOffset = const Offset(0.0, -1.0)
                        ..alignment = Alignment.topCenter
                        ..padding = EdgeInsets.only(top: SizeUtil.statuBarHeight)
                        ..future.then((value) => DialogWrapper.dismissAppearingDialogs());
                    });
                  });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss the dialog on top', onPressed: () {
              DialogWrapper.show(_container(text: '1'), width: 200, height: 200).futurePushed.then((value) {
                DialogWrapper.showLeft(_container(text: '2')).futurePushed.then((value) {
                  DialogWrapper.showRight(_container(text: 'Will auto dismiss after 2 seconds'))
                    ..barrierDismissible = false
                    ..futurePushed.then((value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        // DialogWrapper.dismissTopDialog();
                        DialogWrapper.getTopDialog()?.dismiss();
                      });
                    });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss the dialog With key', onPressed: () {
              DialogWrapper.show(_container(text: 'I\'m key1'), key: '__key1__', width: 200, height: 200).futurePushed.then((value) {
                DialogWrapper.showLeft(_container(text: 'I\'m key2'), key: '__key2__').futurePushed.then((value) {
                  DialogWrapper.showRight(_container(text: 'I\'m key3'), key: '__key3__')
                    ..barrierDismissible = false
                    ..futurePushed.then((value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        DialogWrapper.dismissDialog(null, key: '__key3__');
                        DialogWrapper.dismissDialog(null, key: '__key2__'); // will dismiss all dialog on top of me
                      });
                    });
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('DialogWrapper dismiss the dialog With key', onPressed: () {
              DialogWrapper.show(_container(text: 'I\'m key1'), key: '__key1__', width: 200, height: 200).futurePushed.then((value) {
                DialogWrapper.showLeft(_container(text: 'I\'m key2'), key: '__key2__').futurePushed.then((value) {
                  DialogWrapper.showRight(_container(text: 'I\'m key3'), key: '__key3__')
                    ..barrierDismissible = false
                    ..futurePushed.then((value) {
                      Future.delayed(const Duration(seconds: 2), () {
                        DialogWrapper.dismissDialog(null, key: '__key1__'); // will dismiss all dialog on top of me
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

  DialogShower doBasicShow({Widget? child}) {
    DialogShower shower = DialogShower();
    shower
      ..build()
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

  get _showerWidth => 400 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 400.toDouble();

  get _showerHeight => 400 >= SizeUtil.screenWidth ? SizeUtil.screenWidth - 100 : 400.toDouble();
}
