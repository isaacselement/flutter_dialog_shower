import 'dart:async';

// Truck is a Enhance of Bus :P
class EventTruck {
  final StreamController _streamController;

  StreamController get streamController => _streamController;

  // If [sync] is true, events are passed directly to the stream's listeners during a [broadcast] call.
  EventTruck({bool sync = false}) : _streamController = StreamController.broadcast(sync: sync);

  Stream<T> get<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  StreamSubscription<T> listen<T>(void Function(T object) onData) {
    return get<T>().listen((event) {
      onData.call(event);
    });
  }

  void add(object) {
    streamController.add(object);
  }

  void close() {
    _streamController.close();
  }

  /// Static Fields & Methods

  static EventTruck? _instance;

  static EventTruck get _mInstance => _instance ??= EventTruck();

  static Map<String, StreamSubscription>? managedSubscriptions;

  static StreamSubscription<T> on<T>(void Function(T object) onData) {
    StreamSubscription<T> subscription = _mInstance.listen<T>(onData);
    return subscription;
  }

  // Note, the key parameters is needed unless you take management of the subscription ~~~
  static StreamSubscription<T> onWithKey<T>({String? key, required void Function(T object) onData}) {
    StreamSubscription<T> subscription = _mInstance.listen<T>(onData);
    if (key != null) {
      managedSubscriptions ??= {};
      managedSubscriptions!.remove(key)?.cancel();
      managedSubscriptions![key] = subscription;
    }
    return subscription;
  }

  static void fire(object) {
    _mInstance.add(object);
  }

  static void remove({StreamSubscription<bool>? subscription, String? managedKey}) {
    if (subscription != null) {
      subscription.cancel();
      managedSubscriptions?.removeWhere((key, value) => value == subscription);
    }
    if (managedKey != null) {
      managedSubscriptions?.remove(managedKey)?.cancel();
    }
  }

  static void dispose() {
    _mInstance.close();
  }
}

class EventSyncTruck {
  static EventTruck? _instance;

  static EventTruck get _mInstance => _instance ??= EventTruck(sync: true);

  static Map<String, StreamSubscription>? managedSubscriptions;

  static StreamSubscription<T> on<T>(void Function(T object) onData) {
    StreamSubscription<T> subscription = _mInstance.listen<T>(onData);
    return subscription;
  }

  // Note, the key parameters is needed unless you take management of the subscription ~~~
  static StreamSubscription<T> onWithKey<T>({String? key, required void Function(T object) onData}) {
    StreamSubscription<T> subscription = _mInstance.listen<T>(onData);
    if (key != null) {
      managedSubscriptions ??= {};
      managedSubscriptions!.remove(key)?.cancel();
      managedSubscriptions![key] = subscription;
    }
    return subscription;
  }

  static void fire(object) {
    _mInstance.add(object);
  }

  static void remove({StreamSubscription<bool>? subscription, String? managedKey}) {
    if (subscription != null) {
      subscription.cancel();
      managedSubscriptions?.removeWhere((key, value) => value == subscription);
    }
    if (managedKey != null) {
      managedSubscriptions?.remove(managedKey)?.cancel();
    }
  }

  static void dispose() {
    _mInstance.close();
  }
}
