import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/event/event_truck.dart';

class PageOfBasic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBasic] ----------->>>>>>>>>>>> build/rebuild!!!");
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
        const SizedBox(height: 12),
        WidgetsUtil.newHeaderWithLine('DialogShower'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show from bottom', isSmallest: true, onPressed: () {
              basicShow();
            }),
            WidgetsUtil.newXpelTextButton('Show from left', isSmallest: true, onPressed: () {
              basicShow().animationBeginOffset = const Offset(-1.0, 0.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from right', isSmallest: true, onPressed: () {
              basicShow().animationBeginOffset = const Offset(1.0, 0.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top', isSmallest: true, onPressed: () {
              basicShow().animationBeginOffset = const Offset(0.0, -1.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top left', isSmallest: true, onPressed: () {
              basicShow().animationBeginOffset = const Offset(-1.0, -1.0);
            }),
            WidgetsUtil.newXpelTextButton('Show from top right', isSmallest: true, onPressed: () {
              basicShow().animationBeginOffset = const Offset(1.0, -1.0);
            }),
            WidgetsUtil.newXpelTextButton('Show to left', isSmallest: true, onPressed: () {
              DialogShower shower = basicShow();
              shower.animationBeginOffset = const Offset(-1.0, 0.0);
              shower.alignment = Alignment.centerLeft;
              shower.margin = const EdgeInsets.only(left: 16);
            }),
            WidgetsUtil.newXpelTextButton('Show to right', isSmallest: true, onPressed: () {
              DialogShower shower = basicShow();
              shower.animationBeginOffset = const Offset(1.0, 0.0);
              shower.alignment = Alignment.centerRight;
              shower.margin = const EdgeInsets.only(right: 16);
            }),
            WidgetsUtil.newXpelTextButton('Show x y', isSmallest: true, onPressed: () {
              double x = 120;
              double y = 120;
              DialogShower shower = basicShow();
              shower
                ..alignment = Alignment.topLeft
                ..margin = EdgeInsets.only(left: x, top: y);
            }),
            WidgetsUtil.newXpelTextButton('Shower dimiss manually', isSmallest: true, onPressed: () {
              DialogShower shower = DialogShower();
              shower
                ..build()
                ..barrierDismissible = false
                ..dismissCallBack = (shower) {
                  Logger.d('shower dismissCallBack');
                };
              shower.show(Container(
                width: 200,
                height: 200,
                color: Colors.lightGreen,
                child: CupertinoButton(
                    child: const Text('Click to Dismiss'),
                    onPressed: () {
                      shower.dismiss();
                    }),
              ));
            }),
          ],
        ),
      ],
    );
  }

  DialogShower basicShow({Widget? child}) {
    DialogShower shower = DialogShower();
    shower
      ..build()
      ..barrierDismissible = true
      ..containerShadowColor = Colors.grey
      ..containerShadowBlurRadius = 50.0
      ..containerBorderRadius = 5.0
      ..showCallBack = (shower) {
        Logger.d('shower showCallBack');
      }
      ..dismissCallBack = (shower) {
        Logger.d('shower dismissCallBack');
      }
      ..wholeOnTapCallback = (shower, point) {
        Logger.d('shower wholeOnTapCallback $point');
        return false;
      }
      ..dialogOnTapCallback = (shower, point) {
        Logger.d('shower dialogOnTapCallback $point');
        return false;
      }
      ..barrierOnTapCallback = (shower, point) {
        Logger.d('shower barrierOnTapCallback $point');
        return false;
      };
    shower.future.then((value) {
      Logger.d('shower future callback (on dismiss)');
    });
    shower.then((value) {
      Logger.d('shower then callback (on dismiss)');
    });
    shower.show(Container(width: 400, height: 400, color: Colors.orangeAccent));
    return shower;
  }
}
