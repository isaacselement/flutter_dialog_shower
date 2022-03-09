import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';
import 'package:flutter_dialog_shower/core/dialog_widgets.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class PageOfWidgets extends StatelessWidget {
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
        WidgetsUtil.newHeaderWithLine('Tips'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show loading', onPressed: () {
              DialogWidgets.showLoading(dismissible: true);
            }),
            WidgetsUtil.newXpelTextButton('show success', onPressed: () {
              DialogWidgets.showSuccess(dismissible: true);
            }),
            WidgetsUtil.newXpelTextButton('show failed', onPressed: () {
              DialogWidgets.showFailed(dismissible: true);
            }),
          ],
        ),
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('Alerts'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show message', onPressed: () {
              DialogWidgets.showAlert(width: 360, height: 50, text: 'Hey, you are here!');
            }),
            WidgetsUtil.newXpelTextButton('show title message', onPressed: () {
              DialogWidgets.showAlert(
                  width: 360,
                  height: 200,
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  title: 'Attention Please!',
                  titleBottomGap: 50,
                  text: 'A view of the sea when the author was a child made the author invisibly.');
            }),
            WidgetsUtil.newXpelTextButton('show title icon message', onPressed: () {
              DialogWidgets.showAlert(
                width: 360,
                height: 240,
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 100, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
              ).barrierColor = const Color(0x4D1C1D21);
            }),
            WidgetsUtil.newXpelTextButton('show title icon message with button', onPressed: () {
              DialogWidgets.showAlert(
                width: 360,
                height: 270,
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                title: 'Attention Please!',
                icon: const Icon(Icons.info, size: 100, color: Colors.green),
                text: 'A view of the sea when the author was a child made the author invisibly.',
                button1Text: 'OK',
                button1Event: (D) => DialogWrapper.dismissTopDialog(),
              );
            }),
            WidgetsUtil.newXpelTextButton('show notification', onPressed: () {
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
                button2Event: (d) => DialogWrapper.dismissTopDialog().then((value) => print('joking...')),
              ).barrierColor = const Color(0x4D1C1D21);
            }),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
