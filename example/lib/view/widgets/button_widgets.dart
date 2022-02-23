import 'package:example/view/manager/themes_manager.dart';
import 'package:flutter/material.dart';

class XpButton extends StatefulWidget {
  String text;
  void Function()? onPressed;

  double? width;
  double? height;
  EdgeInsets? margin;
  EdgeInsets? padding;
  bool isAsSmallAsPossible = false;

  XpButton(
    this.text, {
    Key? key,
    this.onPressed,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    this.isAsSmallAsPossible = false,
  }) : super(key: key);

  XpButton.smallest(
    this.text, {
    Key? key,
    this.onPressed,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    this.isAsSmallAsPossible = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _XpButtonState();
}

class _XpButtonState extends State<XpButton> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() {
      _isTapingDown = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
      padding: widget.margin,
      width: widget.width,
      height: widget.height,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          padding: widget.padding,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: isTapingDown
                  ? ThemesManager.getXpButtonColor(widget.text).withAlpha(200)
                  : ThemesManager.getXpButtonColor(widget.text)),
          child: Text(
            widget.text,
            style: TextStyle(color: isTapingDown ? Colors.white.withAlpha(200) : Colors.white),
          ),
        ),
        onTap: () {
          isTapingDown = false;
          widget.onPressed?.call();
        },
        onTapDown: (details) {
          isTapingDown = true;
        },
        onTapCancel: () {
          isTapingDown = false;
        },
      ),
    );
    // as small as possible
    return widget.isAsSmallAsPossible ? Row(mainAxisSize: MainAxisSize.min, children: [view]) : view;
  }
}
