class Broker {
  /// Class fields & methods below
  static Broker? _instance;

  static Broker get instance => (_instance ??= Broker());

  static void setIfAbsent<T>(T controller, {String? key}) {
    instance.setIfAbsentI<T>(controller, key: key);
  }

  static void set<T>(T controller, {String? key}) {
    instance.setI<T>(controller, key: key);
  }

  static T? get<T>({String? key}) {
    return instance.getI<T>(key: key);
  }

  static bool contains<T>({String? key}) {
    return instance.containsI<T>(key: key);
  }

  static T? remove<T>(String? key) {
    return instance.removeI<T>(key);
  }

  /// Instance fields & methods below
  Map<String, Object>? _map;

  Map<String, Object> get map => (_map ??= {});

  void setIfAbsentI<T>(T controller, {String? key}) {
    if (!containsI<T>(key: key)) {
      setI<T>(controller, key: key);
    }
  }

  void setI<T>(T controller, {String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    map[k] = controller as Object;
  }

  T? getI<T>({String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    return map[k] as T?;
  }

  bool containsI<T>({String? key}) {
    return map.containsKey(key ?? T.toString());
  }

  T? removeI<T>(String? key) {
    return map.remove(key ?? T.toString()) as T?;
  }
}
