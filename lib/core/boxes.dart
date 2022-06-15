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
}

/// For setSate & show or dismiss callback
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
      Boxes.log('[BuilderEx] ${widget.name} showCallBack exception: ${e.toString()}');
      Boxes.log(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Boxes.log(s.toString());
    }
    assert(() {
      Boxes.log('[BuilderEx] ${widget.name} >>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      Boxes.log('[BuilderEx] ${widget.name} >>>>> build');
      return true;
    }());
    return widget.builder(context, setState);
  }

  @override
  void dispose() {
    try {
      widget.disposeCallBack?.call();
    } catch (e, s) {
      Boxes.log('[BuilderEx] ${widget.name} dismissCallBack exception: ${e.toString()}');
      Boxes.log(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      Boxes.log(s.toString());
    }
    super.dispose();
    assert(() {
      Boxes.log('[BuilderEx] ${widget.name} >>>>> dispose');
      return true;
    }());
  }
}

/// For setSate & ticker animation
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

/// For get Size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    Boxes.log('[GetSizeWidget] createRenderObject');
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
    Boxes.log('[GetSizeWidget] performLayout >>>>>>>>> size: $size');
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

/// For get Offset immediately
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
