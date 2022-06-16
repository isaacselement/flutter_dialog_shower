import 'package:flutter/widgets.dart';

/// Widget with tap effect
class CcTapWidget extends StatefulWidget {
  final Widget? child;
  final Widget Function(bool isTapping)? builder;
  final void Function(CcTapWidgetState state) onTap;

  const CcTapWidget({Key? key, this.builder, this.child, required this.onTap}) : super(key: key);

  @override
  State<CcTapWidget> createState() => CcTapWidgetState();
}

class CcTapWidgetState extends State<CcTapWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() => _isTapingDown = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => isTapingDown = true,
      onPointerUp: (e) => isTapingDown = false,
      onPointerCancel: (e) => isTapingDown = false,
      child: GestureDetector(
        child: widget.builder?.call(isTapingDown) ??
            Opacity(
              opacity: isTapingDown ? 0.5 : 1,
              child: widget.child,
            ),
        onTap: () {
          widget.onTap(this);
        },
      ),
    );
  }
}

class CcTapOnceWidget extends StatefulWidget {
  final Widget? child;
  final Widget Function(bool isTapping)? builder;
  final void Function(CcTapOnceWidgetState state) onTap;

  const CcTapOnceWidget({Key? key, this.builder, this.child, required this.onTap}) : super(key: key);

  @override
  State<CcTapOnceWidget> createState() => CcTapOnceWidgetState();
}

class CcTapOnceWidgetState extends State<CcTapOnceWidget> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() => _isTapingDown = v);
  }

  bool _isTappedOnce = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => isTapingDown = true,
      onPointerUp: (e) => isTapingDown = false,
      onPointerCancel: (e) => isTapingDown = false,
      child: GestureDetector(
        child: widget.builder?.call(isTapingDown) ??
            Opacity(
              opacity: isTapingDown ? 0.5 : 1,
              child: widget.child,
            ),
        onTap: () {
          if (_isTappedOnce) {
            return;
          }
          _isTappedOnce = true;
          widget.onTap(this);
        },
      ),
    );
  }
}
