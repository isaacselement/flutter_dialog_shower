import 'dart:convert';

import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

import '../util/logger.dart';
import 'page_of_keyboard.dart';

class PageOfNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfNavigator] ----------->>>>>>>>>>>> build/rebuild!!!");
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
          WidgetsUtil.newHeaderWithGradient('Navigator inner shower'),
          const SizedBox(height: 16),
          buildButtonsAboutNavigator(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutNavigator() {
    String desc = 'Tap \'Click me\' button for pushing a view in using navigator';
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show with navigator with Width & Height', onPressed: () {
              DialogWrapper.pushRoot(
                  WidgetsUtil.newClickMeWidget(
                      text: desc,
                      fnClickMe: (context) {
                        rootBundle.loadString('assets/json/NO.json').then((string) {
                          List<dynamic> value = json.decode(string);
                          DialogWrapper.push(PageOfKeyboard.getSelectableListWidget(value),
                              settings: const RouteSettings(name: '__root_route__'));
                        });
                      }),
                  width: 600,
                  height: 700);
            }),
            WidgetsUtil.newXpelTextButton('Show with navigator without W&H (Auto size)', onPressed: () {
              DialogWrapper.pushRoot(WidgetsUtil.newClickMeWidget(
                  text: desc,
                  fnClickMe: (context) {
                    rootBundle.loadString('assets/json/NO.json').then((string) {
                      List<dynamic> value = json.decode(string);
                      DialogWrapper.push(PageOfKeyboard.getSelectableListWidget(value),
                          settings: const RouteSettings(name: '__root_route__'));
                    });
                  }));
            }),
          ],
        )
      ],
    );
  }
}
