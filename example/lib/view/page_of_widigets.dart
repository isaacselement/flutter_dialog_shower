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
              int count = 9;
              ShowerHelper.stopwatchTimer(
                count: count,
                tik: (i) {
                  DialogWidgets.setLoadingText('Hola~!~ $i ~~~~');
                  if (i == count - 1) {
                    DialogWrapper.dismissDialog(shower);
                  }
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
        WidgetsUtil.newHeaderWithLine('Tips'),
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
        WidgetsUtil.newHeaderWithLine('Alerts'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show message', onPressed: (state) {
              DialogWidgets.showAlert(width: 360, height: 50, text: 'Hey, you are here!');
            }),
            WidgetsUtil.newXpelTextButton('show title message', onPressed: (state) {
              DialogWidgets.showAlert(
                  width: 360,
                  height: 200,
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  title: 'Attention Please!',
                  titleBottomGap: 50,
                  text: 'A view of the sea when the author was a child made the author invisibly.');
            }),
            WidgetsUtil.newXpelTextButton('show title icon message', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 240,
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 100, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
              ).barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('show title icon message with button', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 270,
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 80, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
                button1Text: 'OK',
                button1Event: (D) => DialogWrapper.dismissTopDialog(),
              );
            }),
            WidgetsUtil.newXpelTextButton('show notification', onPressed: (state) {
              DialogWidgets.showAlert(
                width: 360,
                height: 240,
                padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                title: 'Notification',
                titleStyle: const TextStyle(fontSize: 20, color: Color(0xFF1C1D21)),
                text: 'The man of this car does not belong to you. '
                    'For further understanding, please go to the CS4 store and view the specific tyre and car information.',
                textStyle: const TextStyle(fontSize: 14, color: Color(0xFF1C1D21)),
                button1Text: 'Cancel',
                button2Text: 'Go to view',
                button1TextStyle: const TextStyle(color: Color(0xFF4E7DF7)),
                button2TextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4E7DF7)),
                button1Event: (d) => DialogWrapper.dismissDialog(d),
                button2Event: (d) => DialogWrapper.dismissTopDialog().then((value) {
                  Logger.d('joking...');
                }),
              ).barrierColor = const Color(0x4D1C1D21);
            }),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
