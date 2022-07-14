import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/shower_helper.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfWidgets extends StatelessWidget {
  const PageOfWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfWidgets] ----------->>>>>>>>>>>> build/rebuild!!!");

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
      children: [
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Loadings'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show loading', onPressed: (state) {
              DialogShower shower = DialogWidgets.showLoading(dismissible: true);
              int count = 11;
              ShowerHelper.stopwatchTimer(
                count: count,
                tik: (i) {
                  if (!shower.isShowing) return true;
                  String msg = 'Hola~~ ${i}s ~~~~';
                  if (i >= 3) msg = 'Communicating...';
                  if (i >= 4) msg = 'Uploading...';
                  if (i >= 6) msg = 'Downloading...';
                  if (i >= 8) msg = 'Waiting...';
                  if (i >= 10) msg = 'Done!';
                  DialogWidgets.setLoadingText(msg);
                  if (i == count - 1) {
                    DialogWrapper.dismissDialog(shower);
                  }
                  return false;
                },
              );
              Future.delayed(const Duration(milliseconds: 3000), () {
                Logger.d('shower: ${shower.routeName}, route is active: ${shower.route.isActive}');
              });
            }),
            WidgetsUtil.newXpelTextButton('show loading, unrotate unstiff', onPressed: (state) {
              DialogWidgets.showLoading(dismissible: true, isPaintAnimation: true, isPaintStartStiff: false, isPaintWrapRotate: false);
            }),
            WidgetsUtil.newXpelTextButton('show loading, unrotate stiff', onPressed: (state) {
              DialogWidgets.showLoading(dismissible: true, isPaintAnimation: true, isPaintStartStiff: true, isPaintWrapRotate: false);
            }),
            WidgetsUtil.newXpelTextButton('show loading, rotate stiff', onPressed: (state) {
              DialogWidgets.showLoading(dismissible: true, isPaintAnimation: true, isPaintStartStiff: true, isPaintWrapRotate: true);
            }),
            WidgetsUtil.newXpelTextButton('show loading, rotate stiff with slower', onPressed: (state) {
              DialogWidgets.showLoading(
                dismissible: true,
                isPaintAnimation: true,
                isPaintStartStiff: true,
                isPaintWrapRotate: true,
                duration: const Duration(milliseconds: 1500),
              );
            }),
            WidgetsUtil.newXpelTextButton('show loading, rotate unstiff', onPressed: (state) {
              DialogWidgets.showLoading(dismissible: true, isPaintAnimation: true, isPaintStartStiff: false, isPaintWrapRotate: true);
            }),
            WidgetsUtil.newXpelTextButton('show loading paint example', onPressed: (state) {
              DialogWidgets.showIconText(
                icon: PainterWidgetUtil.getOnePainterWidget(
                  size: const Size(64, 64),
                  isRepeat: false,
                  isRepeatWithReverse: false,
                  duration: const Duration(milliseconds: 2000),
                  painter: (progress) {
                    return LoadingIconPainter(radius: 32, strokeWidth: 4.0, ratioStart: 0, ratioLength: progress);
                  },
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Alert Result'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show success', onPressed: (state) {
              DialogWidgets.showSuccess(dismissible: true);
            }),
            WidgetsUtil.newXpelTextButton('show failed', onPressed: (state) {
              DialogWidgets.showFailed(dismissible: true);
            }),
          ],
        ),
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Alerts Message/Notification'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show message', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 50,
                text: 'Hey, you are here!',
                onOptions: (options) {
                  options.textSpacing = 0;
                },
              );
            }),
            WidgetsUtil.newXpelTextButton('show title message', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 200,
                title: 'Attention Please!',
                text: 'A view of the sea when the author was a child made the author invisibly.',
                onOptions: (options) {
                  options.textSpacing = 50.0;
                  options.alignment = MainAxisAlignment.start;
                  options.padding = const EdgeInsets.only(top: 16, left: 16, right: 16);
                },
              );
            }),
            WidgetsUtil.newXpelTextButton('show title icon message', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 240,
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 100, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
                onOptions: (options) {
                  options.alignment = MainAxisAlignment.start;
                  options.padding = const EdgeInsets.only(top: 16, left: 16, right: 16);
                },
              ).barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('show title icon message with button', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 270,
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 80, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
                buttonLeftText: 'OK',
                buttonLeftEvent: (D) => DialogWrapper.dismissTopDialog(),
                onOptions: (options) {
                  options.alignment = MainAxisAlignment.start;
                  options.padding = const EdgeInsets.only(top: 16, left: 16, right: 16);
                },
              );
            }),
            WidgetsUtil.newXpelTextButton('show notification', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 240,
                title: 'Notification',
                text: 'The man of this car does not belong to you. '
                    'For further understanding, please go to the CS4 store and view the specific tyre and car information.',
                buttonLeftText: 'Cancel',
                buttonRightText: 'Go to view',
                buttonLeftEvent: (d) => DialogWrapper.dismissDialog(d),
                buttonRightEvent: (d) => DialogWrapper.dismissTopDialog().then((value) {
                  Logger.d('joking...');
                }),
                onOptions: (options) {
                  options.titleStyle = const TextStyle(fontSize: 20, color: Color(0xFF1C1D21));
                  options.textStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1D21));
                  options.buttonLeftTextStyle = const TextStyle(color: Color(0xFF4E7DF7));
                  options.buttonRightTextStyle = const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4E7DF7));
                  options.alignment = MainAxisAlignment.start;
                  options.padding = const EdgeInsets.only(top: 32, left: 32, right: 32);
                },
              ).barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('show message with rebuild', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 270,
                title: 'Hola',
                icon: const Icon(Icons.info, size: 80, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
                buttonLeftText: 'OK',
                buttonLeftEvent: (D) => DialogWrapper.dismissTopDialog(),
                buttonRightText: 'Next One',
                buttonRightEvent: (d) {
                  BuildContext? context = d.containerKey.currentContext;
                  AnyAlertTextWidget? widget = ElementsUtil.getWidgetOfType<AnyAlertTextWidget>(context);
                  widget?.title = ['OnePlus', 'Vivo', 'Oppo', 'XiaoMi'].elementAt(Random().nextInt(4));
                  widget?.text = ['Not a joke ~~~', 'Apple iPhone 14', 'An Undefined Phone'].elementAt(Random().nextInt(3));
                  Color color = [Colors.red, Colors.green, Colors.orange].elementAt(Random().nextInt(3));
                  widget?.icon = Icon(Icons.info, size: 80, color: color);
                  ElementsUtil.rebuildWidget(context, widget);
                  Logger.d('joking...');
                },
                onOptions: (options) {
                  options.alignment = MainAxisAlignment.start;
                  options.alignment = MainAxisAlignment.start;
                  options.padding = const EdgeInsets.only(top: 16, left: 16, right: 16);
                },
              );
            }),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
