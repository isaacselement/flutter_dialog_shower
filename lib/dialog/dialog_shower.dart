// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/boxes.dart';
import 'package:flutter_dialog_shower/event/keyboard_event_listener.dart';

class DialogShower {
  static BuildContext? gContext;
  static NavigatorObserverEx? gObserver;
  static const Decoration _notInitializedDecoration = BoxDecoration();

  /// Show & Dismiss properties for sync/async control
  bool isSyncShow = false; // should assign value before show method
  bool isSyncDismiss = false;

  /// Wrap with a TickerProviderStateMixin for animation
  bool isWithTicker = false;

  /// Navigator properties
  BuildContext? context;
  NavigatorState? navigator;
  bool isUseRootNavigator = true;

  NavigatorState get parentNavigator => navigator ?? Navigator.of(context!, rootNavigator: isUseRootNavigator);

  Color barrierColor = Colors.transparent;
  bool? barrierDismissible = false;
  String barrierLabel = "";
  bool isDismissKeyboardOnTapped = true;

  /// Navigator animation, default is SlideTransition from Bottom with 250 milliseconds duration
  Duration transitionDuration = const Duration(milliseconds: 250);
  RouteTransitionsBuilder? transitionBuilder = ShowerTransitionBuilder.slideFromBottom;

  late RawDialogRoute route;
  String routeName = ''; // should assign value before show method

  /// Scaffold properties
  Color? scaffoldBackgroundColor = Colors.transparent;
  Widget? Function(DialogShower shower)? scaffoldBodyBuilder;

  /// Container size & position
  AlignmentGeometry? alignment = Alignment.center;
  EdgeInsets? margin;
  EdgeInsets? padding;
  double? width;
  double? height;
  double? renderedWidth;
  double? renderedHeight;

  // should set alignment to Alignment.topLeft if u want base is top left for the x y. Then call setState of shower if set x y later .
  set x(double v) => padding = EdgeInsets.only(left: v, top: padding?.top ?? 0);

  set y(double v) => padding = EdgeInsets.only(left: padding?.left ?? 0, top: v);

  double get x => padding?.left ?? 0;

  double get y => padding?.top ?? 0;

  /// Container appearance
  Clip containerClipBehavior = Clip.antiAlias;
  Decoration? containerDecoration = _notInitializedDecoration;
  double containerBorderRadius = 0.0;
  Color? containerBackgroundColor = Colors.white;
  List<BoxShadow>? containerBoxShadow;
  double containerShadowBlurRadius = 0.0;
  Color containerShadowColor = Colors.transparent;

  /// Events
  TapUpDetails? _tapUpDetails;

  TapUpDetails? get tapUpDetails => _tapUpDetails;

  bool Function(DialogShower shower, Offset point)? dialogOnTapCallback;
  bool Function(DialogShower shower, Offset point)? barrierOnTapCallback;
  bool Function(DialogShower shower, Offset point, bool isTapInside)? wholeOnTapCallback;

  /// Event of show & dispose & dismiss
  ShowerVisibilityCallBack? showCallBack;
  List<ShowerVisibilityCallBack>? showCallbacks;

  void addShowCallBack(ShowerVisibilityCallBack call) => (showCallbacks ??= []).add(call);

  void removeShowCallBack(ShowerVisibilityCallBack call) => (showCallbacks ??= []).remove(call);

  void _invokeShowCallbacks() {
    showCallBack?.call(this);
    showCallbacks?.forEach((e) => e.call(this));
  }

  ShowerVisibilityCallBack? disposeCallBack;
  List<ShowerVisibilityCallBack>? disposeCallbacks;

  void addDisposeCallBack(ShowerVisibilityCallBack call) => (disposeCallbacks ??= []).add(call);

  void removeDisposeCallBack(ShowerVisibilityCallBack call) => (disposeCallbacks ??= []).remove(call);

  void _invokeDisposeCallbacks() {
    disposeCallBack?.call(this);
    disposeCallbacks?.forEach((e) => e.call(this));
  }

  ShowerVisibilityCallBack? dismissCallBack;
  List<ShowerVisibilityCallBack>? dismissCallbacks;

  void addDismissCallBack(ShowerVisibilityCallBack call) => (dismissCallbacks ??= []).add(call);

  void removeDismissCallBack(ShowerVisibilityCallBack call) => (dismissCallbacks ??= []).remove(call);

  void _invokeDismissCallbacks() {
    dismissCallBack?.call(this);
    dismissCallbacks?.forEach((e) => e.call(this));
  }

  /// Event of Keyboard
  KeyboardVisibilityCallBack? keyboardEventCallBack;

  StreamSubscription? _keyboardStreamSubscription;

  /// Shower has been built or not
  bool _isBuilt = false;

  final Completer<bool> builtCompleter = Completer<bool>();

  bool get isBuilt => _isBuilt;

  set _setIsBuilt(v) => (_isBuilt = v) ? builtCompleter.complete(v) : null;

  /// Shower is between the state's [init] phase and [dispose] phase or not
  bool _isShowing = false;

  bool get isShowing => _isShowing;

  bool _isPushed = false;
  bool _isPopped = false;
  final Completer<bool> pushedCompleter = Completer<bool>();
  final Completer<bool> poppedCompleter = Completer<bool>();

  bool get isPushed => _isPushed;

  bool get isPopped => _isPopped;

  set isPushed(v) => (_isPushed = v) ? pushedCompleter.complete(v) : null;

  set isPopped(v) => (_isPopped = v) ? poppedCompleter.complete(v) : null;

  /// Future indicate that shower has been dismissed
  Future<dynamic>? _future;

  Future<dynamic> get future async {
    if (_future == null) {
      await pushedCompleter.future; // just await future pushed indeed, then return the actually not null _future
    }
    return _future;
  }

  Future<R>? then<R>(FutureOr<R> Function(dynamic value) onValue, {Function? onError}) =>
      future.then(onValue, onError: onError);

  /// GlobalKey for shower rebuild/setState
  // GlobalKey<BuilderExState> get builderExKey => _builderExKey;
  // final GlobalKey<BuilderExState> _builderExKey = GlobalKey<BuilderExState>();

  GlobalKey get statefulKey => _statefulKey;
  final GlobalKey _statefulKey = GlobalKey();

  /// GlobalKey for container
  GlobalKey get containerKey => _containerKey;
  final GlobalKey _containerKey = GlobalKey();

  /// extension for inner nested navigator dialog
  bool isWrappedByNavigator = false;
  bool isAutoSizeForNavigator = true;
  String? wrappedNavigatorInitialName;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// holder object for various uses if you need ...
  Object? obj;

  /// Important!!! Navigator operation requested with a context that does include a Navigator.
  static void init(BuildContext context) {
    if (gContext == context) {
      return;
    }
    gContext = context;

    /// Important:
    /// Make sure that the given context has a [MediaQuery] ancestor.
    /// Make sure that the given context should under WidgetsApp/CupertinoApp/MaterialApp, those widgets introduce a MediaQuery
    assert(context.dependOnInheritedWidgetOfExactType<MediaQuery>() != null, '');
    assert(() {
      __shower_log__('[init] current context size: ${MediaQuery.of(context).size}');
      return true;
    }());

    Navigator? navigator;
    if (context is Element && context.widget is Navigator) {
      navigator = context.widget as Navigator;
      assert(() {
        __shower_log__('[init] current context already with a navigator >>> $navigator');
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
        __shower_log__('[init] found another navigator from ancestor >>> $anotherNavigator');
        return true;
      }());
      navigator = anotherNavigator;
    }
    RenderObject? naviRenderObject = naviContext?.findRenderObject();
    assert(() {
      __shower_log__('[init] naviState >>> $naviState, naviContext >>> $naviContext, naviWidget >>> $naviWidget, '
          'navigator >>> $navigator, naviRenderObject >>> $naviRenderObject');
      return true;
    }());

    if (navigator?.observers.contains(DialogShower.getObserver()) ?? false) {
      assert(() {
        __shower_log__('[init] already register observer in navigator!!!!');
        return true;
      }());
      NavigatorObserverEx.ensureInit();
    }
  }

  static NavigatorObserverEx getObserver() {
    gObserver ??= NavigatorObserverEx();
    return gObserver!;
  }

  DialogShower() : context = gContext;

  DialogShower show(Widget _child, {double? width, double? height}) {
    if (routeName.isEmpty) {
      routeName = 'SHOWER-${DateTime.now().microsecondsSinceEpoch}';
      if (NavigatorObserverEx.statesChangingShowers?[routeName] != null) {
        // check it out please !!!!
        assert(() {
          __shower_log__('❗️ observer already contains this route name: $routeName ???');
          return true;
        }());
        routeName = routeName + '-${1000 + math.Random().nextInt(10000)}';
      }
    }
    NavigatorObserverEx.statesChangingShowers?[routeName] = this;
    isSyncShow
        ? _show(_child, width: width, height: height)
        : Future.microtask(() => _show(_child, width: width, height: height));
    return this;
  }

  DialogShower _show(Widget _child, {double? width, double? height}) {
    this.width = width ?? this.width;
    this.height = height ?? this.height;
    _showInternal(_child);
    return this;
  }

  Future<void> _showInternal(Widget _child) async {
    assert(() {
      __shower_log__('>>>>>>>>>>>>>> showing: $routeName');
      return true;
    }());

    RouteSettings routeSettings = RouteSettings(name: routeName, arguments: null);

    route = RawDialogRoute(
      settings: routeSettings,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionBuilder: transitionBuilder,
      transitionDuration: transitionDuration,
      barrierDismissible: barrierDismissible ?? false,
      pageBuilder: (BuildContext ctx, Animation<double> first, Animation<double> second) => _getInternalWidget(_child),
    );
    _future = _rawPush(route);

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
      name: routeName,
      init: (state) {
        _isShowing = true;
        // invoke show callbacks
        _invokeShowCallbacks();

        // keyboard visibility
        if (keyboardEventCallBack != null) {
          _keyboardStreamSubscription?.cancel();
          _keyboardStreamSubscription = KeyboardEventListener.listen((isKeyboardShow) {
            keyboardEventCallBack?.call(this, isKeyboardShow);
          });
        }
      },
      dispose: (state) {
        _isShowing = false;
        NavigatorObserverEx.statesChangingShowers?.remove(routeName);
        assert(() {
          AnyDebouncer.get(runtimeType.toString()).call(() {
            __shower_log__('Now the statistics of showers in cache: ${NavigatorObserverEx.statesChangingShowers}');
          });
          return true;
        }());

        // invoke dispose callbacks
        _invokeDisposeCallbacks();

        // keyboard visibility
        _keyboardStreamSubscription?.cancel();
        _keyboardStreamSubscription = null;
      },
      builder: (state) {
        isBuilt ? null : _setIsBuilt = true;
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
              __shower_log__(
                  'Checking onTap details, keyboard is ${DialogShower.isKeyboardShowing() ? '' : 'not'} showing');
              return true;
            }());

            if (_tapUpDetails != null) {
              RenderBox? box = _containerKey.currentContext?.findRenderObject() as RenderBox?;
              if (box == null) {
                return;
              }
              RenderBox containerBox = box;
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
                __shower_log__('HitTest: $routeName, Container [$x1, $y1], [$x2, $y2]. Tap [$tapX, $tapY]. '
                    'isTapInside X$isTapInsideX && Y$isTapInsideY = $isTapInside, '
                    'barrierDismissible: $barrierDismissible, activing: ${route.isActive}');
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
                  __shower_log__(
                      'Dismiss keyboard, if u dislike this default behaviour, set isDismissKeyboardOnTapped = false');
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
                      __shower_log__(
                          'Dismiss keyboard, if u dislike this default behaviour, do not set barrierDismissible = null');
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
            body: scaffoldBodyBuilder?.call(this) ?? getScaffoldBody(_child),
          ),
        );
      },
    );
  }

  Widget getScaffoldBody(Widget _child) {
    /// we will rebuild using the statefulKey
    GlobalKey mKey = _statefulKey;
    if (isWithTicker) {
      return BuilderWithTicker(key: mKey, builder: (state) => _getScaffoldContainer(_child));
    } else {
      return StatefulBuilder(key: mKey, builder: (context, setState) => _getScaffoldContainer(_child));
    }
  }

  Widget _getScaffoldContainer(Widget _child) {
    /// ---------------------------- calculate _padding, _width, _height ----------------------------
    double? _width = width ?? renderedWidth;
    double? _height = height ?? renderedHeight;

    ui.SingletonFlutterWindow _window = Boxes.getWindow();

    MediaQueryData windowQuery = MediaQueryData.fromWindow(_window);
    double windowWidth = windowQuery.size.width;
    double windowHeight = windowQuery.size.height;

    assert(() {
      MediaQueryData contextQuery = MediaQuery.of(context!);
      double contextWidth = contextQuery.size.width;
      double contextHeight = contextQuery.size.height;

      double physicalWidth = _window.physicalSize.width;
      double physicalHeight = _window.physicalSize.height;
      double physicalTop = _window.padding.top;
      EdgeInsets contextPadding = contextQuery.padding;
      EdgeInsets windowPadding = windowQuery.padding;
      __shower_log__('Self: $routeName, _width: $_width, _height: $_height');
      __shower_log__(
          'Window: physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, physicalTop: $physicalTop');
      __shower_log__(
          'Self Size: width: $width, height: $height, renderedWidth: $renderedWidth, renderedHeight: $renderedHeight');
      __shower_log__(
          'QueryWindow: width: $windowWidth, height: $windowHeight, top: ${windowPadding.top}, padding: $windowPadding');
      __shower_log__(
          'QueryContext: width: $contextWidth, height: $contextHeight, top: ${contextPadding.top}, padding: $contextPadding');
      return true;
    }());

    // We use a Padding outside for handle vertically center instead of Container Alignment.Center
    // Cause when keyboard comes out once child get focus, will make the child stick to the top of the container.

    EdgeInsets? _padding;

    // when the Scaffold's body is Padding instead of Container (or Container without height & alignment) ,
    // you should calculate the top padding ,
    // if you do not use a calculated value as padding top (when use the alignment or set height for align center child),
    // it child will stick to screen top when keyboard show up !!!

    if (padding != null) {
      EdgeInsets m = padding!;
      if (m.top < 0 || m.left < 0) {
        if (_width == null || _height == null) {
          // _tryToGetContainerSize(); // replace with _tryToGetSizeOrNot now
          _isTryToGetSmallestSize = true;
        }

        // [Center Vertically] if height is given when padding not given or top is negative
        // [Center Horizontal] if width is given when padding not given left top is negative
        double centerLeft = 0;
        double centerTop = 0;
        if (_width != null) {
          double screenWidth = windowWidth; // contextWidth < _width ? windowWidth : contextWidth;
          centerLeft = math.max(0, (screenWidth - _width)) / 2;
        }
        if (_height != null) {
          double screenHeight = windowHeight; // contextHeight < _height ? windowHeight : contextHeight;
          centerTop = math.max(0, (screenHeight - _height)) / 2;
        }
        _padding =
            EdgeInsets.fromLTRB(m.left < 0 ? centerLeft : m.left, m.top < 0 ? centerTop : m.top, m.right, m.bottom);
      } else {
        _padding = m;
      }
    }

    assert(() {
      __shower_log__('_padding: $_padding, alignment: $alignment');
      return true;
    }());

    /// ---------------------------- calculate _padding, _width, _height ----------------------------

    Widget smallestContainer = _getSmallestContainer(_child, _width, _height);
    if (alignment == null) {
      return _padding != null ? Padding(padding: _padding, child: smallestContainer) : smallestContainer;
    } else {
      return Container(margin: margin, padding: _padding, alignment: alignment, child: smallestContainer);
    }
  }

  bool _isTryToGetSmallestSize = false;

  Widget _getSmallestContainer(Widget child, double? width, double? height) {
    Widget widget = child;
    if (isWrappedByNavigator && isAutoSizeForNavigator && (width == null || height == null)) {
      __shower_log__(
          '[GetSizeWidget] try to get size, casue navigator will lead to max stretch of container child ...');
      _isTryToGetSmallestSize = true;
    }

    if (_isTryToGetSmallestSize && (width == null || height == null)) {
      __shower_log__('[GetSizeWidget] try for getting size now ...');
      widget = GetSizeWidget(
        onLayoutChanged: (box, legacy, size) {
          __shower_log__('[GetSizeWidget] onSizeChanged was called >>>>>>>>>>>>> size: $size');
          _setRenderedSizeWithSetState(size);
        },
        child: child,
      );
    } else if (isWrappedByNavigator) {
      __shower_log__('show with navigator');
      _navigatorKey = GlobalKey<NavigatorState>();
      widget = Navigator(
        key: _navigatorKey,
        initialRoute: wrappedNavigatorInitialName,
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
              return child;
            },
          );
        },
      );
    }

    /// Cause add Clip.antiAlias, the radius will not cover by child, u need to set Clip.none if u paint shadow by your self
    Decoration? decoration =
        containerDecoration == _notInitializedDecoration ? _defContainerDecoration() : containerDecoration;
    Clip clipBehavior = decoration == null ? Clip.none : containerClipBehavior;

    // the container as mini as possible for calculate the point if tapped inside
    return Container(
      key: _containerKey,
      width: width,
      height: height,
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: _rawChild(widget),
    );
  }

  /// setState ----------------------------------------

  Widget? newChild;

  Widget Function(DialogShower shower)? builder;

  void setNewChild(Widget? child) {
    newChild = child;
    setState();
  }

  void setBuilder(Widget Function(DialogShower shower)? _builder) {
    builder = _builder;
    setState();
  }

  Widget _rawChild(Widget? child) {
    return builder?.call(this) ?? newChild ?? child ?? const Offstage(offstage: true);
  }

  /// dismiss ----------------------------------------

  bool _isDismiss = false;

  Future<void> dismiss<T extends Object?>([T? result]) async {
    if (_isDismiss) {
      return;
    }
    _isDismiss = true;

    if (isPopped) {
      assert(() {
        __shower_log__('❗️❗️❗️ $routeName dismissed ??? already popped by using the most primitive pop/remove ???');
        return true;
      }());
    } else {
      assert(() {
        __shower_log__('>>>>>>>>>>>>>> dismiss popping: $routeName');
        return true;
      }());
      isSyncDismiss ? _rawDismiss<T>(result) : Future.microtask(() => _rawDismiss<T>(result));
      if (NavigatorObserverEx.statesChangingShowers?[routeName] == null) {
        isPopped = true;
      }
      _invokeDismissCallbacks();
      await poppedCompleter.future;
      assert(() {
        __shower_log__('>>>>>>>>>>>>>> dismiss popped done: $routeName');
        return true;
      }());
    }
  }

  Future<void> remove<T extends Object?>({bool? isAnimated, T? result}) {
    /// 1. if a result provided, will have pop animation
    if (isAnimated == true || result != null) {
      Completer completer = Completer();
      route.didPop(result);
      route.animation?.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _rawRemove(route);
          completer.complete();
          // remove this statusListener or not ? now i leave it alone ...
        }
      });
      return completer.future;
    }

    /// 2. just remove it without animation
    _rawRemove(route);
    return poppedCompleter.future;
  }

  /// pop/push/remove will caused NavigatorObserver.didPop/didPus/didRemove method call immediately sync in the same event loop
  Future<dynamic> _rawPush(Route route) => parentNavigator.push(route);

  void _rawDismiss<T extends Object?>([T? result]) => parentNavigator.pop<T>(result);

  void _rawRemove(Route<dynamic> route) => parentNavigator.removeRoute(route);

  /// For nested navigator
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
    Duration? duration = const Duration(milliseconds: 300),
    Duration? reverseDuration = const Duration(milliseconds: 300),
    bool? opaque = true,
    bool? barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState = true,
    bool? fullscreenDialog = false,
  }) {
    transition = transition ?? transitionBuilder ?? ShowerTransitionBuilder.slideFromBottom;
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

  void setState([VoidCallback? fn]) async {
    assert(() {
      __shower_log__('Rebuilding... setState was called.');
      return true;
    }());
    if (!isBuilt) {
      await builtCompleter.future;
    }
    fn?.call();
    StatefulElement? element = _statefulKey.currentContext as StatefulElement?;
    if (element == null) {
      assert(() {
        __shower_log__('[DialogShower] ❌ Do not call setState called during build or disposed!');
        return true;
      }());
      return;
    }
    element.markNeedsBuild();
    // _builderExKey.currentState?.setState(fn);
    // _statefulKey.currentState?.setState(fn);
  }

  /// Private methods

  Decoration _defContainerDecoration() {
    return BoxDecoration(
      color: containerBackgroundColor,
      borderRadius: BorderRadius.circular(containerBorderRadius),
      boxShadow: containerBoxShadow ??
          [
            BoxShadow(
              color: containerShadowColor,
              blurRadius: containerShadowBlurRadius,
            ),
          ],
    );
  }

  void _setRenderedSizeWithSetState(Size? size) {
    renderedWidth = size?.width;
    renderedHeight = size?.height;
    if (renderedWidth != null && renderedHeight != null) {
      setState();
    }
  }

  /// Other Utils Methods

  /// Note: you should DialogShower.init(context) first ~~~
  static bool isKeyboardShowing() {
    assert(gContext != null, 'Should call DialogShower.init first in your runApp context');
    return MediaQuery.of(gContext!).viewInsets.bottom > 0;
  }
}

/**
 *
 * Classes Below
 *
 **/

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
      __shower_log__('[Observer] didPush: ${route.settings.name} ,    [pre: ${previousRoute?.settings.name}]');
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
      __shower_log__('[Observer] didPop: ${route.settings.name} ,    [pre: ${previousRoute?.settings.name}]');
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
      __shower_log__('[Observer] didRemove: ${route.settings.name} ,    [pre: ${previousRoute?.settings.name}]');
      return true;
    }());
    if (route.settings.name != null) {
      statesChangingShowers?[route.settings.name]?.isPopped = true;
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    assert(() {
      __shower_log__('[Observer] didReplace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
      return true;
    }());
  }
}

/// Transition builder
class ShowerTransitionBuilder {
  static RouteTransitionsBuilder slideFromTop = slideTransitionBuilder(const Offset(0.0, -1.0));
  static RouteTransitionsBuilder slideFromBottom = slideTransitionBuilder(const Offset(0.0, 1.0));
  static RouteTransitionsBuilder slideFromLeft = slideTransitionBuilder(const Offset(-1.0, 0.0));
  static RouteTransitionsBuilder slideFromRight = slideTransitionBuilder(const Offset(1.0, 0.0));

  static RouteTransitionsBuilder slideTransitionBuilder(Offset? beginOffset) {
    return (BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child) {
      return SlideTransition(
          child: child, position: Tween<Offset>(begin: beginOffset, end: const Offset(0.0, 0.0)).animate(animOne));
    };
  }

  static RouteTransitionsBuilder fadeIn = commonTransitionBuilder(builder: (child, animation) {
    return FadeTransition(child: child, opacity: Tween(begin: 0.0, end: 1.0).animate(animation));
  });

  static RouteTransitionsBuilder scaleIn = commonTransitionBuilder(builder: (child, animation) {
    return ScaleTransition(child: child, scale: Tween(begin: 0.0, end: 1.0).animate(animation));
  });

  static RouteTransitionsBuilder commonTransitionBuilder(
      {required Widget Function(Widget child, Animation<double> animation) builder}) {
    return (BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child) {
      return builder(child, animOne);
    };
  }
}

typedef ShowerVisibilityCallBack = void Function(DialogShower shower);
typedef KeyboardVisibilityCallBack = void Function(DialogShower shower, bool isKeyboardShow);

bool shower_log_enable = true;

__shower_log__(String log) {
  assert(() {
    if (shower_log_enable) {
      print('[DialogShower] $log');
    }
    return true;
  }());
}
