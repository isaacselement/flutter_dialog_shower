import 'package:example/util/logger.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

import 'widgets/button_widgets.dart';

class PageOfHomeless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfHomeless] ----------->>>>>>>>>>>> build/rebuild!!!");
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
    EventTruck.on((object) {
      print('1 >>>>>>>>>>>>>>>>>> $object');
    }, key: 'id_1');
    EventTruck.on((object) {
      print('2 >>>>>>>>>>>>>>>>>> $object');
    }, key: 'id_2');

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              XpTextButton('EventTruck', onPressed: () {
                print('>>>>>>>>>>>>>>>>>> fire');
                EventTruck.fire('object value');
              }),
            ],
          )
        ],
      ),
    );
  }


}
