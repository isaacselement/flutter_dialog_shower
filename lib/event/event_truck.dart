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

  static get instance => _instance ??= EventTruck();

  static Map<String, StreamSubscription>? managedSubscriptions;

  // Note, the key parameters is needed unless you take management of the subscription ~~~
  static StreamSubscription<T> on<T>(void Function(T object) onData, {String? key}) {
    StreamSubscription<T> subscription = instance.listen<T>(onData);
    if (key != null) {
      managedSubscriptions ??= {};
      managedSubscriptions!.remove(key)?.cancel();
      managedSubscriptions![key] = subscription;
    }
    return subscription;
  }

  static void fire(object) {
    instance.broadcast(object);
  }

  static void remove({StreamSubscription<bool>? subscription, String? key}) {
    if (subscription != null) {
      subscription.cancel();
      managedSubscriptions?.removeWhere((key, value) {
        bool isBingo = value == subscription;
        if (isBingo) {
          value.cancel();
        }
        return isBingo;
      });
    }
    if (key != null) {
      managedSubscriptions?.remove(key)?.cancel();
    }
  }
}
