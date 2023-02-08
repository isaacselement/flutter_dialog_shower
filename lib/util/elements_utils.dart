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

class ElementsUtils {
  /// Get Size & Offset methods
  static Size? getSize(BuildContext? context) {
    RenderObject? box = context?.findRenderObject();
    if (box is RenderBox) {
      return box.size;
    }
    return null;
  }

  static Offset? getOffset(BuildContext? context) {
    RenderObject? box = context?.findRenderObject();
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

  /// Get child of Widget/State/Element methods
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

  static Element? getElementOfWidget(BuildContext? context, Widget widget) {
    return getElement(context, (e) => e.widget == widget);
  }

  static Element? getElementOfState(BuildContext? context, State state) {
    return getElement(context, (e) => e is StatefulElement && e.state == state);
  }

  static Element? getElementOfWidgetType(BuildContext? context, Type type) {
    return getElement(context, (e) => e.widget.runtimeType == type);
  }

  static Element? getElementOfStateType(BuildContext? context, Type type) {
    return getElement(context, (e) => e is StatefulElement && e.state.runtimeType == type);
  }

  static T? getWidgetOfType<T extends Widget>(BuildContext? context) {
    Element? element = getElementOfWidgetType(context, T);
    return element?.widget as T?;
  }

  static T? getStateOfType<T extends State>(BuildContext? context) {
    Element? element = getElementOfStateType(context, T);
    return (element as StatefulElement?)?.state as T?;
  }

  static T? getStateOfWidget<T extends State>(BuildContext? context, StatefulWidget widget) {
    StatefulElement? element = getElementOfWidget(context, widget) as StatefulElement?;
    return element?.state as T?;
  }

  /// Rebuild methods
  static void rebuildWidgetOfType<T extends StatefulWidget>(BuildContext? context) {
    getElementOfWidgetType(context, T)?.markNeedsBuild();
  }

  static void rebuildStateOfType<T extends State>(BuildContext? context) {
    getElementOfStateType(context, T)?.markNeedsBuild();
  }

  static void rebuildWidget(BuildContext? context, StatefulWidget? widget) {
    if (widget == null) return;
    getElementOfWidgetType(context, widget.runtimeType)?.markNeedsBuild();
  }

  static void rebuildState(BuildContext? context, State? state) {
    if (state == null) return;
    getElementOfStateType(context, state.runtimeType)?.markNeedsBuild();
  }

  // Cause visitChildElements() called during build. Maybe need call in WidgetsBinding.addPostFrameCallback
  static void rebuild<T extends StatefulWidget>(BuildContext? context, void Function(T widget) fn) {
    assert(T != StatefulWidget, 'Type should be a subclass a StatefulWidget, but not a StatefulWidget type ${T == StatefulWidget}');
    T? widget = ElementsUtils.getWidgetOfType<T>(context);
    if (widget == null) {
      return;
    }
    fn(widget);
    ElementsUtils.rebuildWidget(context, widget);
  }
}
