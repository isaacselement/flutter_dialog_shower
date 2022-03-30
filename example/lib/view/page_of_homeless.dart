import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

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
    EventTruck.onWithKey(
      key: 'event_key_1',
      onData: (object) {
        print('1 >>>>>>>>>>>>>>>>>> $object');
      },
    );
    EventTruck.onWithKey(
      key: 'event_key_2',
      onData: (object) {
        print('2 >>>>>>>>>>>>>>>>>> $object');
      },
    );

    return Container(
      child: Column(
        children: [
          Wrap(
            children: [
              WidgetsUtil.newXpelTextButton('Event Truck Fire', onPressedState: (state) {
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
