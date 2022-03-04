import 'package:flutter/cupertino.dart';

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
}
