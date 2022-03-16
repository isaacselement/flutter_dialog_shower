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

extension ExtBtT<T> on T {
  Btv<T> get btv => Btv<T>(this);
}

extension ExtBtString on String {
  Btv<String> get btv => Btv(this);
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

/// Brother Widgets
typedef BtWidgetShouldRebuild<T> = bool Function(BtWidgetState state);

class Btw extends BtWidget {
  Widget Function(BuildContext context) builder;

  Btw({Key? key, required this.builder, BtWidgetShouldRebuild? shouldRebuild}) : super(key: key, shouldRebuild: shouldRebuild);

  @override
  Widget build(BuildContext context) => builder(context);
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
    super.dispose();
    __brother_debug_log__('BtWidget disposed');
  }

  @override
  Widget build(BuildContext context) {
    BtObserver? bak = BtObserver.proxy;
    BtObserver.proxy = observer;
    if (widget.updateKey != null) {
      // TODO: Feature: update widget by a string update key .
    }
    Widget view = widget.build(context);
    BtObserver.proxy = bak;
    if (observer._subscriptions.isEmpty) {
      __brother_error_log__(
          'The improper use of Btw has been detected. The btv value getter method didn\'t call, pls check your code/conditional logic.');
    }
    return view;
  }
}

/// Brother Notifier
class BtNotifier<T> {
  final BtStream<T> _stream = BtStream();

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

  void remove(BtSubscription<T> sub) {}
}

class BtKey extends BtNotifier {
  get eye => BtObserver.proxy?.addListener(this);

  @override
  void update() {
    _stream.add(null);
  }

  // Feature: update widget by a string update key .
  static Map<String, BtKey>? _map;

  static Map<String, BtKey> get map => (_map ??= {});
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
