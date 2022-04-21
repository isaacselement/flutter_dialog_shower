
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';


/// For setSate & show or dismiss callback
class BuilderEx extends StatefulWidget {
  final String? name;
  final WidgetBuilder builder;
  final Function()? showCallBack, dismissCallBack;

  const BuilderEx({Key? key, required this.builder, this.name, this.showCallBack, this.dismissCallBack}) : super(key: key);

  @override
  State<BuilderEx> createState() => BuilderExState();
}

class BuilderExState extends State<BuilderEx> /* with TickerProviderStateMixin */ {
  @override
  void initState() {
    super.initState();
    try {
      widget.showCallBack?.call();
    } catch (e) {
      assert(() {
        __boxes_log__('showCallBack exception: ${e.toString()}');
        e is Error ? __boxes_log__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    assert(() {
      __boxes_log__('[BuilderEx] ${widget.name} >>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      __boxes_log__('[BuilderEx] ${widget.name} >>>>> build');
      return true;
    }());
    return widget.builder(context);
  }

  @override
  void dispose() {
    try {
      widget.dismissCallBack?.call();
    } catch (e) {
      assert(() {
        __boxes_log__('dismissCallBack exception: ${e.toString()}');
        e is Error ? __boxes_log__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    super.dispose();
    assert(() {
      __boxes_log__('[BuilderEx] ${widget.name} >>>>> dispose');
      return true;
    }());
  }
}


/// For setSate & ticker animation
class StatefulBuilderEx extends StatefulWidget {
  final StatefulWidgetBuilder builder;

  const StatefulBuilderEx({Key? key, required this.builder}) : super(key: key);

  @override
  State<StatefulBuilderEx> createState() => StatefulBuilderExState();
}

class StatefulBuilderExState extends State<StatefulBuilderEx> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}


/// For get size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(RenderProxyBox box, Size? legacy, Size size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    __boxes_log__('[GetSizeWidget] createRenderObject');
    return _GetSizeRenderObject()..onLayoutChanged = onLayoutChanged;
  }
}

class _GetSizeRenderObject extends RenderProxyBox {
  Size? _size;
  late void Function(RenderProxyBox box, Size? legacy, Size size) onLayoutChanged;

  @override
  void performLayout() {
    super.performLayout();

    Size? size = child?.size;
    __boxes_log__('[GetSizeWidget] performLayout >>>>>>>>> size: $size');
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


bool boxes_log_enable = true;

__boxes_log__(String log) {
  assert(() {
    if (boxes_log_enable) {
      print('[DialogShower] $log');
    }
    return true;
  }());
}
