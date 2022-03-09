import 'package:flutter/material.dart';

class IconTextButtonVer extends StatefulWidget {
  Widget icon;
  Widget? iconSelected;
  String text;
  String? textSelected;
  double? gap;
  bool isSelected;

  void Function()? onPressed;

  IconTextButtonVer({
    Key? key,
    required this.icon,
    this.iconSelected,
    required this.text,
    this.textSelected,
    this.gap = 2.0,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IconTextButtonVerState();
}

class _IconTextButtonVerState extends State<IconTextButtonVer> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() {
      _isTapingDown = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = widget.isSelected ? widget.iconSelected ?? widget.icon : widget.icon;
    String text = widget.isSelected ? widget.textSelected ?? widget.text : widget.text;
    return InkWell(
      child: Column(
        children: [
          icon,
          SizedBox(height: widget.gap),
          Text(
            text,
            style: _defTextStyle(text, isTapingDown),
          )
        ],
      ),
      onTap: () {
        isTapingDown = false;
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        widget.onPressed?.call();
      },
      onTapDown: (details) {
        isTapingDown = true;
      },
      onTapCancel: () {
        isTapingDown = false;
      },
    );
  }

  TextStyle _defTextStyle(String text, bool isTapingDown) {
    return TextStyle(color: isTapingDown ? Colors.white.withAlpha(200) : Colors.white);
  }
}

class IconTextButtonHor extends StatefulWidget {
  Widget icon;
  Widget? iconSelected;
  String text;
  String? textSelected;
  double? gap;
  bool isSelected;

  void Function()? onPressed;

  IconTextButtonHor({
    Key? key,
    required this.icon,
    this.iconSelected,
    required this.text,
    this.textSelected,
    this.gap = 2.0,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IconTextButtonVerState();
}

class _IconTextButtonHorState extends State<IconTextButtonVer> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() {
      _isTapingDown = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = widget.isSelected ? widget.iconSelected ?? widget.icon : widget.icon;
    String text = widget.isSelected ? widget.textSelected ?? widget.text : widget.text;
    return InkWell(
      child: Row(
        children: [
          icon,
          SizedBox(width: widget.gap),
          Text(
            text,
            style: _defTextStyle(text, isTapingDown),
          )
        ],
      ),
      onTap: () {
        isTapingDown = false;
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        widget.onPressed?.call();
      },
      onTapDown: (details) {
        isTapingDown = true;
      },
      onTapCancel: () {
        isTapingDown = false;
      },
    );
  }

  TextStyle _defTextStyle(String text, bool isTapingDown) {
    return TextStyle(color: isTapingDown ? Colors.white.withAlpha(200) : Colors.white);
  }
}
