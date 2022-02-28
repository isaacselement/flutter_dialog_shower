import 'package:example/util/logger.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

class PageOfBasic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBasic] ----------->>>>>>>>>>>> build/rebuild!!!");
    return SingleChildScrollView(child: buildContainer());
  }

  Widget buildContainer() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
          ],
        ));
  }

}
