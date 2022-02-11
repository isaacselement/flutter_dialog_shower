import 'package:example/util/logger.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialog_shower/events/event_truck.dart';

class PageOfWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d('[PageOfWidgets] ----------->>>>>>>>>>>> build/rebuild!!!');
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
              PageOfKeyboard.getButton('EventTruck', onPressed: () {
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
