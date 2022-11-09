import 'package:flutter/widgets.dart';

class OffsetsUtils {
  static Offset? getOffsetS(State state) {
    return getOffsetB(state.context);
  }

  static Offset? getOffsetE(Element element) {
    return getOffsetB(element);
  }

  static Offset? getOffsetB(BuildContext context) {
    return getOffset(context.findRenderObject());
  }

  static Offset? getOffset(RenderObject? box) {
    if (box is RenderBox) {
      return box.localToGlobal(Offset.zero);
    }
    return null;
  }
}
