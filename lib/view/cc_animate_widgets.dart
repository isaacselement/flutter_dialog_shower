// ignore_for_file: must_be_immutable

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

/// A Repeated Spin Widget
class RotateWidget extends StatefulWidget {
  final Widget child;
  final Curve? curve;
  final bool? isRepeat;
  final bool? isClockwise;
  final Duration? duration;

  const RotateWidget({Key? key, required this.child, this.isClockwise, this.duration, this.curve, this.isRepeat}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RotateWidgetState();
}

class RotateWidgetState extends State<RotateWidget> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final double _circle = 2 * math.pi;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: widget.duration ?? const Duration(milliseconds: 1000));
    widget.isRepeat ?? true ? animationController.repeat() : animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation amination = animationController;
    if (widget.curve != null) {
      amination = CurvedAnimation(parent: animationController, curve: widget.curve!);
    }
    return AnimatedBuilder(
      child: widget.child,
      animation: amination,
      builder: (BuildContext context, Widget? child) {
        double angle = animationController.value * _circle;
        return Transform.rotate(child: child, angle: widget.isClockwise == false ? -angle : angle);
      },
    );
  }
}

/// Transform Widget such as for Icons.arrow_back_ios
class TransformZaxisWidget extends StatelessWidget {
  const TransformZaxisWidget({Key? key, this.child, this.ratio}) : super(key: key);

  final Widget? child;
  final double? ratio; // [0.0 - 2.0] * pi for on circle angle

  @override
  Widget build(BuildContext context) {
    return Transform(
      child: child,
      alignment: Alignment.center,
      transform: Matrix4.rotationZ((ratio ?? 1) * math.pi),
    );
  }
}
