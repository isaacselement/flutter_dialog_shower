// ignore_for_file: must_be_immutable

import 'package:flutter/widgets.dart';

// Inspired by GetX[https://github.com/jonataslaw/getx]. Brother is the simplified version for GetX widget/state management.

// Btw -> Observer/StatefulWidget, Btv -> Notifier/Data.
// Wrap your widget with Btw in a scope as small as possible for the best practice with a Btv in build procedure.
// BtKey -> For decoupling, Btv plays two roles of Notifier & Data, but we may need Data is not a Notifier in some business scenarios.

/// Brother Values
extension ExtBtBool on bool {
  Btv<bool> get btv => Btv(this);
}

extension ExtBtInt on int {
  Btv<int> get btv => Btv(this);
}

extension ExtBtDouble on double {
  Btv<double> get btv => Btv(this);
}

extension ExtBtString on String {
  Btv<String> get btv => Btv(this);
}

extension ExtBtT<T> on T {
  Btv<T> get btv => Btv<T>(this);
}

class Btv<T> extends BtNotifier<T> {
  Btv(T initial) : super() {
    _value = initial;
  }
}

/// Brother Widgets
typedef BtWidgetOnRebuild = bool Function(BtWidgetState state, dynamic data);

class Btw extends BtWidget {
  Widget Function(BuildContext context) builder;

  Btw({Key? key, required this.builder, String? updateKey, BtWidgetOnRebuild? onRebuild})
      : super(key: key, updateKey: updateKey, onRebuild: onRebuild);

  @override
  Widget build(BuildContext context) => builder(context);

  // New Feature: update bt widget by a string key
  static update(String updateKey) {
    BtWidgetState.map[updateKey]?.update();
  }

  static updates(List<String> keys) {
    keys.forEach(update);
  }
}

abstract class BtWidget extends StatefulWidget {
  BtWidget({Key? key, this.updateKey, this.onRebuild}) : super(key: key);

  final String? updateKey; // final is needed, we need do removal job ...
  BtWidgetOnRebuild? onRebuild;

  @override
  State<StatefulWidget> createState() => BtWidgetState();

  @protected
  Widget build(BuildContext context);
}

class BtWidgetState extends State<BtWidget> {
  BtObserver observer = BtObserver();

  @override
  void initState() {
    super.initState();
    observer.listen((data) {
      if ((widget.onRebuild?.call(this, data) ?? true) && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    observer.close();
    _updateKeyRemoveOnDispose(this);
    __brother_debug_log__('BtWidget disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BtObserver? backup = BtObserver.proxy;
    BtObserver.proxy = observer;
    _updateKeyAddOnBuild(this);
    Widget result = widget.build(context);
    BtObserver.proxy = backup;
    if (observer.isNotifierEmpty()) {
      __brother_error_log__(
          'The improper use of Btw has been detected. The btv value getter method did not call, pls check your code/conditional logic.');
    }
    return result;
  }

  // New Feature: update bt widget by a string key
  static Map<String, BtKey>? _map;

  static Map<String, BtKey> get map => (_map ??= {});

  static void _updateKeyAddOnBuild(BtWidgetState state) {
    if (state.widget.updateKey != null) {
      String updateKey = state.widget.updateKey!;
      BtObserver.proxy?.bindNotifier(map[updateKey] ?? (map[updateKey] = BtKey()));
    }
  }

  static void _updateKeyRemoveOnDispose(BtWidgetState state) {
    if (state.widget.updateKey != null) {
      String updateKey = state.widget.updateKey!;
      BtKey? btKey = map[updateKey];
      if (btKey?.isSubscriptionsEmpty() ?? false) {
        map.remove(updateKey);
        __brother_debug_log__('BtWidget remove updateKey: $updateKey');
      }
    }
  }
}

/// Brother Key is a Notifier without holding a value/data
class BtKey extends BtNotifier {
  @override
  void update() {
    _stream.update(null);
  }
}

/// Brother Notifier
abstract class BtNotifier<T> {
  final BtStream<T> _stream = BtStream();

  get eye => BtObserver.proxy?.bindNotifier(this);

  late T _value;

  T get value {
    eye;
    return _value;
  }

  set value(T data) {
    _value = data;
    _stream.update(data);
  }

  // just set data and you should update view later manually for calling update method
  set data(T data) => _value = data;

  T get rawData => _value;

  // just update with current _value
  void update() {
    _stream.update(_value);
  }

  // just update with a data that not persist to the _value field, you can pass a null to observer :)
  void add(T? data) {
    _stream.update(data);
  }

  BtSubscription<T> listen(BtSubscriptionCallBack? onData) {
    return _stream.listen(onData);
  }

  void eliminate(BtSubscription<T> sub) {
    _stream.eliminate(sub);
  }

  bool isSubscriptionsEmpty() {
    return _stream.isEmpty();
  }
}

/// Brother Observer
class BtObserver<T> {
  static BtObserver? proxy;

  final BtStream<T> _stream = BtStream();

  // holding the notifier and subscription, for reclaim the notifier resources on close
  final _subscriptions = <BtNotifier, List<BtSubscription<T>>>{};

  void bindNotifier(BtNotifier<T> notifier) {
    if (!_subscriptions.containsKey(notifier)) {
      BtSubscription<T> sub = notifier.listen((data) {
        // call the method the _stream listened ever
        _stream.update(data);
      });
      (_subscriptions[notifier] ??= <BtSubscription<T>>[]).add(sub);
    }
  }

  bool isNotifierEmpty() {
    return _subscriptions.isEmpty;
  }

  BtSubscription<T> listen(BtSubscriptionCallBack? onData) {
    return _stream.listen(onData);
  }

  void close() {
    _subscriptions.forEach((_notifier, _subscriptions) {
      for (BtSubscription<T> sub in _subscriptions) {
        // just remove subscription from notifier, do not close the notifier, cause notifier maybe bind with other observer
        // notifier and observer are in a Many-to-many relationships
        _notifier.eliminate(sub);
      }
    });
    _subscriptions.clear();
    _stream.close();
  }
}

/// Brother Stream
class BtStream<T> {
  bool isClosed = false;

  List<BtSubscription<T>> subscriptions = <BtSubscription<T>>[];

  BtSubscription<T> listen(BtSubscriptionCallBack? onData) {
    BtSubscription<T> sub = BtSubscription<T>(onData: onData);
    subscriptions.add(sub);
    return sub;
  }

  void update(T? data) {
    if (isClosed) {
      return;
    }
    for (BtSubscription sub in subscriptions) {
      sub.call(data);
    }
  }

  bool isEmpty() {
    return subscriptions.isEmpty;
  }

  void eliminate(BtSubscription<T> sub) {
    sub.close();
    subscriptions.remove(sub);
  }

  void close() {
    isClosed = true;
    for (BtSubscription sub in subscriptions) {
      sub.close();
    }
    subscriptions.clear();
  }
}

/// Brother Subscription
typedef BtSubscriptionCallBack<T> = void Function(T? data);

class BtSubscription<T> {
  BtSubscriptionCallBack? onData;

  BtSubscription({this.onData});

  bool isClosed = false;

  void close() {
    isClosed = true;
  }

  void call(T? data) {
    if (!isClosed) {
      onData?.call(data);
    }
  }
}

/// Brother Log Utilities
bool brother_log_enable = false;

__brother_debug_log__(String log) {
  assert(() {
    if (brother_log_enable) {
      print('[__brother_log__] $log');
    }
    return true;
  }());
}

__brother_error_log__(String log) {
  print('❗️❗️❗️❗️❗️ WARNING/ERROR: $log');
}
