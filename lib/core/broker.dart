class Broker {
  // map
  static BrokerInstance? _instance;

  static BrokerInstance get instance => (_instance ??= BrokerInstance());

  static T setIfAbsent<T>(T controller, {String? key}) {
    return instance.setIfAbsent<T>(controller, key: key);
  }

  static T set<T>(T controller, {String? key}) {
    return instance.set<T>(controller, key: key);
  }

  static T get<T>({String? key}) {
    return instance.get<T>(key: key);
  }

  static T? getIf<T>({String? key}) {
    return contains<T>(key: key) ? get<T>(key: key) : null;
  }

  static bool contains<T>({T? value, String? key}) {
    return instance.contains<T>(value: value, key: key);
  }

  static T? remove<T>({T? value, String? key}) {
    return instance.remove<T>(value: value, key: key);
  }

  static void clear() {
    instance.clear();
  }
}

class Stacker {
  // list
  static StackerInstance? _instance;

  static StackerInstance get instance => (_instance ??= StackerInstance());

  static T push<T>(T controller) {
    return instance.push(controller);
  }

  static T pop<T>() {
    return instance.pop<T>();
  }

  static T getTop<T>() {
    return instance.getTop<T>();
  }

  static int remove<T>({T? value}) {
    return instance.remove<T>(value: value);
  }

  static bool contains<T>({T? value}) {
    return instance.contains<T>(value: value);
  }

  static void clear() {
    instance.clear();
  }
}

class BrokerInstance {
  /// using map
  Map<String, dynamic>? _map;

  Map<String, dynamic> get map => (_map ??= {});

  T setIfAbsent<T>(T controller, {String? key}) {
    String k = key ?? T.toString();
    return contains<T>(key: k) ? get(key: k) : set<T>(controller, key: key);
  }

  T set<T>(T controller, {String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    map[k] = controller;
    return controller;
  }

  T get<T>({String? key}) {
    Type t = T;
    String k = key ?? t.toString();
    dynamic object = map[k];
    if (object == null) {
      throw '"$T" not found. You need to call "set($T())" first or check if exist using contains<$T>() first';
    }
    return object as T;
  }

  bool contains<T>({T? value, String? key}) {
    return value != null && map.containsValue(value) || map.containsKey(key ?? T.toString());
  }

  T? remove<T>({T? value, String? key}) {
    if (value != null) {
      map.removeWhere((k, v) => v == value);
    }
    return (map.remove(key ?? T.toString()) as T?) ?? value;
  }

  void clear() {
    map.clear();
  }
}

class StackerInstance {
  /// using list
  List<dynamic>? _list;

  List<dynamic> get list => (_list ??= []);

  T push<T>(T controller) {
    list.add(controller);
    return controller;
  }

  T pop<T>() {
    T object = getTop();
    list.remove(object);
    return object;
  }

  T getTop<T>() {
    dynamic object;
    for (int i = list.length - 1; i >= 0; i--) {
      dynamic e = list[i];
      if (e is T) {
        object = e;
        break;
      }
    }
    if (object == null) {
      throw '"$T" not found. You need to call "push($T())" first or check if exist using contains<$T>() first';
    }
    return object as T;
  }

  bool contains<T>({T? value}) {
    if (value != null) {
      for (int i = 0; i < list.length; i++) {
        dynamic e = list[i];
        if (e == value) {
          return true;
        }
      }
    }
    for (int i = 0; i < list.length; i++) {
      dynamic e = list[i];
      if (e is T) {
        return true;
      }
    }
    return false;
  }

  int remove<T>({T? value}) {
    if (value != null) {
      return list.remove(value) ? 1 : 0;
    }
    int count = 0;
    List<T> l = list.whereType<T>().toList();
    for (T t in l) {
      if (list.remove(t)) count++;
    }
    return count;
  }

  void clear() {
    list.clear();
  }
}
