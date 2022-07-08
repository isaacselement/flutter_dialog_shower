import 'package:flutter/widgets.dart';

class ElementsIterator {
  int visitIndex = 0;
  bool isVisitDone = false;

  void iterate(BuildContext context, bool Function(Element element, int index) visitor) {
    if (isVisitDone) {
      return;
    }
    context.visitChildElements((element) {
      if (isVisitDone) {
        return;
      }
      isVisitDone = visitor(element, visitIndex);
      visitIndex++;
      if (isVisitDone) {
        return;
      }
      iterate(element, visitor);
    });
  }
}

class ElementsUtil {
  static Size? getSize(BuildContext context) {
    RenderObject? box = context.findRenderObject();
    if (box is RenderBox) {
      return box.size;
    }
    return null;
  }

  static Offset? getOffset(BuildContext context) {
    RenderObject? box = context.findRenderObject();
    if (box is RenderBox) {
      return box.localToGlobal(Offset.zero);
    }
    return null;
  }

  static double getX(Element element) {
    return getOffset(element)?.dx ?? 0;
  }

  static double getY(Element element) {
    return getOffset(element)?.dy ?? 0;
  }

  static double getW(Element element) {
    return getSize(element)?.width ?? 0;
  }

  static double getH(Element element) {
    return getSize(element)?.height ?? 0;
  }

  static double getMaxH(BuildContext context) {
    double max = 0;
    ElementsIterator().iterate(context, (element, index) {
      Size size = getSize(element) ?? Size.zero;
      Offset offset = getOffset(element) ?? Offset.zero;
      double y = offset.dy + size.height;
      max = max > y ? max : y;
      return false;
    });
    return max;
  }

  static Widget? getChildWidget(BuildContext context) {
    return getChildElement(context)?.widget;
  }

  static Element? getChildElement(BuildContext context) {
    Element? result;
    ElementsIterator().iterate(context, (element, index) {
      result = element;
      return true;
    });
    return result;
  }

  static Element? getElement(BuildContext? context, bool Function(Element e) test) {
    if (context == null) {
      return null;
    }
    Element? result;
    ElementsIterator().iterate(context, (element, index) {
      bool isBingo = test(element);
      result = isBingo ? element : null;
      return isBingo;
    });
    return result;
  }

  static Element? getElementOfText(BuildContext? context, String text) {
    return getElement(context, (e) => e.widget is Text && (e.widget as Text).data == text);
  }

  static Element? getElementOfWidgetType(BuildContext? context, Type type) {
    return getElement(context, (e) => e.widget.runtimeType == type);
  }

  static Element? getElementOfStateType(BuildContext? context, Type type) {
    return getElement(context, (e) => e is StatefulElement && e.state.runtimeType == type);
  }

}
