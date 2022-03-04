import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_widgets.dart';

class CirclePainter extends CustomPainter {
  double radius;

  double strokeWidth;

  CirclePainter({required this.radius, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    double side = radius * 2 - strokeWidth;
    var paintOne = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.white
      ..style = PaintingStyle.stroke;
    var paintTow = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.withAlpha(128)
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCenter(center: Offset.zero, width: side, height: side), 0, 2 * pi / 6 * 5, false, paintOne);
    canvas.drawArc(Rect.fromCenter(center: Offset.zero, width: side, height: side), 2 * pi / 6 * 5, 2 * pi, false, paintTow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PageOfWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfWidgets] ----------->>>>>>>>>>>> build/rebuild!!!");
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

  PageOfWidgets({Key? key}) : super(key: key) {}

  Widget buildContainer() {
    DialogWidgets.tipsDefColor = const Color(0xCC1C1D21);
    DialogWidgets.tipsDefTextStyle = const TextStyle(color: Colors.white, fontSize: 16);

    DialogWidgets.iconLoading = const Icon(Icons.change_circle, size: 100);
    DialogWidgets.iconLoading = getAAAA();

    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show loading', onPressed: () {
              DialogWidgets.showLoading(dismissible: true);
            }),
          ],
        ),
        const SizedBox(height: 200),
        getAAAA(),
      ],
    );
  }

  Container getAAAA() {
    return Container(
      color: Colors.red,
      width: 120,
      height: 120,
      alignment: Alignment.center,
      child: CustomPaint(
        painter: CirclePainter(radius: 120 / 2, strokeWidth: 20),
      ),
    );
  }
}
