import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/boxes.dart';
import 'cc_basic_widgets.dart';

/// Usaully use as Navigation action bar, Confirm title action bar
class CcActionHeaderWidget extends StatelessWidget {
  static const double ccAutoSizeWith = 0.0123;

  double? height;

  // title
  String? title;
  TextStyle? titleStyle;
  Widget? Function()? titleBuilder;

  // when you not initialize the width properties, 0.0123 means for the size with you widget's width / 5
  // you can pass leftButtonWidth = null, rightButtonWidth = null for the width according by their child.

  // left button
  double? leftButtonWidth = ccAutoSizeWith;
  double? leftButtonHeight;
  EdgeInsets? leftButtonPadding;
  Alignment? leftButtonAlignment;
  String? leftButtonTitle;
  TextStyle? leftButtonStyle;
  Function()? leftButtonEvent;
  Widget? Function()? leftButtonBuilder;
  Widget? Function()? leftBuilder;

  // right button
  double? rightButtonWidth = ccAutoSizeWith;
  double? rightButtonHeight;
  EdgeInsets? rightButtonPadding;
  Alignment? rightButtonAlignment;
  String? rightButtonTitle;
  TextStyle? rightButtonStyle;
  Function()? rightButtonEvent;
  Widget? Function()? rightButtonBuilder;
  Widget? Function()? rightBuilder;

  Widget? _defTitleBuilder() {
    if (title == null) {
      return null;
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            // color: Colors.purple,
            alignment: Alignment.center,
            child: Text(title!, textAlign: TextAlign.center, style: titleStyle),
          ),
        ),
      ],
    );
  }

  Widget? _defLeftBuilder() {
    if (leftButtonTitle == null && leftButtonBuilder == null) {
      return null;
    }
    return CcTapWidget(
      child: Container(
        // color: Colors.red,
        width: leftButtonWidth,
        height: leftButtonHeight,
        padding: leftButtonPadding,
        alignment: leftButtonAlignment,
        child: leftButtonBuilder?.call() ?? Text(leftButtonTitle ?? '', style: leftButtonStyle),
      ),
      onTap: (state) {
        leftButtonEvent?.call();
      },
    );
  }

  Widget? _defRightBuilder() {
    if (rightButtonTitle == null && rightButtonBuilder == null) {
      return null;
    }
    return CcTapWidget(
      child: Container(
        // color: Colors.red,
        width: rightButtonWidth,
        height: rightButtonHeight,
        padding: rightButtonPadding,
        alignment: rightButtonAlignment,
        child: rightButtonBuilder?.call() ?? Text(rightButtonTitle ?? '', style: rightButtonStyle),
      ),
      onTap: (state) {
        rightButtonEvent?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _headerBuilder() {
      return Container(
        height: height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          // color: Colors.green,
          border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))),
        ),
        child: Stack(
          children: [
            titleBuilder?.call() ?? _defTitleBuilder() ?? const Offstage(offstage: true),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: leftBuilder?.call() ?? _defLeftBuilder() ?? const Offstage(offstage: true),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: rightBuilder?.call() ?? _defRightBuilder() ?? const Offstage(offstage: true),
            ),
          ],
        ),
      );
    }

    // 1. auto size ~~~
    // you can comment it if u don't want to us the GetSizeWidget for no need to import relevent dependency
    if (leftButtonWidth == ccAutoSizeWith || rightButtonWidth == ccAutoSizeWith) {
      return StatefulBuilder(builder: (context, setState) {
        bool isCaculated = leftButtonWidth != ccAutoSizeWith && rightButtonWidth != ccAutoSizeWith;
        return isCaculated
            ? _headerBuilder()
            : GetSizeWidget(
                child: _headerBuilder(),
                onLayoutChanged: (box, legacy, size) {
                  setState(() {
                    leftButtonWidth = leftButtonWidth == ccAutoSizeWith ? size.width / 5 : leftButtonWidth;
                    rightButtonWidth = rightButtonWidth == ccAutoSizeWith ? size.width / 5 : rightButtonWidth;
                  });
                },
              );
      });
    }
    // 2. null size or fixed size
    return _headerBuilder();
  }
}

/// One highly customizable selectable list
class CcSelectListWidget extends StatefulWidget {
  CcSelectListWidget({
    Key? key,
    this.defHeaderHeight = 56,
    this.defSearchBoxHeight = 56,
    this.defListItemHeight = 56,
    this.title,
    this.titleStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.leftButtonEvent,
    this.rightButtonEvent,
    required this.values,
    this.disableValues,
    this.selectedValue,
    this.selectedValues,
    this.isSearchEnable = false,
    this.searchValues,
    this.onSearchTextChange,
    this.itemBuilder,
    this.itemPrefixBuilder,
    this.itemSuffixBuilder,
    this.functionOfName,
    this.onSelectedEvent,
    this.headerBuilder,
    this.searchBoxBuilder,
    this.wholeItemBuilder,
  }) : super(key: key) {
    if (isSearchEnable) {
      (searchValues ??= []).addAll(values);
    }
  }

  double? defHeaderHeight;
  double? defSearchBoxHeight;
  double? defListItemHeight;

  Widget? Function(CcSelectListState state, CcActionHeaderWidget headerWidget)? headerBuilder;
  Widget? Function(CcSelectListState state)? searchBoxBuilder;
  Widget? Function(CcSelectListState state, int index, Object value)? wholeItemBuilder;

  // title
  String? title;
  TextStyle? titleStyle;
  Function(CcSelectListState state)? leftButtonEvent;
  Function(CcSelectListState state)? rightButtonEvent;

  // items values
  List<Object> values;
  List<Object>? disableValues;

  Object? selectedValue;
  List<Object>? selectedValues; // pass not null array to indicate that support for multi selection feature

  bool isSearchEnable;
  List<Object>? searchValues;
  void Function(String text)? onSearchTextChange;
  bool Function(String text, int index, Object value)? isShowOnSearchResult;

  // default items builder events
  Widget? Function(CcSelectListState state, int index, Object value)? itemBuilder;
  Widget? Function(CcSelectListState state, int index, Object value)? itemPrefixBuilder;
  Widget? Function(CcSelectListState state, int index, Object value)? itemSuffixBuilder;

  String? Function(CcSelectListState state, int index, Object value)? functionOfName;
  void Function(CcSelectListState state, int index, Object value, List<Object>? selectedValues)? onSelectedEvent;

  @override
  State<StatefulWidget> createState() => CcSelectListState();
}

class CcSelectListState extends State<CcSelectListWidget> {
  TextEditingController? searchTextEditController;

  @override
  void initState() {
    super.initState();
    searchTextEditController = widget.isSearchEnable ? TextEditingController() : null;
  }

  @override
  void dispose() {
    searchTextEditController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTitleHeader(),
          _buildSearchBox(),
          _buildListView(),
        ],
      ),
    );
  }

  Widget _buildTitleHeader() {
    CcActionHeaderWidget header = CcActionHeaderWidget()
      ..height = widget.defHeaderHeight
      ..title = widget.title
      ..titleStyle = widget.titleStyle
      ..leftButtonWidth = CcActionHeaderWidget.ccAutoSizeWith
      ..leftButtonHeight = null
      ..leftButtonPadding = const EdgeInsets.only(left: 24)
      ..leftButtonAlignment = Alignment.centerLeft
      ..leftButtonTitle = null
      ..leftButtonStyle = null
      ..leftButtonBuilder = () {
        return const Icon(Icons.arrow_back_ios, size: 20, color: Colors.blueAccent);
      }
      ..leftButtonEvent = () {
        widget.leftButtonEvent?.call(this);
      }
      ..rightButtonWidth = null
      ..rightButtonHeight = CcActionHeaderWidget.ccAutoSizeWith
      ..rightButtonPadding = null
      ..rightButtonAlignment = Alignment.center
      ..rightButtonTitle = null
      ..rightButtonStyle = null
      ..rightButtonEvent = () {
        widget.rightButtonEvent?.call(this);
      };
    return widget.headerBuilder?.call(this, header) ?? header;
  }

  Widget _buildSearchBox() {
    return widget.isSearchEnable ? widget.searchBoxBuilder?.call(this) ?? defaultSearchBoxBuilder() : const Offstage(offstage: true);
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.isSearchEnable ? widget.searchValues!.length : widget.values.length,
        itemBuilder: (context, index) {
          int realIndex = widget.isSearchEnable ? widget.values.indexOf(widget.searchValues![index]) : index;
          Object value = widget.isSearchEnable ? widget.searchValues![index] : widget.values[index];
          return _buildListViewItem(realIndex, value);
        },
      ),
    );
  }

  Widget _buildListViewItem(int index, Object value) {
    return widget.wholeItemBuilder?.call(this, index, value) ??
        Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          decoration: widget.selectedValues?.contains(value) ?? false ? kDefaultSelectionDecoration : null,
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
              widget.onSelectedEvent?.call(this, index, value, widget.selectedValues);
              setState(() {});
            },
            child: widget.itemBuilder?.call(this, index, value) ?? defaultItemBuilder(index, value),
          ),
        );
  }

  BoxDecoration kDefaultSelectionDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.1, 0.9, 1.0],
      colors: [
        Colors.blueAccent.withAlpha(64),
        Colors.blueAccent.withAlpha(128),
        Colors.blueAccent.withAlpha(128),
        Colors.blueAccent.withAlpha(64),
      ],
    ),
  );

  Widget defaultSearchBoxBuilder() {
    return Container(
      height: widget.defSearchBoxHeight,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      child: CupertinoTextField(
        controller: searchTextEditController,
        suffixMode: OverlayVisibilityMode.editing,
        suffix: CcTapWidget(
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.highlight_remove_rounded, color: Colors.grey, size: 20),
            ),
            onTap: (state) {
              searchTextEditController?.clear();
              onEventSearchTextChanged(searchTextEditController?.text ?? '');
            }),
        prefix: const Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.search, color: Colors.grey, size: 25)),
        placeholder: 'Enter',
        onChanged: (text) {
          onEventSearchTextChanged(text);
        },
      ),
    );
  }

  Widget defaultItemBuilder(int index, Object value) {
    String title = widget.functionOfName?.call(this, index, value) ?? value.toString();
    return Container(
      height: widget.defListItemHeight,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(64))),
      ),
      child: Row(
        children: [
          widget.itemPrefixBuilder?.call(this, index, value) ?? const Offstage(offstage: true),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: (widget.disableValues?.contains(value)) ?? false ? Colors.grey : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          widget.itemSuffixBuilder?.call(this, index, value) ??
              Offstage(
                offstage: !(widget.selectedValues?.contains(value) ?? false),
                child: const Icon(Icons.check_circle, size: 25, color: Colors.blue),
              )
        ],
      ),
    );
  }

  void onEventSearchTextChanged(String text) {
    void Function(String text) searchChanged = widget.onSearchTextChange ?? defaultSearchTextOnChanged;
    searchChanged(text);
  }

  void defaultSearchTextOnChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        widget.searchValues!.clear();
        widget.searchValues!.addAll(widget.values);
      } else {
        List<Object> _tmp = [];
        for (int i = 0; i < widget.values.length; i++) {
          Object value = widget.values[i];

          if (widget.isShowOnSearchResult != null) {
            if (widget.isShowOnSearchResult?.call(text, i, value) ?? false) {
              _tmp.add(value);
            }
          } else {
            String title = widget.functionOfName?.call(this, i, value) ?? value.toString();
            if (title.contains(text)) {
              _tmp.add(value);
            }
          }
        }
        widget.searchValues!.clear();
        widget.searchValues!.addAll(_tmp);
      }
    });
  }
}
