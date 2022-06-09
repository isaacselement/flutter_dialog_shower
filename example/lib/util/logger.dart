// ignore_for_file: avoid_print

class Logger {

  static void d(String message, {String? tag}) {
    assert(() {
      print('[${tag ?? Logger}] $message');
      return true;
    }());
  }

  /// https://dart.dev/guides/language/language-tour#assert
  /// Only print and evaluate the expression function on debug mode, will omit in production/profile mode
  static void console(String Function() expr) {
    assert(() {
      print(expr());
      return true;
    }());
  }

}
