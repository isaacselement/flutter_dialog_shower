import 'package:flutter/widgets.dart';

class SizesUtils {
  static late MediaQueryData mediaQueryDate;

  static late double screenWidth;

  static late double screenHeight;

  static late double statusBarHeight;

  static init(BuildContext context) {
    mediaQueryDate = MediaQuery.of(context);
    screenWidth = mediaQueryDate.size.width;
    screenHeight = mediaQueryDate.size.height;
    statusBarHeight = mediaQueryDate.padding.top;
  }

  static Size? getSizeS(State state) {
    return getSizeB(state.context);
  }

  static Size? getSizeE(Element element) {
    return getSizeB(element);
  }

  static Size? getSizeB(BuildContext context) {
    return getSize(getRenderBox(context));
  }

  static Size? getSize(RenderBox? box) {
    return box?.size;
  }

  static RenderBox? getRenderBox(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject;
    }
    return null;
  }
}
