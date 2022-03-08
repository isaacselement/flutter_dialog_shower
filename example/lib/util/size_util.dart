import 'package:flutter/widgets.dart';

class SizeUtil {
  static late MediaQueryData mediaQueryDate;

  static late double screenWidth;

  static late double screenHeight;

  static late double statuBarHeight;

  static init(BuildContext context) {
    mediaQueryDate = MediaQuery.of(context);
    screenWidth = mediaQueryDate.size.width;
    screenHeight = mediaQueryDate.size.height;
    statuBarHeight = mediaQueryDate.padding.top;
  }

  static Size? getSizeS(State state) {
    return getSizeB(state.context);
  }

  static Size? getSizeE(Element element) {
    return getSizeB(element);
  }

  static Size? getSizeB(BuildContext context) {
    return getSize(context.findRenderObject());
  }

  static Size? getSize(RenderObject? box) {
    if (box is RenderBox) {
      return box.size;
    }
    return null;
  }
}
