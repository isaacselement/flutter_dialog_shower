import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

/// TODO: support multi selection ~~~
//ignore: must_be_immutable
class AnythingLevelsPicker extends StatelessWidget {
  AnythingLevelsPicker({
    Key? key,
    this.title,
    required this.funcOfTitle,
    required this.funcOfValues,
    required this.isHasNextLevel,
    required this.funcOfItemName,
    required this.funcOfLeafItemOnTapped,
    // custom theme fields
    this.onShower,
    this.onShowerWidth,
    this.onPickerOptions,
    this.onHeaderOptions,
    this.onSelectorOptions,
  }) : super(key: key);

  String? title;
  bool? isSearchEnable;

  // required fields
  bool Function(AnythingLevelsPicker view, int? index, dynamic object) isHasNextLevel;
  String? Function(AnythingLevelsPicker view, int? index, dynamic object) funcOfTitle;
  String? Function(AnythingLevelsPicker view, int? index, dynamic object) funcOfItemName;
  bool? Function(AnythingLevelsPicker view, int? index, dynamic object) funcOfLeafItemOnTapped;
  FutureOr<List<dynamic>?> Function(AnythingLevelsPicker view, int? index, dynamic object) funcOfValues;

  // optional fields
  double? Function(AnythingLevelsPicker view)? onShowerWidth;
  void Function(AnythingLevelsPicker view, DialogShower shower)? onShower;
  AnythingPickerOptions? Function(AnythingLevelsPicker view, AnythingPickerOptions options)? onPickerOptions;
  AnythingHeaderOptions? Function(AnythingLevelsPicker view, AnythingHeaderOptions options)? onHeaderOptions;
  AnythingSelectorOptions? Function(AnythingLevelsPicker view, AnythingSelectorOptions options)? onSelectorOptions;

  // private fields
  List<int> relativeIndexes = [];
  List<dynamic> relativeElements = [];
  late AnythingPickerState pickerState;

  static const Widget kArrowIcon =
      TransformZaxisWidget(ratio: 1, child: Icon(Icons.arrow_back_ios_rounded, size: 13, color: Color(0xFFBFBFD2)));

  @override
  Widget build(BuildContext context) {
    AnythingPickerOptions options = AnythingPickerOptions();
    options.contentArrowIcon = kArrowIcon;
    options = onPickerOptions?.call(this, options) ?? options;

    return AnythingPicker(
      title: title,
      funcOfItemName: (state, i, e) {
        return funcOfItemName(this, i, e);
      },
      builderOfShower: (state, context) {
        relativeIndexes.clear();
        relativeElements.clear();
        pickerState = state;
        return recursivelyPushPicker(isRoot: true);
      },
      options: options,
    );
  }

  DialogShower? recursivelyPushPicker({bool isRoot = true}) {
    BoxDecoration _itemInteractionDecoration(bool isTap) {
      return BoxDecoration(
        color: isTap ? const Color(0xFFE0E0E0) : Colors.white,
        border: const Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))),
      );
    }

    AnythingHeaderOptions headerOptions = AnythingHeaderOptions()
      ..headerHeight = 56
      ..rightTitle = null
      ..leftEvent = () {
        DialogWrapper.popOrDismiss();
      }
      ..leftWidget = isRoot ? null : const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF3C78FE));
    headerOptions = onHeaderOptions?.call(this, headerOptions) ?? headerOptions;

    AnythingSelectorOptions selectorOptions = AnythingSelectorOptions()
      ..itemMargin = const EdgeInsets.symmetric(horizontal: 16)
      ..itemPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
      ..itemDecorationNormal = _itemInteractionDecoration(false)
      ..itemDecorationTapped = _itemInteractionDecoration(true)
      ..itemSuffixWidget = isHasNextLevel(this, relativeIndexes.lastSafe, relativeElements.lastSafe) ? null : kArrowIcon;
    selectorOptions = onSelectorOptions?.call(this, selectorOptions) ?? selectorOptions;

    Widget widget = AnythingSelector(
      isSearchEnable: isSearchEnable,
      header: funcOfTitle(this, relativeIndexes.lastSafe, relativeElements.lastSafe),
      funcOfValues: () async {
        return funcOfValues(this, relativeIndexes.lastSafe, relativeElements.lastSafe);
      },
      funcOfItemName: (view, i, e) {
        return funcOfItemName(this, i, e);
      },
      funcOfItemOnTapped: (view, i, e) {
        relativeIndexes.add(i);
        relativeElements.add(e);
        if (!isHasNextLevel(this, i, e)) {
          if (!(funcOfLeafItemOnTapped(this, i, e) ?? false)) {
            pickerState.widget.selectedValue = e;
            pickerState.refresh();
            DialogWrapper.dismissTopDialog();
          }
          return true;
        }
        recursivelyPushPicker(isRoot: false);
        return true;
      },
      options: selectorOptions,
      headerOptions: headerOptions,
    );

    widget = ColoredBox(color: Colors.white, child: widget);

    if (isRoot) {
      DialogShower shower = DialogWrapper.pushRoot(widget, width: onShowerWidth?.call(this));
      shower
        ..context = DialogWrapper.getTopNavigatorDialog()?.getNavigator()?.context ?? DialogShower.gContext
        ..isUseRootNavigator = false
        ..barrierDismissible = true
        ..alignment = Alignment.centerRight
        ..barrierOnTapCallback = (dialog, offset) {
          DialogShower.isKeyboardShowing() ? FocusManager.instance.primaryFocus?.unfocus() : DialogWrapper.dismissTopDialog();
          return true;
        }
        ..transitionBuilder = (context, animation, animationVice, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
            child: child,
          );
        };
      onShower?.call(this, shower);
      return shower;
    }

    DialogWrapper.push(widget);
    return null;
  }
}
