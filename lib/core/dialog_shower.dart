import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialog_shower/event/keyboard_event_listener.dart'; // delete this line if u dont need keyboard interaction.

class DialogShower {
  static BuildContext? gContext;
  static NavigatorObserverEx? gObserver;
  static const Decoration _notInitializedDecoration = BoxDecoration();

  bool isSyncShow = false; // should assign value before show method
  bool isSyncDismiss = false;
  bool isSyncInvokeShowCallback = false;
  bool isSyncInvokeDismissCallback = false;

  // navigate
  BuildContext? context;
  bool isUseRootNavigator = true;
  Color barrierColor = Colors.transparent;
  bool? barrierDismissible = false;
  String barrierLabel = "";
  Duration transitionDuration = const Duration(milliseconds: 250);
  RouteTransitionsBuilder? transitionBuilder;
  bool isDismissKeyboardOnTapped = true;

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
  bool Function(DialogShower shower, Offset point)? dialogOnTapCallback;
  bool Function(DialogShower shower, Offset point)? barrierOnTapCallback;
  bool Function(DialogShower shower, Offset point, bool isTapInside)? wholeOnTapCallback;

  ShowerVisibilityCallBack? showCallBack = null;
  ShowerVisibilityCallBack? dismissCallBack = null;

  List<ShowerVisibilityCallBack>? showCallbacks = null;
  List<ShowerVisibilityCallBack>? dismissCallbacks = null;

  void addShowCallBack(ShowerVisibilityCallBack callBack) => (showCallbacks = showCallbacks ?? []).add(callBack);

  void removeShowCallBack(ShowerVisibilityCallBack callBack) => (showCallbacks = showCallbacks ?? []).remove(callBack);

  void addDismissCallBack(ShowerVisibilityCallBack callBack) => (dismissCallbacks = dismissCallbacks ?? []).add(callBack);

  void removeDismissCallBack(ShowerVisibilityCallBack callBack) => (dismissCallbacks = dismissCallbacks ?? []).remove(callBack);

  KeyboardVisibilityCallBack? keyboardEventCallBack;
  StreamSubscription? _keyboardStreamSubscription;

  // modified/assigned internal .....
  String routeName = '';
  bool _isShowing = false;

  bool get isShowing => _isShowing;

  final Completer<bool> _pushedCompleter = Completer<bool>();
  final Completer<bool> _poppedCompleter = Completer<bool>();
  bool _isPushed = false;
  bool _isPopped = false;

  bool get isPushed => _isPushed;

  bool get isPopped => _isPopped;

  set isPushed(v) => (_isPushed = v) ? Future.microtask(() => _pushedCompleter.complete(v)) : null;

  set isPopped(v) => (_isPopped = v) ? Future.microtask(() => _poppedCompleter.complete(v)) : null;

  Future<void> get futurePushed => _pushedCompleter.future;

  Future<void> get futurePoped => _poppedCompleter.future;

  Future<void>? _future;

  Future<void> get future async {
    if (_future == null) {
      await futurePushed; // future pushed indeed
    }
    return _future;
  }

  Future<R>? then<R>(FutureOr<R> Function(void value) onValue, {Function? onError}) => future.then(onValue, onError: onError);

  // private .....
  TapUpDetails? _tapUpDetails;

  get tapUpDetails => _tapUpDetails;

  // final GlobalKey _builderExKey = GlobalKey();
  // get builderExKey => _builderExKey;
  final GlobalKey _statefulKey = GlobalKey();

  get statefulKey => _statefulKey;
  final GlobalKey _containerKey = GlobalKey();

  get containerKey => _containerKey;

  // extension for navigate inner dialog
  bool isWrappedByNavigator = false;
  bool isAutoSizeForNavigator = true;
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
        __shower_log__('current context already with a navigator >>> $navigator');
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
        __shower_log__('found another navigator from ancestor >>> $anotherNavigator');
        return true;
      }());
      navigator = anotherNavigator;
    }
    RenderObject? naviRenderObject = naviContext?.findRenderObject();
    assert(() {
      __shower_log__('naviState >>> $naviState, naviContext >>> $naviContext, naviWidget >>> $naviWidget, navigator >>> $navigator,'
          ' naviRenderObject >>> $naviRenderObject');
      return true;
    }());

    if (navigator?.observers.contains(DialogShower.getObserver()) ?? false) {
      assert(() {
        __shower_log__('already register observer in navigator!!!!');
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
    isSyncShow ? _show(_child, width: width, height: height) : Future.microtask(() => _show(_child, width: width, height: height));
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
      __shower_log__('>>>>>>>>>>>>>> showing: $routeName');
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
    if (NavigatorObserverEx.statesChangingShowers?[routeName] == null) {
      isPushed = true;
    }

    assert(() {
      __shower_log__('>>>>>>>>>>>>>> showed: $routeName');
      return true;
    }());
    return future;
  }

  Widget _getInternalWidget(Widget _child) {
    return BuilderEx(
      // key: _builderExKey,
      showCallBack: () {
        isSyncInvokeShowCallback ? _invokeShowCallbacks() : Future.microtask(() => _invokeShowCallbacks());

        // keyboard visibility
        if (keyboardEventCallBack != null) {
          _keyboardStreamSubscription?.cancel();
          _keyboardStreamSubscription = KeyboardEventListener.listen((isKeyboardShow) {
            keyboardEventCallBack?.call(this, isKeyboardShow);
          });
        }
      },
      dismissCallBack: () {
        isSyncInvokeDismissCallback ? _invokeDismissCallbacks() : Future.microtask(() => _invokeDismissCallbacks());

        // keyboard visibility
        _keyboardStreamSubscription?.cancel();
        _keyboardStreamSubscription = null;
      },
      builder: (BuildContext context) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            assert(() {
              __shower_log__('TapDownDetails: ${details.globalPosition}, ${details.localPosition}, ${details.kind}');
              return true;
            }());
            _tapUpDetails = null;
          },
          onTapUp: (TapUpDetails details) {
            assert(() {
              __shower_log__('TapUpDetails: ${details.globalPosition}, ${details.localPosition}, ${details.kind}');
              return true;
            }());
            _tapUpDetails = details;
          },
          onTap: () {
            assert(() {
              __shower_log__('Checking onTap details, keyboard is ${DialogShower.isKeyboardShowing() ? '' : 'not'} showing');
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
                __shower_log__('HitTest: Container [$x1, $y1], [$x2, $y2]. Tap [$tapX, $tapY]. '
                    'isTapInside X$isTapInsideX && Y$isTapInsideY = $isTapInside, '
                    'barrierDismissible: $barrierDismissible, I\'m showing: $isShowing');
                return true;
              }());

              bool v = wholeOnTapCallback?.call(this, tapPoint, isTapInside) ?? false;
              if (v) {
                return;
              }

              if (isDismissKeyboardOnTapped && DialogShower.isKeyboardShowing()) {
                // https://github.com/flutter/flutter/issues/48464
                FocusManager.instance.primaryFocus?.unfocus();
                assert(() {
                  __shower_log__('I dismiss the keyboard, if you dislike this default behaviour, set isDismissKeyboardOnTapped = false');
                  return true;
                }());
              }

              if (isTapInside) {
                if (dialogOnTapCallback?.call(this, tapPoint) ?? false) {
                  return;
                }
              } else {
                if (barrierOnTapCallback?.call(this, tapPoint) ?? false) {
                  return;
                }
                if (barrierDismissible == null) {
                  if (DialogShower.isKeyboardShowing()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    assert(() {
                      __shower_log__('I dismiss the keyboard, if u dislike this default behaviour, do not set barrierDismissible = null');
                      return true;
                    }());
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
      __shower_log__('self: _width: $_width, _height: $_height');
      __shower_log__(
          'Window: mWidth: $mWidth, mHeight: $mHeight, mTop: $mTop; MediaQuery kWidth: $kWidth, kHeight: $kHeight, kTop: $kTop');
      __shower_log__('Media.Window width: ${query.size.width}, height: ${query.size.height}, padding: ${query.padding}');
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
          // _tryToGetContainerSize(); // replace with _tryToGetSizeOrNot now
          _isTryToGetSmallestSize = true;
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
      __shower_log__('_margin: $_margin, alignment: $alignment, animationBeginOffset: $animationBeginOffset');
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

  bool _isTryToGetSmallestSize = false;

  Widget _getContainer(Widget child, double? width, double? height) {
    Widget ccccc = child;
    Widget widget = ccccc;
    if (isWrappedByNavigator && isAutoSizeForNavigator && width == null && height == null) {
      __shower_log__('[GetSizeWidget] try to get size, casue navigator will lead to max stretch of container child ...');
      _isTryToGetSmallestSize = true;
    }

    if (_isTryToGetSmallestSize && width == null && height == null) {
      __shower_log__('[GetSizeWidget] try for getting size now ...');
      widget = GetSizeWidget(
        isInvokedOnlyOnSizeChanged: true,
        onLayoutChanged: (box, legacy, size) {
          __shower_log__('[GetSizeWidget] onSizeChanged was called >>>>>>>>>>>>> size: $size');
          _setRenderedSizeWithSetState(size);
        },
        child: ccccc,
      );
    } else if (isWrappedByNavigator) {
      __shower_log__('show with navigator');
      _navigatorKey = GlobalKey<NavigatorState>();
      widget = Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
              return ccccc;
            },
          );
        },
      );
    }

    // cause add Clip.antiAlias, the radius will not cover by child, u need to set Clip.none if u paint shadow by your self
    // flutter source will throw: Failed assertion: 'decoration != null || clipBehavior == Clip.none': is not true.
    Decoration? decoration = containerDecoration == _notInitializedDecoration ? _defContainerDecoration() : containerDecoration;
    Clip clipBehavior = decoration == null ? Clip.none : containerClipBehavior;

    // the container as mini as possible for calculate the point if tapped inside
    return Container(
      key: _containerKey,
      width: width,
      height: height,
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: widget,
    );
  }

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      assert(() {
        __shower_log__('>>>>>>>>>>>>>> popping: $routeName');
        return true;
      }());
      isSyncDismiss ? _dissmiss() : Future.microtask(() => _dissmiss());
      assert(() {
        __shower_log__('>>>>>>>>>>>>>> popped: $routeName');
        return true;
      }());
      if (NavigatorObserverEx.statesChangingShowers?[routeName] == null) {
        isPopped = true;
      }
      await futurePoped;
      assert(() {
        __shower_log__('>>>>>>>>>>>>>> popped done: $routeName');
        return true;
      }());
      NavigatorObserverEx.statesChangingShowers?.remove(routeName);
    }
  }

  // pop will caused NavigatorObserver.didPop method call immediately in the same eventloop
  // so u should put set isPopped into Future.microtask, the same as isPushed, in the same eventloop as push
  void _dissmiss() => Navigator.of(context!, rootNavigator: isUseRootNavigator).pop();

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
      __shower_log__('[DialogShower] setState was called, rebuilding...');
      return true;
    }());
    // _builderExKey.currentState?.setState(fn);
    _statefulKey.currentState?.setState(fn);
  }

  /// Private methods

  void _invokeShowCallbacks() {
    showCallBack?.call(this);
    for (int i = 0; i < (showCallbacks?.length ?? 0); i++) {
      showCallbacks?.elementAt(i).call(this);
    }
  }

  void _invokeDismissCallbacks() {
    dismissCallBack?.call(this);
    for (int i = 0; i < (dismissCallbacks?.length ?? 0); i++) {
      dismissCallbacks?.elementAt(i).call(this);
    }
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

  // Try to get container size if width or height when not given by caller
  void _tryToGetContainerSize({int index = 0}) {
    final List<int> tryTrickyTimes = [10, 10, 10, 20, 20, 30, 50, 50, 100];
    if (index < tryTrickyTimes.length) {
      Future.delayed(Duration(milliseconds: tryTrickyTimes[index]), () {
        Size? size = (_containerKey.currentContext?.findRenderObject() as RenderBox?)?.size;
        __shower_log__('_tryToGetContainerSize >>>>>>>>>>>>> $index size: $size');
        size == null ? _tryToGetContainerSize(index: index++) : _setRenderedSizeWithSetState(size);
      });
    }
  }

  void _setRenderedSizeWithSetState(Size? size) {
    _renderedWidth = size?.width;
    _renderedHeight = size?.height;
    if (_renderedWidth != null && _renderedHeight != null) {
      setState(() {});
    }
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
        __shower_log__('showCallBack exception: ${e.toString()}');
        e is Error ? __shower_log__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    assert(() {
      __shower_log__('[BuilderEx] >>>>>>>>>>>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      __shower_log__('[BuilderEx] >>>>>>>>>>>>>> build');
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
        __shower_log__('dismissCallBack exception: ${e.toString()}');
        e is Error ? __shower_log__(e.stackTrace?.toString() ?? 'No stackTrace') : null;
        return true;
      }());
    }
    super.dispose();
    assert(() {
      __shower_log__('[BuilderEx] >>>>>>>>>>>>>> dispose');
      return true;
    }());
  }
}

/// For observer lifecycle
class NavigatorObserverEx extends NavigatorObserver {
  static Map<String, DialogShower>? statesChangingShowers;

  // init this map only when the App observers contains this instance / didPush indicate that contains is true
  static ensureInit() {
    statesChangingShowers ??= {};
  }

  NavigatorObserverEx() : super();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    ensureInit();

    assert(() {
      __shower_log__('didPush: ${route.settings.name}');
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
      __shower_log__('didPop: ${route.settings.name}');
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
      __shower_log__('didRemove: ${route.settings.name}');
      return true;
    }());
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    assert(() {
      __shower_log__('didReplace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
      return true;
    }());
  }
}

/// For get size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final bool isInvokedOnlyOnSizeChanged;
  final void Function(RenderProxyBox box, Size? legacy, Size? size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged, this.isInvokedOnlyOnSizeChanged = true})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    __shower_log__('[GetSizeWidget] createRenderObject');
    return _GetSizeRenderObject()
      ..onLayoutChanged = onLayoutChanged
      ..isInvokedOnlyOnSizeChanged = isInvokedOnlyOnSizeChanged;
  }
}

class _GetSizeRenderObject extends RenderProxyBox {
  Size? _size;
  late bool isInvokedOnlyOnSizeChanged;
  late void Function(RenderProxyBox box, Size? legacy, Size? size) onLayoutChanged;

  @override
  void performLayout() {
    super.performLayout();

    Size? size = child?.size;
    __shower_log__('[GetSizeWidget] performLayout >>>>>>>>> size: $size');
    bool isSizeChanged = size != null && size != _size;
    if (!isInvokedOnlyOnSizeChanged || isSizeChanged) {
      _invoke(_size, size);
    }
    if (isSizeChanged) {
      _size = size;
    }
  }

  void _invoke(Size? legacy, Size? size) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      onLayoutChanged.call(this, legacy, size);
    });
  }
}

bool shower_log_enable = true;

__shower_log__(String log) {
  assert(() {
    if (shower_log_enable) {
      print('[DialogShower] $log');
    }
    return true;
  }());
}

typedef ShowerVisibilityCallBack = void Function(DialogShower shower);
typedef KeyboardVisibilityCallBack = void Function(DialogShower shower, bool isKeyboardShow);
