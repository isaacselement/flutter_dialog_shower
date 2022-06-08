// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

// Inspired by GetX[https://github.com/jonataslaw/getx]. Brother is the simplified version for GetX widget/state management.
// Btw -> Observer/StatefulWidget, btv -> Notifier/Data. Wrap your widget with Btw in a scope as small as possible for best practice.
// BtKey -> For decoupling, btv plays two roles of Notifier & Data, but we may need Notifier only in some business scenarios.

/// Brother Values
class Btv<T> extends BtNotifier<T> {
  Btv(T initial) : super() {
    _value = initial;
  }
}

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

/// Brother Widgets
typedef BtWidgetShouldRebuild<T> = bool Function(BtWidgetState state);

class Btw extends BtWidget {
  Widget Function(BuildContext context) builder;

  Btw({Key? key, required this.builder, String? updateKey, BtWidgetShouldRebuild? shouldRebuild})
      : super(key: key, updateKey: updateKey, shouldRebuild: shouldRebuild);

  @override
  Widget build(BuildContext context) => builder(context);

  // New Feature: update widget by a string key .
  static Map<String, BtKey>? _map;

  static Map<String, BtKey> get map => (_map ??= {});

  static update(String updateKey) {
    map[updateKey]?.update();
  }

  static updates(List<String> keys) {
    keys.forEach(update);
  }
}

abstract class BtWidget extends StatefulWidget {
  BtWidget({Key? key, this.updateKey, this.shouldRebuild}) : super(key: key);

  String? updateKey;
  BtWidgetShouldRebuild? shouldRebuild;

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
      if ((widget.shouldRebuild?.call(this) ?? true) && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    observer.close();
    _updateKeyRemove();
    super.dispose();
    __brother_debug_log__('BtWidget disposed');
  }

  @override
  Widget build(BuildContext context) {
    BtObserver? bakup = BtObserver.proxy;
    BtObserver.proxy = observer;
    _updateKeyAdd();
    Widget result = widget.build(context);
    BtObserver.proxy = bakup;
    if (observer._subscriptions.isEmpty) {
      __brother_error_log__(
          'The improper use of Btw has been detected. The btv value getter method didn\'t call, pls check your code/conditional logic.');
    }
    return result;
  }

  void _updateKeyAdd() {
    if (widget.updateKey != null) {
      String updateKey = widget.updateKey!;
      BtObserver.proxy?.addListener(Btw.map[updateKey] ?? (Btw.map[updateKey] = BtKey()));
    }
  }

  void _updateKeyRemove() {
    if (widget.updateKey != null) {
      String updateKey = widget.updateKey!;
      BtKey? btKey = Btw.map[updateKey];
      if (btKey?.isSubscriptionsEmpty() ?? false) {
        Btw.map.remove(updateKey);
        __brother_debug_log__('BtWidget remove updateKey: $updateKey');
      }
    }
  }
}

/// Brother Key is a Notifier
class BtKey extends BtNotifier {
  @override
  void update() {
    _stream.add(null);
  }
}

/// Brother Notifier
abstract class BtNotifier<T> {
  final BtStream<T> _stream = BtStream();

  get eye => BtObserver.proxy?.addListener(this);

  late T _value;

  T get value {
    BtObserver.proxy?.addListener(this);
    return _value;
  }

  set value(T data) {
    _value = data;
    _stream.add(data);
  }

  void add(T? data) {
    _stream.add(data);
  }

  // just set data and you should update view later manually for calling update method
  set data(T data) {
    _value = data;
  }

  void update() {
    _stream.add(_value);
  }

  BtSubscription<T> listen(BtSubscriptionCallBack? onData) {
    return _stream.listen(onData);
  }

  void remove(BtSubscription<T> sub) {
    _stream.subscriptions.remove(sub);
  }

  bool isSubscriptionsEmpty() {
    return _stream.subscriptions.isEmpty;
  }
}

/// Brother Observer
class BtObserver<T> {
  static BtObserver? proxy;

  final BtStream<T> _stream = BtStream();
  final _subscriptions = <BtNotifier, List<BtSubscription<T>>>{}; // for reclaim notifier resources on close

  void addListener(BtNotifier<T> btrNotifier) {
    if (!_subscriptions.containsKey(btrNotifier)) {
      BtSubscription<T> sub = btrNotifier.listen((data) {
        if (!_stream.isClosed) _stream.add(data);
      });
      _subscriptions[btrNotifier] ??= <BtSubscription<T>>[];
      _subscriptions[btrNotifier]?.add(sub);
    }
  }

  BtSubscription<T> listen(BtSubscriptionCallBack? onData) {
    return _stream.listen(onData);
  }

  void close() {
    _subscriptions.forEach((_notifier, _subscriptions) {
      for (BtSubscription<T> sub in _subscriptions) {
        sub.close();
        _notifier.remove(sub);
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
    BtSubscription<T> sub = BtSubscription<T>();
    sub.onData = onData;
    subscriptions.add(sub);
    return sub;
  }

  void add(T? data) {
    for (BtSubscription sub in subscriptions) {
      if (!sub.isClosed) {
        sub.onData?.call(data);
      }
    }
  }

  void remove(BtSubscription<T> sub) {
    subscriptions.remove(sub);
  }

  void close() {
    for (BtSubscription sub in subscriptions) {
      sub.close();
    }
    subscriptions.clear();
    isClosed = true;
  }
}

/// Brother Subscription
typedef BtSubscriptionCallBack<T> = void Function(T? data);

class BtSubscription<T> {
  BtSubscriptionCallBack? onData;

  bool isClosed = false;

  void close() {
    isClosed = true;
  }
}

/// Brother Log Utilities
bool brother_log_enable = true;

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
