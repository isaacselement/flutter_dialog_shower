import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableListWidget extends StatefulWidget {
  SelectableListWidget({
    Key? key,
    this.title,
    this.titleStyle = const TextStyle(color: Color(0xFF1C1D21), fontSize: 17, fontWeight: FontWeight.bold),
    this.leftButtonWidget = const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF3C78FE)),
    this.leftButtonTitle,
    this.leftButtonStyle = const TextStyle(color: Color(0xFF3C78FE), fontSize: 17),
    this.leftButtonWidth = 110,
    this.leftButtonHeight,
    this.leftButtonPadding = const EdgeInsets.only(left: 24),
    this.leftButtonAlignment = Alignment.centerLeft,
    this.leftButtonEvent,
    this.rightButtonWidget,
    this.rightButtonTitle,
    this.rightButtonStyle = const TextStyle(color: Color(0xFF3C78FE), fontSize: 17),
    this.rightButtonWidth = 110,
    this.rightButtonHeight,
    this.rightButtonPadding = const EdgeInsets.only(right: 12),
    this.rightButtonAlignment = Alignment.center,
    this.rightButtonEvent,
    required this.values,
    this.disableValues,
    this.selectedValue,
    this.selectedValues,
    this.isSearchEnable = false,
    this.searchValues,
    this.functionOfName,
    this.onSelectedEvent,
    this.itemBuilder,
    this.itemPrefixBuilder,
    this.itemSuffixBuilder,
  }) : super(key: key) {
    // search values
    if (isSearchEnable) {
      (searchValues = []).addAll(values);
    }
  }

  // title
  String? title;
  TextStyle titleStyle;

  // left button
  Widget? leftButtonWidget;
  String? leftButtonTitle;
  TextStyle leftButtonStyle;
  double leftButtonWidth;
  double? leftButtonHeight;
  EdgeInsets leftButtonPadding;
  Alignment leftButtonAlignment;
  void Function(SelectableListState state)? leftButtonEvent;

  // right button
  Widget? rightButtonWidget;
  String? rightButtonTitle;
  TextStyle rightButtonStyle;
  double rightButtonWidth;
  double? rightButtonHeight;
  EdgeInsets rightButtonPadding;
  Alignment rightButtonAlignment;
  void Function(SelectableListState state)? rightButtonEvent;

  // items data & events
  List<Object> values;
  List<Object>? disableValues;

  Object? selectedValue;
  List<Object>? selectedValues;

  bool isSearchEnable;
  List<Object>? searchValues;

  Widget? Function(SelectableListState state, int index, Object value)? itemBuilder;
  Widget? Function(SelectableListState state, int index, Object value)? itemPrefixBuilder;
  Widget? Function(SelectableListState state, int index, Object value)? itemSuffixBuilder;

  String? Function(SelectableListState state, int index, Object value)? functionOfName;
  void Function(SelectableListState state, int index, Object value, List<Object>? selectedValues)? onSelectedEvent;

  @override
  State<StatefulWidget> createState() => SelectableListState();
}

class SelectableListState extends State<SelectableListWidget> {
  TextEditingController? _searchTextEditController;

  @override
  void initState() {
    super.initState();
    _searchTextEditController = widget.isSearchEnable ? TextEditingController() : null;
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeaderWidget(),
          _buildSearchWidget(),
          _buildContentsWidget(),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        // color: Colors.green,
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  // color: Colors.purple,
                  alignment: Alignment.center,
                  child: widget.title != null
                      ? Text(widget.title!, textAlign: TextAlign.center, style: widget.titleStyle)
                      : const Offstage(offstage: true),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: widget.leftButtonTitle == null && widget.leftButtonWidget == null
                ? const Offstage(offstage: true)
                : Container(
                    // color: Colors.red,
                    width: widget.leftButtonWidth,
                    height: widget.leftButtonHeight,
                    alignment: Alignment.centerLeft,
                    child: CupertinoButton(
                      padding: widget.leftButtonPadding,
                      alignment: widget.leftButtonAlignment,
                      child: widget.leftButtonTitle != null
                          ? Text(widget.leftButtonTitle!, style: widget.leftButtonStyle)
                          : widget.leftButtonWidget != null
                              ? widget.leftButtonWidget!
                              : const SizedBox(),
                      onPressed: () {
                        widget.leftButtonEvent?.call(this);
                      },
                    ),
                  ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: widget.rightButtonTitle == null && widget.rightButtonWidget == null
                ? const Offstage(offstage: true)
                : Container(
                    // color: Colors.yellow,
                    width: widget.rightButtonWidth,
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: widget.rightButtonPadding,
                      alignment: widget.rightButtonAlignment,
                      child: widget.rightButtonTitle != null
                          ? Text(widget.rightButtonTitle!, style: widget.rightButtonStyle)
                          : widget.rightButtonWidget != null
                              ? widget.rightButtonWidget!
                              : const SizedBox(),
                      onPressed: () {
                        widget.rightButtonEvent?.call(this);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchWidget() {
    return widget.isSearchEnable
        ? Container(
            height: 56,
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: CupertinoTextField(
              controller: _searchTextEditController,
              placeholder: 'Enter',
              padding: const EdgeInsets.only(left: 0),
              prefix: const SizedBox(
                width: 38,
                child: Icon(Icons.search, color: Colors.grey, size: 25),
              ),
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    widget.searchValues!.clear();
                    widget.searchValues!.addAll(widget.values);
                  } else {
                    List<Object> _tmp = [];
                    for (int i = 0; i < widget.values.length; i++) {
                      Object value = widget.values[i];
                      String title = widget.functionOfName?.call(this, i, value) ?? value.toString();
                      if (title.contains(text)) {
                        _tmp.add(value);
                      }
                    }
                    widget.searchValues = _tmp;
                  }
                });
              },
            ),
          )
        : const Offstage(offstage: true);
  }

  Widget _buildContentsWidget() {
    if (widget.values.isEmpty) {
      return const SizedBox();
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.isSearchEnable ? widget.searchValues!.length : widget.values.length,
        itemBuilder: (context, index) {
          int realIndex = widget.isSearchEnable ? widget.values.indexOf(widget.searchValues![index]) : index;
          Object value = widget.isSearchEnable ? widget.searchValues![index] : widget.values[index];
          return _buildListViewItem(index, realIndex, value);
        },
      ),
    );
  }

  Widget _buildListViewItem(int index, int realIndex, Object value) {
    String title = widget.functionOfName?.call(this, realIndex, value) ?? value.toString();
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: widget.selectedValues?.contains(value) ?? false
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.1, 0.9, 1.0],
                colors: [
                  Color(0x0A4E7DF7),
                  Color(0x1A4E7DF7),
                  Color(0x1A4E7DF7),
                  Color(0x0A4E7DF7),
                ],
              )
            : null,
      ),
      child: InkWell(
        onTap: () {
          // disable
          if (widget.disableValues?.contains(value) ?? false) {
            return;
          }

          // multi choices
          if (widget.selectedValues != null) {
            widget.selectedValues!.contains(value) ? widget.selectedValues!.remove(value) : widget.selectedValues!.add(value);
          }

          // single & multi choice callback
          widget.onSelectedEvent?.call(this, realIndex, value, widget.selectedValues);
          setState(() {});
        },
        child: widget.itemBuilder?.call(this, realIndex, value) ??
            Container(
              height: 56,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))),
              ),
              child: Row(
                children: [
                  widget.itemPrefixBuilder?.call(this, realIndex, value) ?? const Offstage(offstage: true),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: (widget.disableValues?.contains(value)) ?? false ? const Color(0xFFBFBFD2) : const Color(0xFF1C1D21),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  widget.itemSuffixBuilder?.call(this, realIndex, value) ??
                      Offstage(
                        offstage: !(widget.selectedValues?.contains(value) ?? false),
                        child: const Icon(Icons.check_circle, size: 25, color: Color(0xFF4275FF)),
                      )
                ],
              ),
            ),
      ),
    );
  }
}
