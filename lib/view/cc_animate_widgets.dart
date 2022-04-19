import 'package:flutter/cupertino.dart';

class RotateWidget extends StatefulWidget {
  Widget child;

  Duration? duration;

  RotateWidget({Key? key, required this.child, this.duration}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 1),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    assert(() {
      print('[RotateWidget] >>>>>>>>>>>>>> dispose');
      return true;
    }());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
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
