import 'package:flutter/cupertino.dart';

// ByTheWay is the simplified version for GetX widget/state management.

/// ByTheWay Values
class Bt<T> extends BtNotifier<T> {
  Bt(T initial) : super() {
    _value = initial;
  }
}

extension ExtBtT<T> on T {
  Bt<T> get btw => Bt<T>(this);
}

extension ExtBtString on String {
  Bt<String> get btw => Bt(this);
}

extension ExtBtBool on bool {
  Bt<bool> get btw => Bt(this);
}

extension ExtBtInt on int {
  Bt<int> get btw => Bt(this);
}

extension ExtBtDouble on double {
  Bt<double> get btw => Bt(this);
}

/// ByTheWay Widgets
class Btw extends BtwWidget {
  Widget Function() builder;

  Btw({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build() => builder();
}

abstract class BtwWidget extends StatefulWidget {
  const BtwWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BtwWidgetState();

  @protected
  Widget build();
}

class _BtwWidgetState extends State<BtwWidget> {
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
  }

  @override
  Widget build(BuildContext context) {
    BtObserver? bak = BtObserver.proxy;
    BtObserver.proxy = observer;
    Widget view = widget.build();
    BtObserver.proxy = bak;
    return view;
  }
}

/// ByTheWay Notifier
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

  void update() {
    _stream.add(_value);
  }

  BtSubscription<T> listen(void Function(T data)? onData) {
    return _stream.listen(onData);
  }

  void remove(BtSubscription<T> sub) {}
}

/// ByTheWay Observer
class BtObserver<T> {
  static BtObserver? proxy;

  final BtStream<T> _stream = BtStream();
  final _subscriptions = <BtNotifier, List<BtSubscription<T>>>{}; // for reclaim notifier resources on close

  void addListener(BtNotifier<T> btwNotifier) {
    if (!_subscriptions.containsKey(btwNotifier)) {
      BtSubscription<T> sub = btwNotifier.listen((data) {
        if (!_stream.isClosed) _stream.add(data);
      });
      _subscriptions[btwNotifier] ??= <BtSubscription<T>>[];
      _subscriptions[btwNotifier]?.add(sub);
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

/// ByTheWay Stream
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

/// ByTheWay Subscription
class BtSubscription<T> {
  void Function(T data)? onData;

  bool isClosed = false;

  void close() {
    isClosed = true;
  }
}

/// ByTheWay Log Utilities
bool btw_debug_log_enable = true;

__btw_log__(String log) {
  assert(() {
    if (btw_debug_log_enable) {
      print('[__btw_log__] $log');
    }
    return true;
  }());
}
