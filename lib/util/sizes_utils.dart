import 'package:flutter/widgets.dart';

class SizesUtils {
  static Size? getSizeS(State state) {
    return getSizeB(state.context);
  }

  static Size? getSizeE(Element element) {
    return getSizeB(element);
  }

  static Size? getSizeB(BuildContext context) {
    return getSize(getRenderBox(context));
  }

  static RenderBox? getRenderBox(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject;
    }
    return null;
  }

  static Size? getSize(RenderBox? box) {
    return box?.size;
  }
}
