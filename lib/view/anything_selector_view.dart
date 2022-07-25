import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

// ignore: must_be_immutable
class AnythingSelector extends StatelessWidget {
  String? header;
  AnythingHeaderOptions? headerOptions;

  List<dynamic>? values;
  FutureOr<List<dynamic>?> Function()? funcOfValues;

  dynamic selectedValue;
  List<dynamic>? selectedValues; // indicate that is multi-selection mode when it's not null
  List<dynamic>? disabledValues;

  // false/null/none-implement for continue using the default behaviour
  String? Function(AnythingSelector view, int? index, dynamic object)? funcOfItemName;
  bool? Function(AnythingSelector view, int index, dynamic object)? funcOfItemOnTapped;
  bool? Function(AnythingSelector view, int index, dynamic object)? funcOfItemIfSelected;
  bool? Function(AnythingSelector view, int index, dynamic object)? funcOfItemIfDisabled;
  bool Function(AnythingSelector view, int index, dynamic object, dynamic e)? funcOfItemIsEqual;

  Widget? Function(AnythingSelector view, int index, dynamic object)? builderOfItemOuter;
  Widget? Function(AnythingSelector view, int index, dynamic object)? builderOfItemInner;
  Widget? Function(AnythingSelector view, int index, dynamic object, List<Widget> children)? builderOfItemChildren;

  /// Search
  bool? isSearchEnable;
  List<dynamic>? searchValues;
  BtKey searchValuesKey = BtKey();
  void Function(AnythingSelector view, String text)? searchTextOnChanged;
  Widget? Function(AnythingSelector view, void Function(String text) fn)? searchBoxBuilder;
  bool? Function(AnythingSelector view, String text, int index, dynamic object)? searchableOnChanged;

  AnythingSelectorOptions? options;

  List<int> tappingIndexes = [];

  AnythingSelector({
    Key? key,
    this.header,
    this.headerOptions,
    this.values,
    this.funcOfValues,
    this.selectedValue,
    this.selectedValues,
    this.disabledValues,
    this.funcOfItemName,
    this.funcOfItemOnTapped,
    this.funcOfItemIsEqual,
    this.funcOfItemIfSelected,
    this.funcOfItemIfDisabled,
    this.builderOfItemInner,
    this.builderOfItemOuter,
    this.builderOfItemChildren,
    this.isSearchEnable,
    this.searchBoxBuilder,
    this.searchTextOnChanged,
    this.searchableOnChanged,
    this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    // header view
    if (header != null) {
      children.add(AnythingHeader(
        title: header,
        options: headerOptions,
      ));
    }

    // search view
    if (isSearchEnable == true) {
      children.add(getValuesSearchBox());
    }

    // list view
    Btv<bool> isLoading = false.btv;
    if (funcOfValues != null) {
      () async {
        isLoading.value = true;
        values = await funcOfValues?.call() ?? values;
        isLoading.value = false;
      }();
    }
    children.add(Expanded(
      child: Btw(
        builder: (context) {
          if (isLoading.value) {
            return const CupertinoActivityIndicator();
          }
          if (isSearchEnable == true) {
            searchValues ??= [...?values];
            return Btw(
              builder: (context) {
                searchValuesKey.eye;
                return getValuesPicker(searchValues);
              },
            );
          }
          return getValuesPicker(values);
        },
      ),
    ));

    return Column(children: children);
  }

  AnythingSelector get widget => this;

  AnythingSelectorOptions? _options;

  AnythingSelectorOptions get getOptions => widget.options ?? (_options ??= AnythingSelectorOptions());

  Widget getValuesSearchBox() {
    AnythingSelectorOptions options = getOptions;

    bool isSearchable(text, i, e) {
      String itemName = itemDisplayName(i, e);
      return widget.searchableOnChanged?.call(this, text, i, e) ?? itemName.contains(text);
    }

    void onTextChanged(String text) {
      if (widget.values == null) {
        return;
      }
      widget.searchValues?.clear();
      List<dynamic> values = widget.values!;
      if (text.isEmpty) {
        widget.searchValues?.addAll(values);
      } else {
        for (int i = 0; i < values.length; i++) {
          dynamic e = values[i];
          if (isSearchable(text, i, e)) {
            widget.searchValues?.add(e);
          }
        }
      }
      searchValuesKey.update();
    }

    void onEventSearchTextChanged(String text) {
      if (widget.searchTextOnChanged != null) {
        widget.searchTextOnChanged?.call(this, text);
      } else {
        onTextChanged(text);
      }
    }

    Widget searchBoxBuilder() {
      TextEditingController controller = TextEditingController();
      return Container(
        padding: options.searchBoxPadding,
        child: CupertinoTextField(
          controller: controller,
          padding: options.searchPadding,
          decoration: options.searchDecoration,
          prefix: options.searchPrefixIcon,
          placeholder: options.searchPlaceHolder,
          suffixMode: OverlayVisibilityMode.editing,
          suffix: CcTapWidget(
            child: options.searchClearIcon,
            onTap: (state) {
              controller.clear();
              onEventSearchTextChanged(controller.text);
            },
          ),
          onChanged: (text) {
            onEventSearchTextChanged(text);
          },
        ),
      );
    }

    return widget.searchBoxBuilder?.call(this, onEventSearchTextChanged) ?? searchBoxBuilder();
  }

  Widget getValuesPicker(List? items) {
    AnythingSelectorOptions options = getOptions;

    int length = items?.length ?? 0;
    List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      dynamic e = items!.elementAt(i);
      String itemName = itemDisplayName(i, e);

      _itemOnTap() {
        bool isItemSelected = itemIsSelected(i, e);
        bool isItemDisabled = itemIsDisabled(i, e);

        if (isItemDisabled) {
          return;
        }
        if (widget.funcOfItemOnTapped?.call(this, i, e) ?? false) {
          // handle by caller already if return true
        } else {
          // handle by default if return false or null
          if (widget.selectedValues != null) {
            // Multi-choice. Note: if funcOfItemOnTapped call and return false, u should ensure that selectedValues changed is correct
            isItemSelected ? widget.selectedValues?.remove(e) : widget.selectedValues?.add(e);
          } else {
            // Single-selection. Dismiss by default
            widget.selectedValue = e;
            DialogWrapper.dismissTopDialog();
          }
        }
      }

      _itemBuilder() {
        bool isItemSelected = itemIsSelected(i, e);
        bool isItemDisabled = itemIsDisabled(i, e);

        List<Widget> children = [];

        // prefix
        if (options.itemPrefixWidget != null) {
          children.add(options.itemPrefixWidget!);
        }

        // 1. text widget
        TextStyle? itemNameStyle = options.itemStyleNormal;
        if (isItemSelected) {
          itemNameStyle = options.itemStyleSelected;
        } else if (isItemDisabled) {
          itemNameStyle = options.itemStyleDisabled;
        }
        Widget itemTextWidget = Expanded(
          child: Text(
            itemName,
            style: itemNameStyle,
            maxLines: options.itemMaxLines,
          ),
        );
        children.add(itemTextWidget);

        // 2. checkbox widget
        if (widget.selectedValues != null) {
          Widget itemCheckedWidget = Offstage(
            offstage: !isItemSelected,
            child: options.itemCheckedWidget,
          );
          children.add(itemCheckedWidget);
        }

        // suffix
        if (options.itemSuffixWidget != null) {
          children.add(options.itemSuffixWidget!);
        }

        widget.builderOfItemChildren?.call(this, i, e, children);

        // 3. item container
        Decoration? decoration = options.itemDecorationNormal;
        if (isItemDisabled) {
          decoration = options.itemDecorationDisabled;
        } else if (itemIsTapping(i)) {
          decoration = options.itemDecorationTapped;
        }
        return Container(
          width: options.itemWidth,
          height: options.itemHeight,
          margin: options.itemMargin,
          padding: options.itemPadding,
          alignment: options.itemAlignment,
          decoration: decoration,
          child: Row(
            children: children,
          ),
        );
      }

      _itemBuilderWrap() {
        return widget.builderOfItemInner?.call(this, i, e) ?? _itemBuilder();
      }

      Widget item = widget.builderOfItemOuter?.call(this, i, e) ??
          CcTapWidget(
            onTap: (state) {
              _itemOnTap();
            },
            builder: (state) {
              tappingIndexes.remove(i);
              if ((state as CcTapState).isTapingDown) {
                tappingIndexes.add(i);
              }
              return _itemBuilderWrap();
            },
          );

      children.add(item);
    }

    if (children.isEmpty && options.itemNoDataWidget != null) {
      return options.itemNoDataWidget!;
    }
    return ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: children);
  }

  String itemDisplayName(int? i, dynamic e) {
    return widget.funcOfItemName?.call(this, i, e) ?? e.toString();
  }

  bool? isContains(List<dynamic>? list, dynamic e) {
    if (list != null && widget.funcOfItemIsEqual != null) {
      int len = list.length;
      for (int i = 0; i < len; i++) {
        if (widget.funcOfItemIsEqual?.call(this, i, list.elementAt(i), e) ?? false) {
          return true;
        }
      }
    }
    return list?.contains(e);
  }

  bool itemIsSelected(int i, dynamic e) {
    return widget.funcOfItemIfSelected?.call(this, i, e) ?? isContains(widget.selectedValues, e) ?? widget.selectedValue == e;
  }

  bool itemIsDisabled(int i, dynamic e) {
    return widget.funcOfItemIfDisabled?.call(this, i, e) ?? isContains(widget.disabledValues, e) ?? false;
  }

  bool itemIsTapping(int i) => tappingIndexes.contains(i);

}

class AnythingSelectorOptions {
  // item options
  double? itemWidth;
  double? itemHeight;
  EdgeInsets? itemMargin;
  EdgeInsets? itemPadding = const EdgeInsets.all(16);
  Alignment? itemAlignment;
  Decoration? itemDecorationNormal = const BoxDecoration(color: Color(0xFFFFFFFF));
  Decoration? itemDecorationTapped = const BoxDecoration(color: Color(0xFFE0E0E0));
  Decoration? itemDecorationDisabled;

  int? itemMaxLines;
  TextStyle? itemStyleNormal = const TextStyle(fontSize: 16, color: Color(0xFF1C1D21));
  TextStyle? itemStyleSelected = const TextStyle(fontSize: 16, color: Color(0xFF5E81F4));
  TextStyle? itemStyleDisabled = const TextStyle(fontSize: 16, color: Color(0xFFBDBDBD));

  Widget? itemPrefixWidget;
  Widget? itemSuffixWidget;
  Widget? itemCheckedWidget = const Icon(Icons.check, size: 18, color: Color(0xFF4275FF));
  Widget? itemNoDataWidget = const SizedBox(height: 100, child: Center(child: Text('No data', style: TextStyle(color: Colors.grey))));

  // search options
  String? searchPlaceHolder = 'Search';
  EdgeInsets searchPadding = const EdgeInsets.all(10.0);
  BoxDecoration? searchDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 0.0),
    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
  );
  EdgeInsets? searchBoxPadding = const EdgeInsets.only(
    left: 24,
    right: 24,
    top: 16,
    bottom: 16,
  );
  Widget? searchPrefixIcon = const Padding(
    padding: EdgeInsets.only(left: 12),
    child: Icon(Icons.search, color: Colors.grey), // CupertinoIcons.search
  );
  Widget? searchClearIcon = ColoredBox(
    color: Colors.transparent,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 13,
        height: 13,
        child: const Icon(Icons.clear_rounded, color: Colors.white, size: 9),
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.5)), color: Color(0xFFC2C7D4)),
      ),
    ),
  );

  AnythingSelectorOptions();

  AnythingSelectorOptions clone() {
    AnythingSelectorOptions newInstance = AnythingSelectorOptions();

    // item options
    newInstance.itemWidth = itemWidth;
    newInstance.itemHeight = itemHeight;
    newInstance.itemMargin = itemMargin;
    newInstance.itemPadding = itemPadding;
    newInstance.itemAlignment = itemAlignment;
    newInstance.itemDecorationNormal = itemDecorationNormal;
    newInstance.itemDecorationTapped = itemDecorationTapped;
    newInstance.itemDecorationDisabled = itemDecorationDisabled;

    newInstance.itemMaxLines = itemMaxLines;
    newInstance.itemStyleNormal = itemStyleNormal;
    newInstance.itemStyleSelected = itemStyleSelected;
    newInstance.itemStyleDisabled = itemStyleDisabled;

    newInstance.itemPrefixWidget = itemPrefixWidget;
    newInstance.itemSuffixWidget = itemSuffixWidget;
    newInstance.itemCheckedWidget = itemCheckedWidget;
    newInstance.itemNoDataWidget = itemNoDataWidget;

    // search options
    newInstance.searchBoxPadding = searchBoxPadding;
    newInstance.searchPlaceHolder = searchPlaceHolder;
    newInstance.searchPadding = searchPadding;
    newInstance.searchDecoration = searchDecoration;
    newInstance.searchPrefixIcon = searchPrefixIcon;
    newInstance.searchClearIcon = searchClearIcon;

    return newInstance;
  }
}
