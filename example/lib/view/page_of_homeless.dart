import 'package:example/util/logger.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

class PageOfHomeless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,

      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
              return smallestContainer();
            },
          );
        },
      ),
      // child: smallestContainer(),

    );
  }

  Widget smallestContainer() {
    return Container(
      color: Colors.red,
      child: SizedBox(
        width: 300,
        height: 300,
        // color: Colors.lightGreen,
        child: Center(
          child: CupertinoButton(
            child: const Text('Hey man!'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
