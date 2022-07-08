// ignore_for_file: must_be_immutable

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class RotateWidget extends StatefulWidget {
  Widget child;
  bool? isClockwise;
  Duration? duration;

  RotateWidget({Key? key, required this.child, this.isClockwise, this.duration}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RotateWidgetState();
}

class RotateWidgetState extends State<RotateWidget> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final double _circle = 2 * math.pi;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1000),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        double angle = animationController.value * _circle;
        return Transform.rotate(
          angle: widget.isClockwise == false ? -angle : angle,
          child: child,
        );
      },
    );
  }
}
