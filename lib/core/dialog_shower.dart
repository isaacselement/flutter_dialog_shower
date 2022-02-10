import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialog_shower/listener/keyboard_event_listener.dart';

class DialogShower {
  static BuildContext? gContext;
  static NavigatorObserverEx? gObserver;
  static const Decoration _notInitializedDecoration = BoxDecoration();

  // navigate
  BuildContext? context;
  bool isUseRootNavigator = true;
  Color barrierColor = Colors.transparent;
  bool? barrierDismissible = false;
  String barrierLabel = "";
  Duration transitionDuration = const Duration(milliseconds: 250);
  RouteTransitionsBuilder? transitionBuilder;

  // scaffold
  Color? scaffoldBackgroundColor = Colors.transparent;

  // Animation direction  // default from Bottom
  Offset? animationBeginOffset = const Offset(0.0, 1.0);

  // Important!!! alignment center default!!!
  AlignmentGeometry? alignment = Alignment.center;

  // container
  EdgeInsets? margin;
  double? width;
  double? height;
  double? _renderedWidth;
  double? _renderedHeight;

  Clip containerClipBehavior = Clip.antiAlias;
  Decoration? containerDecoration = _notInitializedDecoration;
  double containerBorderRadius = 0.0;
  Color containerBackgroundColor = Colors.white;
  List<BoxShadow>? containerBoxShadow;
  double containerShadowBlurRadius = 0.0;
  Color containerShadowColor = Colors.transparent;

  // events
  bool Function(DialogShower shower, Offset point)? wholeOnTapCallback;
  bool Function(DialogShower shower, Offset point)? dialogOnTapCallback;
  bool Function(DialogShower shower, Offset point)? barrierOnTapCallback;

  ShowerVisibilityCallBack? showCallBack = null;
  ShowerVisibilityCallBack? dismissCallBack = null;

  List<ShowerVisibilityCallBack>? showCallbacks = null;
  List<ShowerVisibilityCallBack>? dismissCallbacks = null;

  void addShowCallBack(ShowerVisibilityCallBack callBack) {
    (showCallbacks = showCallbacks ?? []).add(callBack);
  }

  void removeShowCallBack(ShowerVisibilityCallBack callBack) {
    (showCallbacks = showCallbacks ?? []).remove(callBack);
  }

  void addDismissCallBack(ShowerVisibilityCallBack callBack) {
    (dismissCallbacks = dismissCallbacks ?? []).add(callBack);
  }

  void removeDismissCallBack(ShowerVisibilityCallBack callBack) {
    (dismissCallbacks = dismissCallbacks ?? []).remove(callBack);
  }

  KeyboardVisibilityCallBack? keyboardEventCallBack = null;
  StreamSubscription? _keyboardStreamSubscription = null;

  // modified/assigned internal .....
  String routeName = '';
  bool _isShowing = false;

  bool get isShowing => _isShowing;

  Completer<bool>? _pushedCompleter;
  Completer<bool>? _poppedCompleter;
  bool _isPushed = false;
  bool _isPopped = false;

  bool get isPushed => _isPushed;

  set isPushed(v) => (_isPushed = v) ? _pushedCompleter?.complete(v) : null;

  bool get isPopped => _isPopped;

  set isPopped(v) => (_isPopped = v) ? _poppedCompleter?.complete(v) : null;

  Future<void>? _future = null;

  Future<void> get future async {
    if (_future == null) {
      if (NavigatorObserverEx.statesChangingShowers?[routeName] != null) {
        await _pushedCompleter?.future;
      }
    }
    return _future;
  }

  // private .....
  TapUpDetails? _tapUpDetails;

  // final GlobalKey _builderExKey = GlobalKey();
  final GlobalKey _statefulKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();

  // extension for navigate inner dialog
  bool isWrappedByNavigator = false;
  GlobalKey<NavigatorState>? _navigatorKey;

  // holder object for various uses if you need ...
  Object? obj;

  /// Important!!! Navigator operation requested with a context that does include a Navigator.
  static void init(BuildContext context) {
    if (gContext == context) {
      return;
    }
    gContext = context;

    Navigator? navigator;
    if (context is Element && context.widget is Navigator) {
      navigator = context.widget as Navigator;
      assert(() {
        __log_print__('current context already with a navigator >>> $navigator');
        return true;
      }());
    }

    // Try to get app instance back here ....
    NavigatorState? naviState = context.findRootAncestorStateOfType<NavigatorState>();
    BuildContext? naviContext = naviState?.context;
    Widget? naviWidget = naviContext?.widget;
    Navigator? anotherNavigator = naviWidget != null && naviWidget is Navigator ? naviWidget : null;
    if (navigator != anotherNavigator) {
      assert(() {
        __log_print__('found another navigator from ancestor >>> $anotherNavigator');
        return true;
      }());
      navigator = anotherNavigator;
    }
    RenderObject? naviRenderObject = naviContext?.findRenderObject();
    assert(() {
      __log_print__('naviState >>> $naviState, naviContext >>> $naviContext, naviWidget >>> $naviWidget, navigator >>> $navigator,'
          ' naviRenderObject >>> $naviRenderObject');
      return true;
    }());

    if (navigator?.observers.contains(DialogShower.getObserver()) ?? false) {
      assert(() {
        __log_print__('already register observer in navigator!!!!');
        return true;
      }());
      NavigatorObserverEx.ensureInit();
    }
  }

  static NavigatorObserverEx getObserver() {
    gObserver ??= NavigatorObserverEx();
    return gObserver!;
  }

  DialogShower() {
    transitionBuilder = _defTransition;
  }

  DialogShower build([BuildContext? ctx]) {
    if (ctx == null && context != null) {
      return this;
    }
    context = ctx ?? gContext;
    return this;
  }

  DialogShower show(Widget _child, {double? width, double? height}) {
    routeName = routeName.isNotEmpty ? routeName : 'SHOWER-${DateTime.now().microsecondsSinceEpoch}'; // const Uuid().v1();

    NavigatorObserverEx.statesChangingShowers?[routeName] = this;
    if (NavigatorObserverEx.statesChangingShowers?[routeName] != null) {
      _pushedCompleter = Completer<bool>();
    }

    Future.microtask(() => _show(_child, width: width, height: height));
    return this;
  }

  DialogShower _show(Widget _child, {double? width, double? height}) {
    this.width = width ?? this.width;
    this.height = height ?? this.height;
    _showInternal(_child);
    return this;
  }

  Future<void> _showInternal(Widget _child) async {
    _isShowing = true;

    assert(() {
      __log_print__('>>>>>>>>>>>>>> showing: $routeName');
      return true;
    }());

    _future = showGeneralDialog(
      context: context!,
      useRootNavigator: isUseRootNavigator,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
      barrierLabel: barrierLabel,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      routeSettings: RouteSettings(
        name: routeName,
      ),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return _getInternalWidget(_child);
      },
    );

    assert(() {
      __log_print__('>>>>>>>>>>>>>> showed: $routeName');
      return true;
    }());
    return future;
  }

  Widget _getInternalWidget(Widget _child) {
    return BuilderEx(
      // key: _builderExKey,
      showCallBack: () {
        showCallBack?.call(this);
        for (int i = 0; i < (showCallbacks?.length ?? 0); i++) {
          showCallbacks?.elementAt(i).call(this);
        }

        // keyboard visibility
        if (keyboardEventCallBack != null) {
          _keyboardStreamSubscription?.cancel();
          _keyboardStreamSubscription = KeyboardEventListener.listen((isKeyboardShow) {
            keyboardEventCallBack?.call(this, isKeyboardShow);
          });
        }
      },
      dismissCallBack: () {
        dismissCallBack?.call(this);
        for (int i = 0; i < (dismissCallbacks?.length ?? 0); i++) {
          dismissCallbacks?.elementAt(i).call(this);
        }

        // keyboard visibility
        _keyboardStreamSubscription?.cancel();
        _keyboardStreamSubscription = null;
      },
      builder: (BuildContext context) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            assert(() {
              __log_print__('TapDownDetails: ${details.globalPosition}, ${details.localPosition}, ${details.kind}');
              return true;
            }());
            _tapUpDetails = null;
          },
          onTapUp: (TapUpDetails details) {
            assert(() {
              __log_print__('TapUpDetails: ${details.globalPosition}, ${details.localPosition}, ${details.kind}');
              return true;
            }());
            _tapUpDetails = details;
          },
          onTap: () {
            bool isKeyboardShowed = DialogShower.isKeyboardShowing();
            assert(() {
              __log_print__('Checking onTap details, keyboard is ${isKeyboardShowed ? '' : 'not'} showing');
              return true;
            }());

            if (_tapUpDetails != null) {
              RenderBox containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox;
              double w = containerBox.size.width;
              double h = containerBox.size.height;
              Offset p = containerBox.localToGlobal(Offset.zero);
              double x1 = p.dx;
              double y1 = p.dy;
              double x2 = x1 + w;
              double y2 = y1 + h;

              Offset tapPoint = _tapUpDetails!.globalPosition;
              double tapX = tapPoint.dx;
              double tapY = tapPoint.dy;
              bool isTapInsideX = x1 < tapX && tapX < x2;
              bool isTapInsideY = y1 < tapY && tapY < y2;
              bool isTapInside = isTapInsideX && isTapInsideY;

              assert(() {
                __log_print__(
                    'HitTest: Container [$x1, $y1], [$x2, $y2]. Tap [$tapX, $tapY]. isTapInside X$isTapInsideX && Y$isTapInsideY = $isTapInside, '
                    'barrierDismissible: $barrierDismissible, isShowing: $isShowing');
                return true;
              }());

              bool v = wholeOnTapCallback?.call(this, tapPoint) ?? false;
              if (v) {
                return;
              }

              if (isKeyboardShowed) {
                // https://github.com/flutter/flutter/issues/48464
                FocusManager.instance.primaryFocus?.unfocus(); // FocusScope.of(context).requestFocus(FocusNode());
              }

              if (isTapInside) {
                bool v = dialogOnTapCallback?.call(this, tapPoint) ?? false;
              } else {
                bool v = barrierOnTapCallback?.call(this, tapPoint) ?? false;
                if (v) {
                  return;
                }
                if (barrierDismissible == null) {
                  if (isKeyboardShowed) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    dismiss();
                  }
                } else if (barrierDismissible!) {
                  dismiss();
                }
              }
            }
          },
          child: Scaffold(
            appBar: null,
            backgroundColor: scaffoldBackgroundColor,
            body: StatefulBuilder(
              key: _statefulKey,
              builder: (context, setState) {
                return _getScaffoldBody(_child);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _getScaffoldBody(Widget _child) {
    // ---------------------------- calculate _margin, _width, _height ----------------------------
    double? _width = width ?? _renderedWidth;
    double? _height = height ?? _renderedHeight;

    MediaQueryData _queryData = MediaQuery.of(context!);
    double kWidth = _queryData.size.width;
    double kHeight = _queryData.size.height;

    assert(() {
      ui.SingletonFlutterWindow _window = WidgetsBinding.instance?.window ?? ui.window;
      double mWidth = _window.physicalSize.width;
      double mHeight = _window.physicalSize.height;

      MediaQueryData query = MediaQueryData.fromWindow(_window);
      double mTop = _window.padding.top;
      double kTop = _queryData.padding.top;
      __log_print__('self: _width: $_width, _height: $_height');
      __log_print__('Window: mWidth: $mWidth, mHeight: $mHeight, mTop: $mTop; MediaQuery kWidth: $kWidth, kHeight: $kHeight, kTop: $kTop');
      __log_print__('Media.Window width: ${query.size.width}, height: ${query.size.height}, padding: ${query.padding}');
      return true;
    }());

    // We use a Padding outside for handle vertically center instead of Container Alignment.Center, cause when keyboard comes out once child get focus,
    // will make the child stick to the top of the container.

    EdgeInsets? _margin;

    // when the Scaffold's body is Padding instead of Container (or Container without height & alignment) , you should calculate the top padding
    // if you do not use a calculated value as padding top (when use the alignment or set height for align center child), it child will stick to screen top when keyboard show up !!!

    if (margin != null) {
      EdgeInsets m = margin!;
      if (m.top < 0 || m.left < 0) {
        if (_width == null || _height == null) {
          _tryToGetContainerSize();
        }

        // [Center Vertically] if height is given when margin not given or top is negative
        double centerTop = _height != null ? (kHeight - _height) / 2 : 0;
        // [Center Horizontal] if width is given when margin not given or top is negative
        double centerLeft = _width != null ? (kWidth - _width) / 2 : 0;
        _margin = EdgeInsets.fromLTRB(m.left < 0 ? centerLeft : m.left, m.top < 0 ? centerTop : m.top, m.right, m.bottom);
      } else {
        _margin = m;
      }
    }

    assert(() {
      __log_print__('_margin: $_margin, alignment: $alignment, animationBeginOffset: $animationBeginOffset');
      return true;
    }());
    // ---------------------------- calculate _margin, _width, _height ----------------------------

    // alignment == null
    Widget smallestContainer = _getContainer(_child, _width, _height);
    if (alignment == null) {
      return _margin != null ? Padding(padding: _margin, child: smallestContainer) : smallestContainer;
    } else {
      return Container(
        // color: Colors.red,
        padding: _margin,
        alignment: alignment,
        child: smallestContainer,
      );
    }
  }

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      assert(() {
        __log_print__('>>>>>>>>>>>>>> popping: $routeName');
        return true;
      }());

      Future.microtask(() {
        Navigator.of(context!, rootNavigator: isUseRootNavigator).pop();
      });

      /// ISSUE: Failed assertion: line 4595 pos 12: '!_debugLocked': is not true.
      // will call NavigatorObserver didPop method immediately following, so u should put set isPopped into Future.microtask
      // Navigator.of(context!, rootNavigator: isUseRootNavigator).pop();

      if (NavigatorObserverEx.statesChangingShowers?[routeName] != null) {
        _poppedCompleter = Completer<bool>();
        await _poppedCompleter?.future;
        assert(() {
          __log_print__('>>>>>>>>>>>>>> popped: $routeName');
          return true;
        }());
        NavigatorObserverEx.statesChangingShowers?.remove(routeName);
      }
    }
  }

  /// For navigator
  NavigatorState? getNavigator() {
    return _navigatorKey?.currentState;
  }

  Future<T?> push<T extends Object?>(
    Widget widget, {
    PageRouteBuilder<T>? routeBuilder,
    RoutePageBuilder? pageBuilder,
    RouteTransitionsBuilder? transition,

    // copy from PageRouteBuilder constructor
    RouteSettings? settings,
    duration = const Duration(milliseconds: 300),
    reverseDuration = const Duration(milliseconds: 300),
    opaque = true,
    barrierDismissible = false,
    barrierColor,
    barrierLabel,
    maintainState = true,
    fullscreenDialog = false,
  }) {
    transition = transition ?? _defTransition;
    pageBuilder = pageBuilder ?? (ctx, animOne, animTwo) => widget;
    routeBuilder = routeBuilder ??
        PageRouteBuilder<T>(
          pageBuilder: pageBuilder,
          transitionsBuilder: transition,
          settings: settings,
          transitionDuration: duration ?? const Duration(milliseconds: 300),
          reverseTransitionDuration: reverseDuration ?? const Duration(milliseconds: 300),
          opaque: opaque ?? true,
          barrierDismissible: barrierDismissible ?? false,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState ?? true,
          fullscreenDialog: fullscreenDialog ?? false,
        );
    return getNavigator()!.push<T>(routeBuilder);
  }

  void pop<T>({T? result}) {
    getNavigator()?.pop<T>(result);
  }

  /// self defined setState

  void setState(VoidCallback fn) {
    assert(() {
      __log_print__('[DialogShower] setState was called, rebuilding...');
      return true;
    }());
    // _builderExKey.currentState?.setState(fn);
    _statefulKey.currentState?.setState(fn);
  }

  /// Private methods

  Widget _getContainer(Widget? child, double? width, double? height) {
    Widget? widget = child;
    if (isWrappedByNavigator) {
      _navigatorKey = GlobalKey<NavigatorState>();
      widget = Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
              return child ?? const SizedBox();
            },
          );
        },
      );
    }

    // the container as mini as possible for calculate the point if tapped inside
    return
        // GetSizeWidget(
        //   onSizeChanged: (size) {
        //     __log_print__('[GetSizeWidget] onSizeChanged was called >>>>>>>>>>>>> size: $size');
        //     _tryToGetContainerSizeRaw();
        //   },
        //   child:
        Container(
      key: _containerKey,
      width: width,
      height: height,
      // cause add Clip.antiAlias, the radius will not cover by child, u need to set Clip.none if u paint shadow by your self
      // source will assert(decoration != null || clipBehavior == Clip.none),
      clipBehavior: containerClipBehavior,
      decoration: containerDecoration == _notInitializedDecoration ? _defContainerDecoration() : containerDecoration,
      child: widget, //child,
      // ),
    );
  }

  Decoration _defContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(containerBorderRadius),
      color: containerBackgroundColor,
      boxShadow: containerBoxShadow ??
          [
            BoxShadow(
              color: containerShadowColor,
              blurRadius: containerShadowBlurRadius,
            ),
          ],
    );
  }

  Widget _defTransition(BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child) {
    return _defTransitionRaw(ctx, animOne, animTwo, child, animationBeginOffset);
  }

  Widget _defTransitionRaw(BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child, Offset? beginOffset) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: const Offset(0.0, 0.0),
      ).animate(animOne),
      child: child,
    );
  }

  // Try to get container size if width or height not given by caller

  int _tryTickIndex = 0;

  final List<int> _tryTickTimes = [10, 10, 10, 20, 20, 30, 50, 50, 100];

  void _tryToGetContainerSize({int? index}) {
    if (index == null || index == 0) {
      _tryTickIndex = 0;
    }
    int? millis = _tryTickIndex < _tryTickTimes.length ? _tryTickTimes[_tryTickIndex] : null;
    if (millis == null) {
      return;
    }
    Future.delayed(Duration(milliseconds: millis), () {
      Size? size = _tryToGetContainerSizeRaw();
      if (size == null) {
        __log_print__('_tryToGetContainerSize >>>>>>>>>>>>> $_tryTickIndex retry again');
        _tryToGetContainerSize(index: _tryTickIndex++);
      } else {
        __log_print__('_tryToGetContainerSize >>>>>>>>>>>>> $_tryTickIndex size: $size');
      }
    });
  }

  Size? _tryToGetContainerSizeRaw() {
    RenderObject? renderObject = _containerKey.currentContext?.findRenderObject();
    RenderBox? containerBox = renderObject as RenderBox?;
    if (containerBox == null) {
      return null;
    }
    Size size = containerBox.size;
    _renderedWidth = size.width;
    _renderedHeight = size.height;
    setState(() {});
    return size;
  }

  /// Other Utils Methods
  // Note: you should DialogShower.init(context) first ~~~
  static bool isKeyboardShowing() {
    return MediaQuery.of(DialogShower.gContext!).viewInsets.bottom > 0;
  }
}

/**
 *
 * Classes Below
 *
 **/

/// For setSate & show or dismiss callback
class BuilderEx extends StatefulWidget {
  final WidgetBuilder builder;

  late Function()? showCallBack = null;
  late Function()? dismissCallBack = null;

  BuilderEx({
    Key? key,
    required this.builder,
    this.showCallBack,
    this.dismissCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BuilderExState();
}

class _BuilderExState extends State<BuilderEx> {
  @override
  void initState() {
    super.initState();
    try {
      widget.showCallBack?.call();
    } catch (e) {
      assert(() {
        __log_print__('showCallBack exception: ${e.toString()}');
        e is Error ? __log_print__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    assert(() {
      __log_print__('[BuilderEx] >>>>>>>>>>>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      __log_print__('[BuilderEx] >>>>>>>>>>>>>> build');
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
        __log_print__('dismissCallBack exception: ${e.toString()}');
        e is Error ? __log_print__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    super.dispose();
    assert(() {
      __log_print__('[BuilderEx] >>>>>>>>>>>>>> dispose');
      return true;
    }());
  }
}

/// For observer lifecycle
class NavigatorObserverEx extends NavigatorObserver {
  static Map<String, DialogShower>? statesChangingShowers;

  static ensureInit() {
    statesChangingShowers ??= {};
  }

  NavigatorObserverEx() : super();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    ensureInit();

    assert(() {
      __log_print__('didPush: ${route.settings.name}');
      return true;
    }());
    if (route.settings.name != null) {
      statesChangingShowers?[route.settings.name]?.isPushed = true;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    assert(() {
      __log_print__('didPop: ${route.settings.name}');
      return true;
    }());
    if (route.settings.name != null) {
      statesChangingShowers?[route.settings.name]?.isPopped = true;
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    assert(() {
      __log_print__('didRemove: ${route.settings.name}');
      return true;
    }());
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    assert(() {
      __log_print__('didReplace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
      return true;
    }());
  }
}

/// For get size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(Size size)? onSizeChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onSizeChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _GetSizeRenderObject()..onSizeChanged = onSizeChanged;
  }
}

class _GetSizeRenderObject extends RenderProxyBox {
  Size? _size;
  void Function(Size size)? onSizeChanged;

  @override
  void performLayout() {
    super.performLayout();
    Size? size = child?.size;
    __log_print__('[GetSizeRenderObject] performLayout >>>>>>>>> new size $size');
    if (size != null && size != _size) {
      _size = size;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        onSizeChanged?.call(size);
      });
    }
  }
}

__log_print__(String log) {
  assert(() {
    print('[DialogShower] $log');
    return true;
  }());
}

typedef ShowerVisibilityCallBack = void Function(DialogShower shower);
typedef KeyboardVisibilityCallBack = void Function(DialogShower shower, bool isKeyboardShow);
