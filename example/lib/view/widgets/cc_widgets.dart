import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

// Widget wrapped without Btw

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

// Widget wrapped with Btw

class CcMenuPopup extends StatelessWidget {
  List<Object> values;
  String? Function(int index, Object value)? functionOfName;
  Widget? Function(int index, Object value)? functionOfIcon;

  TextStyle? titleStyle;
  Color? backgroundColor;
  double? width;
  double? height;
  double? verticalSpacing;
  double? horizontalSpacing;
  double? itemWidth;
  double? itemHeight;
  Alignment? itemAlignment;
  Function(int index, Object value, BuildContext context)? itemOnTap;
  Function(int index, Object value, bool isHighlighted)? itemBuilder;

  CcMenuPopup({
    Key? key,
    required this.values,
    this.functionOfName,
    this.functionOfIcon,
    this.titleStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.backgroundColor = Colors.grey,
    this.width,
    this.height,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.itemWidth,
    this.itemHeight,
    this.itemAlignment,
    this.itemOnTap,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int size = values.length;
    List<Widget> children = <Widget>[];
    for (int index = 0; index < size; index++) {
      Object value = values[index];
      Btv<bool> isHighlightedBtv = false.btv;
      Widget item = Btw(builder: (context) {
        return Listener(
          onPointerUp: (event) => isHighlightedBtv.value = false,
          onPointerDown: (event) => isHighlightedBtv.value = true,
          child: GestureDetector(
            onTap: () => itemOnTap?.call(index, value, context),
            child: (itemBuilder ?? defItemBuilder).call(index, value, isHighlightedBtv.value),
          ),
        );
      });

      children.add(item);
    }
    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: backgroundColor),
        child: Wrap(
          spacing: horizontalSpacing ?? 1.0,
          runSpacing: verticalSpacing ?? 1.0,
          children: children,
        ),
      ),
    );
  }

  Widget defItemBuilder(int index, Object value, bool isHighlighted) {
    Widget? icon = functionOfIcon?.call(index, value);
    String title = functionOfName?.call(index, value) ?? value.toString();
    List<Widget> children = [];
    icon != null ? children.add(icon) : null;
    children.add(Text(title, style: titleStyle));
    return Container(
      width: itemWidth,
      height: itemHeight,
      alignment: itemAlignment,
      decoration: BoxDecoration(color: isHighlighted ? Colors.grey : Colors.black),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
    );
  }
}

class CcMenuPopupUsingRowColumn extends StatelessWidget {
  List<Object> values;
  String? Function(int index, Object value)? functionOfName;
  Widget? Function(int index, Object value)? functionOfIcon;

  TextStyle? titleStyle;
  Color? backgroundColor;
  double? width;
  double? height;
  double? verticalSpacing;
  double? horizontalSpacing;
  double? itemWidth;
  double? itemHeight;

  int? rowCount;
  int? columnCount;

  Alignment? itemAlignment;
  Function(int index, Object value, BuildContext context)? itemOnTap;
  Function(int index, Object value, bool isHighlighted)? itemBuilder;

  CcMenuPopupUsingRowColumn({
    Key? key,
    required this.values,
    this.functionOfName,
    this.functionOfIcon,
    this.titleStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.backgroundColor = Colors.grey,
    this.width,
    this.height,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.itemWidth,
    this.itemHeight,
    this.rowCount,
    this.columnCount,
    this.itemAlignment,
    this.itemOnTap,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    rowCount ??= (width != null && itemWidth != null) ? width! ~/ itemWidth! : null;
    columnCount ??= (height != null && itemHeight != null) ? height! ~/ itemHeight! : null;
    int _rowCount_ = rowCount ?? (columnCount != null ? values.length ~/ columnCount! : 1);
    int _columnCount_ = columnCount ?? values.length ~/ _rowCount_;

    assert(() {
      print('[Cc] >>>>>>>>> _rowCount_: $_rowCount_, _columnCount_: $_columnCount_');
      return true;
    }());

    List<Widget> children = <Widget>[];
    for (int i = 0; i < _columnCount_; i++) {
      List<Widget> child = <Widget>[];
      for (int j = 0; j < _rowCount_; j++) {
        int index = i * _rowCount_ + j;
        assert(() {
          print('[Cc] >>>>>>>>> handling index: $index');
          return true;
        }());
        if (index >= values.length) {
          break;
        }

        Object value = values[index];
        Btv<bool> isHighlightedBtv = false.btv;
        Widget item = Btw(builder: (context) {
          return Listener(
            onPointerUp: (event) => isHighlightedBtv.value = false,
            onPointerDown: (event) => isHighlightedBtv.value = true,
            child: GestureDetector(
              onTap: () => itemOnTap?.call(index, value, context),
              child: (itemBuilder ?? defItemBuilder).call(index, value, isHighlightedBtv.value),
            ),
          );
        });

        child.add(item);
        child.add(SizedBox(width: verticalSpacing ?? 1.0));
      }
      if (child.isEmpty) {
        break;
      }

      child.removeLast();

      children.add(Row(children: child));
      children.add(SizedBox(height: horizontalSpacing ?? 1.0));
    }
    children.removeLast();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(children: children),
    );
  }

  Widget defItemBuilder(int index, Object value, bool isHighlighted) {
    Widget? icon = functionOfIcon?.call(index, value);
    String title = functionOfName?.call(index, value) ?? value.toString();
    List<Widget> children = [];
    icon != null ? children.add(icon) : null;
    children.add(Text(title, style: titleStyle));
    return Container(
      width: itemWidth,
      height: itemHeight,
      alignment: itemAlignment,
      decoration: BoxDecoration(color: isHighlighted ? Colors.grey : Colors.black),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
    );
  }
}
