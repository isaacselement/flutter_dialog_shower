import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';
import 'package:flutter_dialog_shower/core/dialog_widgets.dart';

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
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show loading', onPressed: () {
              DialogWidgets.showLoading(dismissible: true);
            }),
            WidgetsUtil.newXpelTextButton('show success', onPressed: () {
              DialogWidgets.showSuccess(dismissible: true);
            }),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
