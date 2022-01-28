// ControllerManager
class CtrlM {
  static final Map<String, Object> _controllers = {};

  static void setIfAbsent<T>(T controller, {String? key}) {
    if (!contains<T>(key: key)) {
      set<T>(controller);
    }
  }

  static void set<T>(T controller, {String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    _controllers[k] = controller as Object;
  }

  static T? get<T>({String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    return _controllers[k] as T;
  }

  static bool contains<T>({String? key}) {
    return _controllers.containsKey(key ?? T.toString());
  }
}
