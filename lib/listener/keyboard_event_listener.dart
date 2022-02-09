import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardEventListener {
  static final KeyboardEventListener _instance = KeyboardEventListener();

  static KeyboardEventListener get instance => _instance;

  // only the last instance EventChannel will take effect
  final EventChannel eventChannel = const EventChannel('shower_keyboard_visibility');

  late final Stream<bool> stream = eventChannel.receiveBroadcastStream().map((dynamic event) => (event as int) == 1);

  static Map<String, StreamSubscription<bool>>? managedSubscriptions;

  StreamSubscription<bool> listen(void Function(bool isShow)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError, String? key}) {
    StreamSubscription<bool> subscription = stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError ?? true);
    if (key != null) {
      (managedSubscriptions = managedSubscriptions ?? {})[key] = subscription;
    }
    return subscription;
  }

  void cancel({StreamSubscription<bool>? subscription, String? key}) {
    subscription?.cancel();
    if (key != null) {
      managedSubscriptions?.remove(key);
    }
  }
}
