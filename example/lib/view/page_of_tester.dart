import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/page_of_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfTester extends StatelessWidget {
  PageOfTester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfTester] ----------->>>>>>>>>>>> build/rebuild!!!");

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
          WidgetsUtil.newHeaderWithGradient('Tester'),
          const SizedBox(height: 16),
          _buildTapWidget(),
        ],
      ),
    );
  }

  AntiBouncer? antiBouncer;
  int antiIndex = 0;
  bool isPinging = false;

  Widget _buildTapWidget() {
    return Column(
      children: [
        Wrap(
          children: [
            CcTapWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapWidget ~~~~');
              },
            ),
            CcTapOnceWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapOnceWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapOnceWidget ~~~~');
              },
            ),
            CcTapThrottledWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapThrottledWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapThrottledWidget ~~~~');
              },
            ),
            CcTapDebouncerWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapDebouncerWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapDebouncerWidget ~~~~');
              },
            ),
            CcTapWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('Test anti bouncer'),
              ),
              onTap: (state) {
                antiIndex++;
                print('@@@@@@@@@@@@@----> $antiIndex, length: ${antiBouncer?.queue.length}');

                antiBouncer ??= AntiBouncer(shouldBeInvoked: () {
                  return !isPinging;
                });
                antiBouncer?.call(() async {
                  isPinging = true;
                  int waiteMillisSeconds = 5000;
                  if (Random().nextBool()) {
                    waiteMillisSeconds = waiteMillisSeconds + 1000;
                  }
                  print('${DateTime.now()} @@@@@@@@@@@@@ call index ----> $antiIndex, $waiteMillisSeconds');
                  await Future.delayed(Duration(milliseconds: waiteMillisSeconds));

                  isPinging = false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
