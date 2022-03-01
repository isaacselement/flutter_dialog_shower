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
    return SingleChildScrollView(child: buildContainer());
  }

  Widget buildContainer() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            PageOfKeyboard.getHeaderWidget('Navigator inner shower'),
            const SizedBox(height: 8),
            buildButtonsAboutNavigator(),
          ],
        ));
  }

  Widget buildButtonsAboutNavigator() {
    return Column(
      children: [
        Row(
          children: [
            WidgetsUtil.newXpelTextButton('Show with navigator with Width & Height', onPressed: () {
              DialogWrapper.pushRoot(PageOfKeyboard.getClickMeWidget(fnClickMe: (context) {
                rootBundle.loadString('assets/json/NO.json').then((string) {
                  List<dynamic> value = json.decode(string);
                  DialogWrapper.push(PageOfKeyboard.getSelectableListWidget(value),
                      settings: const RouteSettings(name: '__root_route__'));
                });
              }), width: 600, height: 700);
            }),
            WidgetsUtil.newXpelTextButton('Show with navigator without W&H (Auto size)', onPressed: () {
              DialogWrapper.pushRoot(PageOfKeyboard.getClickMeWidget(fnClickMe: (context) {
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
