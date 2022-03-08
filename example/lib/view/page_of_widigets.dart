import 'dart:math';

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';
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
              DialogWidgets.showSuccess(
                  dismissible: true,
                  icon: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.only(left: 5, top: 10),
                    // color: Colors.yellow,
                    child: CommonStatefulWidgetWithTicker(
                      initState: (state) {
                        AnimationController _controller = AnimationController(vsync: state, duration: const Duration(milliseconds: 500));
                        Broker.setIfAbsent<AnimationController>(_controller, key: '_key_of_yes_animation_controller_');
                        _controller.forward();
                        print('Broker.... map initState ${Broker.instance.map}');
                      },
                      dispose: (state) {
                        Broker.remove<AnimationController>('_key_of_yes_animation_controller_')?.dispose();
                        print('Broker.... map ${Broker.instance.map}');
                      },
                      builder: (state, context) {
                        AnimationController? _controller = Broker.get(key: '_key_of_yes_animation_controller_');
                        assert(_controller != null, '_controller cannot be null, should init in initState');
                        return AnimatedBuilder(
                            animation: _controller!,
                            builder: (context, snapshot) {
                              return CustomPaint(
                                painter: YesIconPainter(width: 90, height: 60, stroke: 16, progress: _controller.value),
                              );
                            });
                      },
                    ),
                  ));
            }),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Convenient Widget for being easy to use
class CommonStatefulWidget<T extends CommonStatefulWidgetState> extends StatefulWidget {
  CommonStatefulWidget({Key? key, this.builder, this.initState, this.dispose}) : super(key: key);

  void Function(T state)? initState;
  void Function(T state)? dispose;
  Widget Function(T state, BuildContext context)? builder;

  @override
  T createState() => CommonStatefulWidgetState() as T;
}

class CommonStatefulWidgetState extends State<CommonStatefulWidget> {
  @override
  void initState() {
    widget.initState?.call(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose?.call(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.builder != null, 'Cannot provide a null builder !!!');
    return widget.builder!(this, context);
  }
}

class CommonStatefulWidgetWithTicker extends CommonStatefulWidget {
  CommonStatefulWidgetWithTicker({Key? key, builder, initState, dispose})
      : super(key: key, builder: builder, initState: initState, dispose: dispose);

  @override
  CommonStatefulWidgetWithTickerState createState() => CommonStatefulWidgetWithTickerState();
}

class CommonStatefulWidgetWithTickerState extends CommonStatefulWidgetState with SingleTickerProviderStateMixin {}

class CommonStatefulWidgetWithTickers extends CommonStatefulWidget {
  CommonStatefulWidgetWithTickers({Key? key, builder, initState, dispose})
      : super(key: key, builder: builder, initState: initState, dispose: dispose);

  @override
  CommonStatefulWidgetWithTickersState createState() => CommonStatefulWidgetWithTickersState();
}

class CommonStatefulWidgetWithTickersState extends CommonStatefulWidgetState with TickerProviderStateMixin {}

class YesIconPainter extends CustomPainter {
  double width, height;
  double? stroke;
  Color? color;
  double? progress;

  YesIconPainter({required this.width, required this.height, this.stroke, this.color, this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? 25
      ..color = color ?? Colors.white;

    if (progress != null) {
      double p = progress!;

      // the best ratio is width: height is 3 : 2
      Path path = Path();
      double shortLineX = 0;
      double shortLineY = height / 2;
      double shortLineW = width / 3;

      path.moveTo(shortLineX, shortLineY);

      double ratio = p * 2;
      double ratioShort = ratio <= 1 ? ratio : 1, ratioLong = ratio >= 1 ? ratio - 1 : 0;

      // draw short line & long line
      path.lineTo(shortLineX + (shortLineW - shortLineX) * ratioShort, shortLineY + (height - shortLineY) * ratioShort);
      if (ratioLong != 0) {
        path.lineTo(shortLineW + (width - shortLineW) * ratioLong, height - ratioLong * height);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant YesIconPainter oldDelegate) => oldDelegate.progress != progress;
}
