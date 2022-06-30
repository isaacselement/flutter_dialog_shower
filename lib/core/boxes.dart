import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Boxes {
  static bool isDebugLogEnable = false;

  static log(String log) {
    assert(() {
      if (isDebugLogEnable) {
        if (kDebugMode) {
          print('[class $Boxes] $log');
        }
      }
      return true;
    }());
  }

  static SingletonFlutterWindow getWindow() {
    // return getWidgetsBinding().window;
    return window;
  }

  static WidgetsBinding getWidgetsBinding() {
    return WidgetsBinding.instance!;
  }
}

/// View

/// Widget for setSate & show or dismiss callback
class BuilderEx extends StatefulWidget {
  final String? name;
  final StatefulWidgetBuilder builder;
  final Function()? initCallBack, disposeCallBack;

  const BuilderEx({Key? key, required this.builder, this.name, this.initCallBack, this.disposeCallBack}) : super(key: key);

  @override
  State<BuilderEx> createState() => BuilderExState();
}

class BuilderExState extends State<BuilderEx> /* with TickerProviderStateMixin */ {
  @override
  void initState() {
    super.initState();
    try {
      widget.initCallBack?.call();
    } catch (e, s) {
      Boxes.log('[$runtimeType] ${widget.name} showCallBack exception: ${e.toString()}');
      Boxes.log(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Boxes.log(s.toString());
    }
    assert(() {
      Boxes.log('[$runtimeType] ${widget.name} >>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      Boxes.log('[$runtimeType] ${widget.name} >>>>> build');
      return true;
    }());
    return widget.builder(context, setState);
  }

  @override
  void dispose() {
    try {
      widget.disposeCallBack?.call();
    } catch (e, s) {
      Boxes.log('[$runtimeType] ${widget.name} dismissCallBack exception: ${e.toString()}');
      Boxes.log(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Boxes.log(s.toString());
    }
    super.dispose();
    assert(() {
      Boxes.log('[$runtimeType] ${widget.name} >>>>> dispose');
      return true;
    }());
  }
}

/// Widget for setSate & ticker animation
class BuilderWithTicker extends StatefulWidget {
  final StatefulWidgetBuilder builder;
  final Function()? initCallBack, disposeCallBack;

  const BuilderWithTicker({Key? key, required this.builder, this.initCallBack, this.disposeCallBack}) : super(key: key);

  @override
  State<BuilderWithTicker> createState() => BuilderWithTickerState();
}

class BuilderWithTickerState extends State<BuilderWithTicker> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void initState() {
    widget.initCallBack?.call();
    super.initState();
  }

  @override
  void dispose() {
    widget.disposeCallBack?.call();
    super.dispose();
  }
}

/// Widget for get Size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    Boxes.log('[$runtimeType] createRenderObject');
    return _GetSizeRenderObject()..onLayoutChanged = onLayoutChanged;
  }
}

class _GetSizeRenderObject extends RenderProxyBox {
  Size? _size;
  late void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  @override
  void performLayout() {
    super.performLayout();

    Size? size = child?.size;
    Boxes.log('[$runtimeType] performLayout >>>>>>>>> size: $size');
    bool isSizeChanged = size != null && size != _size;
    if (isSizeChanged) {
      _invoke(_size, size);
    }
    if (isSizeChanged) {
      _size = size;
    }
  }

  void _invoke(Size? legacy, Size size) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      onLayoutChanged.call(this, legacy, size);
    });
  }
}

/// Widget for get Offset immediately
class GetLayoutWidget extends StatefulWidget {
  final Widget child;
  final void Function(RenderBox box, Offset offset, Size size) onLayoutChanged;

  const GetLayoutWidget({Key? key, required this.child, required this.onLayoutChanged}) : super(key: key);

  @override
  State<GetLayoutWidget> createState() => _GetLayoutState();
}

class _GetLayoutState extends State<GetLayoutWidget> with WidgetsBindingObserver {
  late BuildContext _context;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback(_rameCallback);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return widget.child;
  }

  @override
  void didChangeMetrics() {
    final RenderBox box = _context.findRenderObject() as RenderBox;
    final Size size = box.size;
    final Offset offset = box.localToGlobal(Offset.zero);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.onLayoutChanged.call(box, offset, size);
    });
  }

  void _rameCallback(Duration timeStamp) {
    didChangeMetrics();
  }
}

/// Util

class ThrottleAny {
  bool enable = true;
  Duration delay = const Duration(milliseconds: 1000);

  void call(Function func, {Duration? duration}) {
    String symbol = '$runtimeType.call';
    bool isSyncCall = StackTrace.current.toString().replaceFirst(symbol, '_').contains(symbol);
    if (isSyncCall) {
      if (callers.contains(this)) {
        Boxes.log('❌❗️ Do not call function ThrottleAny.call in the same stack with the same instance of ThrottleAny! ${callers.length}');
        func();
        return;
      }
    }
    try {
      callers.add(this);
      _call(func, duration: duration);
    } catch (e) {
      rethrow;
    } finally {
      callers.remove(this);
    }
  }

  void _call(Function func, {Duration? duration}) {
    if (enable) {
      enable = false;
      func();
      Future.delayed(duration ?? delay, () {
        enable = true;
      });
    }
  }

  /// Static instance and methods

  static List<ThrottleAny> callers = [];

  static ThrottleAny? _instance;

  static ThrottleAny get instance => (_instance ??= ThrottleAny());
}

class DebouncerAny {
  Timer? timer;
  Duration delay = const Duration(milliseconds: 800);

  DebouncerAny();

  void call(void Function() action, {Duration? duration}) {
    timer?.cancel();
    timer = Timer(duration ?? delay, action);
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => timer?.cancel();

  /// Static instance and methods

  static DebouncerAny? _instance;

  static DebouncerAny get instance => (_instance ??= DebouncerAny());
}
