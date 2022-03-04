import 'package:flutter/cupertino.dart';

class SizeUtil {
  static late double screenWidth;

  static late double screenHeight;

  static late double statuBarHeight;

  static init(BuildContext context) {
    MediaQueryData _queryData = MediaQuery.of(context);
    screenWidth = _queryData.size.width;
    screenHeight = _queryData.size.height;
    statuBarHeight = _queryData.padding.top;
  }

}
