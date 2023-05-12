import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';

class ScreensUtils {
  /// window's size width & height
  static SingletonFlutterWindow? _window;

  static SingletonFlutterWindow get window => (_window ??= Boxes.getWindow());

  // using cache variables

  static MediaQueryData? _windowQuery;

  static double? _windowWidth;

  static double? _windowHeight;

  static MediaQueryData get windowQuery => (_windowQuery ??= MediaQueryData.fromWindow(window));

  static double get windowWidth => (_windowWidth ??= windowQuery.size.width);

  static double get windowHeight => (_windowHeight ??= windowQuery.size.height);

  // query the values in realtime

  static MediaQueryData get query => MediaQueryData.fromWindow(window);

  static double get width => query.size.width;

  static double get height => query.size.height;

  /// status bar height
  static double? _statusBarHeight;

  static double get statusBarHeight => _statusBarHeight ??= windowQuery.padding.top;

  /// context's size width & height
  static late BuildContext _context;

  static set context(BuildContext context) => _context = context;

  static MediaQueryData? _contextQuery;

  static double? _screenWidth;

  static double? _screenHeight;

  static MediaQueryData get contextQuery => _contextQuery ??= MediaQuery.of(_context);

  static double get screenWidth => _screenWidth ??= contextQuery.size.width;

  static double get screenHeight => _screenHeight ??= contextQuery.size.height;
}
