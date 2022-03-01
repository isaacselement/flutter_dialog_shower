import 'package:flutter/cupertino.dart';

// Brother is the simplified version for GetX widget/state management.
// Btw -> Observer/StatefulWidget, btv -> Notifier/Data. Wrap your widget with Btw in a scope as small as possible for best practice

/// Brother Values
class Bt<T> extends BtNotifier<T> {
  Bt(T initial) : super() {
    _value = initial;
  }
}

extension ExtBtT<T> on T {
  Bt<T> get btv => Bt<T>(this);
}

extension ExtBtString on String {
  Bt<String> get btv => Bt(this);
}

extension ExtBtBool on bool {
  Bt<bool> get btv => Bt(this);
}

extension ExtBtInt on int {
  Bt<int> get btv => Bt(this);
}

extension ExtBtDouble on double {
  Bt<double> get btv => Bt(this);
}

/// Brother Widgets
class Btw extends BtWidget {
  Widget Function() builder;

  Btw({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build() => builder();
}

abstract class BtWidget extends StatefulWidget {
  const BtWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BtWidgetState();

  @protected
  Widget build();
}

class _BtWidgetState extends State<BtWidget> {
  BtObserver observer = BtObserver();

  @override
  void initState() {
    super.initState();
    observer.listen((data) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    observer.close();
    super.dispose();
    __bt_debug_log__('BtWidget disposed');
  }

  @override
  Widget build(BuildContext context) {
    BtObserver? bak = BtObserver.proxy;
    BtObserver.proxy = observer;
    Widget view = widget.build();
    BtObserver.proxy = bak;
    if (observer._subscriptions.isEmpty) {
      __bt_error_log__(
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

  void add(T data) {
    _stream.add(data);
  }

  // just set data and you should update view later manually for calling update method
  set data(T data) {
    _value = data;
  }

  void update() {
    _stream.add(_value);
  }

  BtSubscription<T> listen(void Function(T data)? onData) {
    return _stream.listen(onData);
  }

  void remove(BtSubscription<T> sub) {}
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

  BtSubscription<T> listen(void Function(T data)? onData) {
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

  BtSubscription<T> listen(void Function(T data)? onData) {
    BtSubscription<T> sub = BtSubscription<T>();
    sub.onData = onData;
    subscriptions.add(sub);
    return sub;
  }

  void add(T data) {
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
class BtSubscription<T> {
  void Function(T data)? onData;

  bool isClosed = false;

  void close() {
    isClosed = true;
  }
}

/// Brother Log Utilities
bool bt_debug_log_enable = true;

__bt_debug_log__(String log) {
  assert(() {
    if (bt_debug_log_enable) {
      print('[__bt_log__] $log');
    }
    return true;
  }());
}

__bt_error_log__(String log) {
  print('❗️❗️❗️❗️❗️ ERROR: $log');
}
