// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Boxes<T> {
  T? object;

  static SingletonFlutterWindow getWindow() {
    return window; // getWidgetsBinding().window;
  }

  static WidgetsBinding getWidgetsBinding() {
    return WidgetsBinding.instance!; // remove the ! not-null sign, if you want to support Flutter v3.x.x
  }
}

class Journal {
  static bool enable = false;

  /// https://dart.dev/guides/language/language-tour#assert
  /// Only print and evaluate the expression function on debug mode, will omit in production/profile mode
  static void console(String Function() expr) {
    assert(() {
      if (enable) {
        print(expr());
      }
      return true;
    }());
  }

  static void d(String log) {
    assert(() {
      if (enable) {
        print('[Boxes] $log');
      }
      return true;
    }());
  }
}

/// Extensions

/// extension of List
extension ListBoxesEx<E> on List<E> {
  E? get firstSafe => atSafe(0);

  E? get lastSafe => atSafe(length - 1);

  E? atSafe(int index) => (isEmpty || index < 0 || index >= length) ? null : elementAt(index);
}

extension StringX on String {
  // https://github.com/flutter/flutter/issues/18761
  String get overflow => Characters(this).replaceAll(Characters(''), Characters('\u{200B}')).toString();
}

/// View

/// Widget for setSate & init & dispose callback
class BuilderEx extends StatefulWidget {
  final String? name;
  final Function(State state) builder;
  final Function(State state)? init, dispose;

  const BuilderEx({Key? key, required this.builder, this.name, this.init, this.dispose}) : super(key: key);

  @override
  State createState() => BuilderExState();
}

class BuilderExState extends State<BuilderEx> {
  @override
  void initState() {
    BuilderExState.callWidgetInit(widget, this);
    super.initState();
  }

  static void callWidgetInit(BuilderEx widget, State state) {
    try {
      widget.init?.call(state);
    } catch (e, s) {
      Journal.d('[$state] ${widget.name} showCallBack exception: ${e.toString()}');
      Journal.d(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Journal.d(s.toString());
    }
    assert(() {
      Journal.d('[$state] ${widget.name} >>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    return BuilderExState.callWidgetBuilder(widget, this);
  }

  static Widget callWidgetBuilder(BuilderEx widget, State state) {
    assert(() {
      Journal.d('[$state] ${widget.name} >>>>> build');
      return true;
    }());
    return widget.builder(state);
  }

  @override
  void dispose() {
    BuilderExState.callWidgetDispose(widget, this);
    super.dispose();
  }

  static void callWidgetDispose(BuilderEx widget, State state) {
    try {
      widget.dispose?.call(state);
    } catch (e, s) {
      Journal.d('[$state] ${widget.name} dismissCallBack exception: ${e.toString()}');
      Journal.d(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Journal.d(s.toString());
    }
    assert(() {
      Journal.d('[$state] ${widget.name} >>>>> dispose');
      return true;
    }());
  }
}

/// Widget for setSate & ticker animation
class BuilderWithTicker extends BuilderEx {
  const BuilderWithTicker({
    Key? key,
    String? name,
    Function(State state)? init,
    Function(State state)? dispose,
    required Function(State state) builder,
  }) : super(key: key, builder: builder, name: name, init: init, dispose: dispose);

  @override
  State createState() => BuilderWithTickerState();
}

// Do not extends BuilderExState with a mixin ?????? Cause it parent class will be TickerProviderStateMixin$BuilderExState -> BuilderExState
// We need to call widget dispose first, otherwise will call TickerProviderStateMixin dipose method first ????????????
class BuilderWithTickerState extends State<BuilderWithTicker> with TickerProviderStateMixin {
  @override
  void initState() {
    BuilderExState.callWidgetInit(widget, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuilderExState.callWidgetBuilder(widget, this);
  }

  @override
  void dispose() {
    BuilderExState.callWidgetDispose(widget, this);
    super.dispose();
  }
}

/// Widget for get Size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    Journal.d('[$runtimeType] createRenderObject');
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
    Journal.d('[$runtimeType] performLayout >>>>>>>>> size: $size');
    bool isSizeChanged = size != null && size != _size;
    if (isSizeChanged) {
      _invoke(_size, size);
    }
    if (isSizeChanged) {
      _size = size;
    }
  }

  void _invoke(Size? legacy, Size size) {
    Boxes.getWidgetsBinding().addPostFrameCallback((timeStamp) {
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
    Boxes.getWidgetsBinding().addObserver(this);
    Boxes.getWidgetsBinding().addPostFrameCallback(_rameCallback);
    super.initState();
  }

  @override
  void dispose() {
    Boxes.getWidgetsBinding().removeObserver(this);
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
    Boxes.getWidgetsBinding().addPostFrameCallback((timeStamp) {
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
  Duration delay = const Duration(milliseconds: 800);

  void call(Function func, {Duration? duration}) {
    String symbol = '$runtimeType.call';
    bool isSyncCall = StackTrace.current.toString().replaceFirst(symbol, '_').contains(symbol);
    if (isSyncCall) {
      if (callers.contains(this)) {
        Journal.d('????????? Do not call function ThrottleAny.call in the same stack with the same instance of ThrottleAny! ${callers.length}');
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

  static Map<String, ThrottleAny>? maps;

  static ThrottleAny get(String key) {
    maps ??= {};
    return (maps?[key] ??= ThrottleAny())!;
  }

  static ThrottleAny? remove(String key) {
    return maps?.remove(key);
  }
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

  static Map<String, DebouncerAny>? maps;

  static DebouncerAny get(String key) {
    maps ??= {};
    return (maps?[key] ??= DebouncerAny())!;
  }

  static DebouncerAny? remove(String key) {
    return maps?.remove(key);
  }
}
