import 'package:flutter/widgets.dart';

class SizesUtils {
  static MediaQueryData? _mediaQueryDate;

  static MediaQueryData get mediaQueryDate => _mediaQueryDate ??= MediaQuery.of(_context);

  static double? _screenWidth;

  static double get screenWidth => _screenWidth ??= mediaQueryDate.size.width;

  static double? _screenHeight;

  static double get screenHeight => _screenHeight ??= mediaQueryDate.size.height;

  static double? _statusBarHeight;

  static double get statusBarHeight => _statusBarHeight ??= mediaQueryDate.padding.top;

  static late BuildContext _context;

  static init(BuildContext context) {
    _context = context;
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
