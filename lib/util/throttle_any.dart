class ThrottleAny {
  bool enable = true;
  Duration delay = const Duration(milliseconds: 1000);

  void throttle(Function func, {Duration? duration}) {
    if (enable) {
      enable = false;
      func();
      Future.delayed(duration ?? delay, () {
        enable = true;
      });
    }
  }

  /// Static instance and methods

  static ThrottleAny? _instance;

  static get instance => (_instance ??= ThrottleAny());
}
