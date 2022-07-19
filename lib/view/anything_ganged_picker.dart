import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

/// TODO: support multi selection ~~~
class AnythingGangedPicker extends StatelessWidget {
  AnythingGangedPicker({
    Key? key,
    this.title,
    this.showerWidth,
    required this.hasNext,
    required this.funcOfTitle,
    required this.funcOfValues,
    required this.funcOfItemName,
    required this.funcOfLeafItemOnTapped,
  }) : super(key: key);

  String? title;
  double? showerWidth;
  bool Function(AnythingGangedPicker view, int? index, dynamic object) hasNext;
  String? Function(AnythingGangedPicker view, int? index, dynamic object) funcOfTitle;
  String? Function(AnythingGangedPicker view, int? index, dynamic object) funcOfItemName;
  bool? Function(AnythingGangedPicker view, int? index, dynamic object) funcOfLeafItemOnTapped;
  FutureOr<List<dynamic>?> Function(AnythingGangedPicker view, int? index, dynamic object) funcOfValues;

  // private fields
  List<int> relativeIndexes = [];
  List<dynamic> relativeElements = [];
  late AnythingPickerState pickerState;

  static const Widget kArrowIcon = CcTransformZ(ratio: 1, child: Icon(Icons.arrow_back_ios_rounded, size: 13, color: Color(0xFFBFBFD2)));

  @override
  Widget build(BuildContext context) {
    return AnythingPicker(
      title: title,
      funcOfItemName: (state, i, e) {
        return funcOfItemName(this, i, e);
      },
      builderOfShower: (state, context) {
        relativeIndexes.clear();
        relativeElements.clear();
        pickerState = state;
        return showPicker(isRoot: true);
      },
      options: AnythingPickerOptions()..contentArrowIcon = kArrowIcon,
    );
  }

  DialogShower? showPicker({bool isRoot = true}) {
    AnythingHeaderOptions headerOptions = AnythingHeaderOptions()
      ..headerHeight = 56
      ..rightTitle = null
      ..leftWidget = isRoot ? null : const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF3C78FE))
      ..leftEvent = () => DialogWrapper.popOrDismiss();

    BoxDecoration funcDecoration(bool isTapped) {
      return BoxDecoration(
        color: isTapped ? const Color(0xFFE0E0E0) : Colors.white,
        border: const Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))),
      );
    }

    Widget widget = ColoredBox(
      color: Colors.white,
      child: AnythingSelector(
        isSearchEnable: true,
        title: funcOfTitle(this, relativeIndexes.lastSafe, relativeElements.lastSafe),
        funcOfValues: () async {
          return funcOfValues(this, relativeIndexes.lastSafe, relativeElements.lastSafe);
        },
        funcOfItemName: (view, i, e) {
          return funcOfItemName(this, i, e);
        },
        funcOfItemOnTapped: (view, i, e) {
          relativeIndexes.add(i);
          relativeElements.add(e);
          if (hasNext(this, i, e)) {
            showPicker(isRoot: false);
          } else {
            if (funcOfLeafItemOnTapped(this, i, e) == true) {
              // nothing ...
            } else {
              pickerState.widget.selectedValue = e;
              pickerState.refresh();
              DialogWrapper.dismissTopDialog();
            }
          }
          return true;
        },
        headerOptions: headerOptions,
        options: AnythingSelectorOptions()
          ..itemMargin = const EdgeInsets.symmetric(horizontal: 16)
          ..itemPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
          ..itemSuffixWidget = hasNext(this, relativeIndexes.lastSafe, relativeElements.lastSafe) ? null : kArrowIcon
          ..itemDecorationNormal = funcDecoration(false)
          ..itemDecorationTapped = funcDecoration(true),
      ),
    );
    if (isRoot) {
      return DialogWrapper.pushRoot(widget, width: showerWidth)
        ..context = DialogWrapper.getTopNavigatorDialog()?.getNavigator()?.context ?? DialogShower.gContext
        ..isUseRootNavigator = false
        ..barrierDismissible = true
        ..alignment = Alignment.centerRight
        ..barrierOnTapCallback = (dialog, offset) {
          DialogShower.isKeyboardShowing() ? FocusManager.instance.primaryFocus?.unfocus() : DialogWrapper.dismissTopDialog();
          return true;
        }
        ..transitionBuilder = (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
            child: child,
          );
        };
    }
    DialogWrapper.push(widget);
    return null;
  }
}
