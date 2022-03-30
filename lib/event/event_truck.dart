import 'dart:async';

// Truck is a Enchance of Bus :P
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

  void broadcast(object) {
    streamController.add(object);
  }

  void destroy() {
    _streamController.close();
  }

  /// Static Fields & Methods

  static EventTruck? _instance;

  static get _mInstance => _instance ??= EventTruck();

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
    _mInstance.broadcast(object);
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
}
