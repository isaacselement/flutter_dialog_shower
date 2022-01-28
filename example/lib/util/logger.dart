class Logger {
  static void d(String message) {
    assert(() {
      print('[Logger] $message');
      return true;
    }());
  }
}
