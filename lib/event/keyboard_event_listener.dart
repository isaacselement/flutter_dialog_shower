import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardEventListener {
  // only the last instance EventChannel will take effect
  static const EventChannel eventChannel = EventChannel('shower_keyboard_visibility');

  static late final Stream<bool> eventChannelStream = eventChannel.receiveBroadcastStream().map((dynamic event) => (event as int) == 1);

  /// Returns true if the keyboard is currently visible, false if not.
  static bool _isVisible = false;

  static bool get isVisible => _isVisible;

  static final StreamController<bool> _onChangeController = StreamController<bool>();

  static late final Stream<bool> _onChangeStream = _onChangeController.stream.asBroadcastStream();

  static Stream<bool> get stream => _onChangeStream;

  static void _onChangeValue(bool newValue) {
    if (newValue == _isVisible) {
      return;
    }
    _isVisible = newValue;
    _onChangeController.add(newValue);
  }

  static Map<String, StreamSubscription<bool>>? managedSubscriptions;

  static bool isInitialized = false;

  static StreamSubscription<bool> listen(void Function(bool isShow)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError, String? key}) {
    if (!isInitialized) {
      isInitialized = true;
      eventChannelStream.listen(_onChangeValue);
    }
    StreamSubscription<bool> subscription =
        _onChangeStream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError ?? true);

    if (key != null) {
      (managedSubscriptions = managedSubscriptions ?? {})[key] = subscription;
    }
    return subscription;
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
