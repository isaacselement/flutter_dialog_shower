import 'package:flutter/material.dart';

class XpTextButton extends StatefulWidget {
  String text;

  double? width;
  double? height;

  Color? textColor;
  Color? borderColor;
  Color? backgroundColor;

  EdgeInsets? margin;
  EdgeInsets? padding;
  Alignment? alignment;

  void Function()? onPressed;

  TextStyle? Function(String text, bool isTapingDown)? textStyleBuilder;
  BoxDecoration? Function(String text, bool isTapingDown)? decorationBuilder;

  XpTextButton(
    this.text, {
    Key? key,
    this.width,
    this.height,
    this.borderColor,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFF4275FF),
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    this.onPressed,
    this.textStyleBuilder,
    this.decorationBuilder,
  }) : super(key: key);

  XpTextButton.smallest(
    this.text, {
    Key? key,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    this.onPressed,
    this.textStyleBuilder,
    this.decorationBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _XpTextButtonState();
}

class _XpTextButtonState extends State<XpTextButton> {
  bool _isTapingDown = false;

  get isTapingDown => _isTapingDown;

  set isTapingDown(v) {
    setState(() {
      _isTapingDown = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget view = InkWell(
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        decoration: widget.decorationBuilder?.call(widget.text, isTapingDown) ?? _defBoxDecoration(widget.text, isTapingDown),
        child: Text(widget.text,
            style: widget.textStyleBuilder?.call(widget.text, isTapingDown) ?? _defTextStyle(widget.text, isTapingDown)),
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
    );
    return view;
  }

  BoxDecoration _defBoxDecoration(String text, bool isTapingDown) {
    Color? borderColor = widget.borderColor;
    Color? backgroundColor = widget.backgroundColor;
    backgroundColor = (backgroundColor == null ? null : (isTapingDown ? backgroundColor.withAlpha(200) : backgroundColor));
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      border: borderColor == null ? null : Border.all(color: isTapingDown ? borderColor.withAlpha(200) : borderColor),
    );
  }

  TextStyle _defTextStyle(String text, bool isTapingDown) {
    Color color = widget.textColor ?? Colors.white;
    return TextStyle(color: isTapingDown ? color.withAlpha(200) : color);
  }
}

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
