class Broker {
  static final Map<String, Object> _instances = {};

  static void setIfAbsent<T>(T controller, {String? key}) {
    if (!contains<T>(key: key)) {
      set<T>(controller);
    }
  }

  static void set<T>(T controller, {String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    _instances[k] = controller as Object;
  }

  static T? get<T>({String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    return _instances[k] as T?;
  }

  static bool contains<T>({String? key}) {
    return _instances.containsKey(key ?? T.toString());
  }

  static dynamic remove(String? key) {
    return _instances.remove(key);
  }
}
