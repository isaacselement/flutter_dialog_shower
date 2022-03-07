import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_widgets.dart';

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

  Widget buildContainer() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('show loading', onPressed: () {
              DialogWidgets.showLoading(dismissible: true);
            }),
            WidgetsUtil.newXpelTextButton('show success', onPressed: () {
              DialogWidgets.showSuccess(dismissible: true);
            }),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 270,
          height: 180,
          color: Colors.grey,
          child: CustomPaint(
            painter: YesPainter(width: 270, height: 180),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: 270,
          height: 180,
          color: Colors.grey,
          child: const YesWidget(),
        ),
      ],
    );
  }
}

class YesWidget extends StatefulWidget {
  const YesWidget({Key? key}) : super(key: key);
  @override
  _YesWidgetState createState() => _YesWidgetState();
}

class _YesWidgetState extends State<YesWidget> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: 270,
      height: 180,
      color: Colors.grey,
      child: CustomPaint(
        painter: YesPainter(width: 270, height: 180, progress: animationController.value),
      ),
    );
    return AnimatedBuilder(
      child: child,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: animationController.value * 6.3,
          child: child,
        );
      },
      animation: animationController,
    );

  }
}

class YesPainter extends CustomPainter {
  double width, height;
  double? stroke;
  Color? color;

  double? progress;

  YesPainter({required this.width, required this.height, this.stroke, this.color, this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? 30
      ..color = color ?? Colors.green;

    // the best ratio is width: height is 3 : 2
    Path path = Path();
    double startX = 0;
    double startY = height / 2;

    path.moveTo(startX, startY);

    double ratio = (progress ?? 1.0) * 2;
    double ratio1 = ratio <= 1 ? ratio : 1;
    double ratio2 = ratio >= 1 ? ratio - 1 : 0;

    print('>>>>>> $ratio, $ratio1, $ratio2');

    path.lineTo(startX + (width / 3 - startX) * ratio1, startY + (height - startY) * ratio1);

    if (ratio2 != 0) {
      path.lineTo(width / 3 + (width - width / 3) * ratio2, height - ratio2 * height);
    }

    // path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant YesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
