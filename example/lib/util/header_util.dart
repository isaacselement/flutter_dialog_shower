import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class HeaderUtil {
  static AnythingHeader headerWidget({
    String? title,
    String? rightTitle,
    bool? isRightDisable,
    void Function()? rightEvent,
    // multi right actions and titles
    List<String>? rightTitlesList,
    List<bool>? isRightDisablesList,
    List<Function()>? rightEventsList,
    void Function(AnythingHeaderOptions options)? onOptions,
  }) {
    AnythingHeaderOptions options = headerOptions(
      isRightDisable: isRightDisable,
      rightTitle: rightTitle,
      rightEvent: rightEvent,
      rightTitlesList: rightTitlesList,
      rightEventsList: rightEventsList,
      isRightDisablesList: isRightDisablesList,
    );
    onOptions?.call(options);
    return AnythingHeader(title: title ?? '', options: options);
  }

  static AnythingHeaderOptions headerOptions({
    bool? isRightDisable,
    String? rightTitle,
    void Function()? rightEvent,
    // multi right action titles
    List<String>? rightTitlesList,
    List<bool>? isRightDisablesList,
    List<Function()>? rightEventsList,
  }) {
    double _fnPressedOpacity(bool isDisable) {
      return isDisable ? 1.0 : 0.4;
    }

    TextStyle _fnTextStyle(bool isDisable) {
      return TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDisable ? Colors.grey : Colors.white);
    }

    BoxDecoration _fnDecoration(bool isDisable) {
      return BoxDecoration(
          color: isDisable ? const Color(0xFFECECF2) : const Color(0xFF4275FF), borderRadius: const BorderRadius.all(Radius.circular(4)));
    }

    void _fnEvent(bool isDisable, void Function()? event) {
      if (!isDisable) {
        ThrottleAny.instance.call(() => event?.call());
      }
    }

    bool isDisableRightAction = isRightDisable ?? false;

    AnythingHeaderOptions options = AnythingHeaderOptions()
      ..headerHeight = 56
      ..titleStyle = const TextStyle(color: Color(0xFF1C1D21), fontSize: 17, fontWeight: FontWeight.bold)
      ..rightPadding = const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      )
      ..rightWidget = Container(
        alignment: Alignment.center,
        decoration: _fnDecoration(isDisableRightAction),
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Text(rightTitle ?? 'Save', style: _fnTextStyle(isDisableRightAction)),
      );
    options.rightEvent = () => _fnEvent(isDisableRightAction, rightEvent);
    options.rightPressedOpacity = _fnPressedOpacity(isDisableRightAction);

    // if multiple buttons
    if (rightTitlesList == null || rightEventsList == null || rightTitlesList.length != rightEventsList.length) {
      return options;
    }
    List<Widget> children = [];
    for (int i = 0; i < rightTitlesList.length; i++) {
      String mTitle = rightTitlesList[i];
      Function() mEvent = rightEventsList[i];
      bool? mIsDisable = isRightDisablesList?.atSafe(i) ?? isDisableRightAction;
      Widget child;
      EdgeInsets padding;
      // the last one
      if (i == rightTitlesList.length - 1) {
        padding = const EdgeInsets.only(left: 8, right: 24, top: 11, bottom: 11);
        child = Container(
          alignment: Alignment.center,
          decoration: _fnDecoration(mIsDisable),
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(mTitle, style: _fnTextStyle(mIsDisable)),
        );
      } else {
        padding = const EdgeInsets.only(left: 16, right: 8);
        child = Text(
          mTitle,
          style: TextStyle(fontSize: 17, color: mIsDisable ? const Color(0xFFBFBFD2) : const Color(0xFF3C78FE)),
        );
      }
      children.add(
        Container(
          color: Colors.transparent,
          child: CupertinoButton(
            padding: padding,
            child: child,
            alignment: Alignment.center,
            onPressed: () => _fnEvent(mIsDisable, mEvent),
            pressedOpacity: _fnPressedOpacity(mIsDisable),
          ),
        ),
      );
    }
    options.rightBuilder = () => Row(mainAxisSize: MainAxisSize.min, children: children);
    return options;
  }

  static AnythingHeaderOptions headerOptionsWithBackIcon() {
    return headerOptions()
      ..rightTitle = null
      ..rightWidget = null
      ..leftWidget = const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF3C78FE))
      ..leftEvent = () => DialogWrapper.popOrDismiss();
  }
}
