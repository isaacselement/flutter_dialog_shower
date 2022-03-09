import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

class PageOfHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfHome] ----------->>>>>>>>>>>> build/rebuild!!!");
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
      child: Column(
        children: [
          const SizedBox(height: 20),
          WidgetsUtil.newHeaderWithLine('User is God'),
          WidgetsUtil.newDescptions('Mor demonstrations are on the way ...'),
          const SizedBox(height: 200),
          WidgetsUtil.newHeaderWithLine('Feel free to use DialogShower & Brother :)')
        ],
      ),
    );
  }
}
