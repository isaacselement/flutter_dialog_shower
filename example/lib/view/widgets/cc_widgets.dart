import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/brother.dart';

class CcTextButton extends StatefulWidget {
  String text;

  double? width;
  double? height;

  Color? textColor;
  Color? borderColor;
  Color? backgroundColor;

  EdgeInsets? margin;
  EdgeInsets? padding;
  Alignment? alignment;

  void Function(State state)? onPressed;

  TextStyle? Function(String text, bool isTapingDown)? textStyleBuilder;
  BoxDecoration? Function(String text, bool isTapingDown)? decorationBuilder;

  CcTextButton(
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

  CcTextButton.smallest(
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
  State<StatefulWidget> createState() => _CcTextButtonState();
}

class _CcTextButtonState extends State<CcTextButton> {
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
        widget.onPressed?.call(this);
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

class CcMenuPopup extends StatelessWidget {
  List<Object> values;
  Function(int index, Object value, BuildContext context)? onTap;
  Function(int index, Object value, bool isHighlighted)? itemBuilder;
  Color? popupBackGroundColor;
  double? popupWidth;

  CcMenuPopup({
    Key? key,
    required this.values,
    this.onTap,
    this.itemBuilder,
    this.popupBackGroundColor = Colors.grey,
    this.popupWidth = -0.123456,
  }) : super(key: key) {
    popupWidth = popupWidth == -0.123456 ? CcMenuPopup.currentMenuPopupWidth : popupWidth;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    int size = values.length;
    for (int index = 0; index < size; index++) {
      Object value = values[index];

      Btv<bool> isHighlightedBtv = false.btv;
      Widget item = Btw(builder: (context) {
        return Listener(
          onPointerUp: (event) => isHighlightedBtv.value = false,
          onPointerDown: (event) => isHighlightedBtv.value = true,
          child: InkWell(
            onTap: () => onTap?.call(index, value, context),
            child: (itemBuilder ?? defMenuItemBuilder).call(index, value, isHighlightedBtv.value),
          ),
        );
      });

      children.add(item);
    }
    CcMenuPopup.currentMenuPopupHeight = size / CcMenuPopup.currentMenuItemCountPerRow * CcMenuPopup.currentMenuItemHeight;
    return SingleChildScrollView(
      child: Container(
        width: popupWidth,
        decoration: BoxDecoration(color: popupBackGroundColor),
        child: Wrap(spacing: 1.0, runSpacing: 1.0, children: children),
      ),
    );
  }

  static double currentMenuItemCountPerRow = 3;
  static double currentMenuItemWidth = 80.0;
  static double currentMenuItemHeight = 80.0;
  static double currentMenuPopupWidth = currentMenuItemWidth * currentMenuItemCountPerRow + (currentMenuItemCountPerRow - 1);
  static double currentMenuPopupHeight = 0;

  Widget defMenuItemBuilder(int index, Object value, bool isHighlighted) {
    if (value is! List || value.length < 2) {
      return const SizedBox();
    }
    return Container(
      width: currentMenuItemWidth,
      height: currentMenuItemHeight,
      decoration: BoxDecoration(color: isHighlighted ? Colors.grey : Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 40.0, height: 40.0, child: Icon(value[0], color: Colors.white, size: 30.0)),
          SizedBox(height: 22.0, child: Text(value[1], style: const TextStyle(color: Colors.white, fontSize: 12))),
        ],
      ),
    );
  }
}
