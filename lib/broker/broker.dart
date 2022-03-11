class Broker {
  /// Class fields & methods below
  static Broker? _instance;

  static Broker get instance => (_instance ??= Broker());

  static T setIfAbsent<T>(T controller, {String? key}) {
    return instance.setIfAbsentI<T>(controller, key: key);
  }

  static T set<T>(T controller, {String? key}) {
    return instance.setI<T>(controller, key: key);
  }

  static T get<T>({String? key}) {
    return instance.getI<T>(key: key);
  }

  static bool contains<T>({T? value, String? key}) {
    return instance.containsI<T>(value: value, key: key);
  }

  static T? remove<T>({T? value, String? key}) {
    return instance.removeI<T>(value: value, key: key);
  }

  /// Instance fields & methods below
  Map<String, Object>? _map;

  Map<String, Object> get map => (_map ??= {});

  T setIfAbsentI<T>(T controller, {String? key}) {
    String k = key ?? T.toString();
    return containsI<T>(key: k) ? getI(key: k) : setI<T>(controller, key: key);
  }

  T setI<T>(T controller, {String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    map[k] = controller as Object;
    return controller;
  }

  T getI<T>({String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    Object? object = map[k];
    if (object == null) {
      throw '"$T" not found. You need to call "Broker.set($T())" first or check if exist using Broker.contains<$T>() first';
    }
    return object as T;
  }

  bool containsI<T>({T? value, String? key}) {
    return value != null && map.containsValue(value) || map.containsKey(key ?? T.toString());
  }

  T? removeI<T>({T? value, String? key}) {
    if (value != null) {
      map.removeWhere((k, v) => v == value);
    }
    return (map.remove(key ?? T.toString()) as T?) ?? value;
  }
}
