import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialogShower {
  static BuildContext? gContext;
  static NavigatorObserverEx? gObserver;

  // navigate
  BuildContext? context;
  bool isUseRootNavigator = true;
  Color barrierColor = Colors.transparent;
  bool barrierDismissible = true;
  String barrierLabel = "";
  Duration transitionDuration = const Duration(milliseconds: 250);
  RouteTransitionsBuilder? transitionBuilder;

  // scaffold
  Color? scaffoldBackgroundColor = Colors.transparent;

  // Important!!! Either-Or situation !!!
  TextDirection? textDirection;
  AlignmentGeometry? alignment = Alignment.topCenter;

  // container
  EdgeInsets? margin;
  Color containerBackgroundColor = Colors.white;
  List<BoxShadow>? containerBoxShadow;
  Color containerShadowColor = Colors.transparent;
  double containerShadowBlurRadius = 0.0;
  double? width;
  double? height;

  double containerBorderRadius = 0.0;
  Decoration? containerDecoration;
  Clip containerClipBehavior = Clip.antiAlias;

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

  // GlobalKey _builderKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();

  // extension for navigate inner dialog
  bool isWrappedByNavigator = false;
  GlobalKey<NavigatorState>? _navigatorKey;

  static void init(BuildContext context) {
    if (gContext == context) {
      return;
    }
    gContext = context;

    /// Try to get app instance back here ....
    NavigatorState? rootState = context.findRootAncestorStateOfType<NavigatorState>();
    BuildContext? rootContext = rootState?.context;
    Widget? rootWidget = rootContext?.widget;
    Navigator? navigator = rootWidget != null ? rootWidget as Navigator : null;
    RenderObject? rootRenderObject = rootContext?.findRenderObject();
    if (navigator?.observers.contains(DialogShower.getObserver()) ?? false) {
      assert(() {
        __log_print__('already register observer in navigator!!!!');
        return true;
      }());
      NavigatorObserverEx.init();
    }
    assert(() {
      __log_print__('rootContext >>> $rootContext, rootState >>> $rootState,'
          ' widget >>> $rootWidget, navigator >>> $navigator,'
          ' rootRenderObject >>> $rootRenderObject');
      return true;
    }());
  }

  static NavigatorObserverEx getObserver() {
    gObserver ??= NavigatorObserverEx();
    return gObserver!;
  }

  DialogShower() {
    transitionBuilder = _transition;
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
    double? _width = width ?? this.width;
    double? _height = height ?? this.height;

    ui.SingletonFlutterWindow _window = WidgetsBinding.instance?.window ?? ui.window;
    double mWidth = _window.physicalSize.width;
    double mHeight = _window.physicalSize.height;

    MediaQueryData query = MediaQueryData.fromWindow(_window);
    Size querySize = query.size;
    MediaQueryData queryData = MediaQuery.of(context!);
    double kWidth = queryData.size.width;
    double kHeight = queryData.size.height;

    assert(() {
      __log_print__('self: _width: $_width, _height: $_height; Media.Window width: ${querySize.width}, height: ${querySize.height}');
      __log_print__('ui.window: mWidth: $mWidth, mHeight: $mHeight; MediaQueryData kWidth: $kWidth, kHeight: $kHeight');
      return true;
    }());

    // We use a Padding outside for handle vertically center instead of Container Alignment.Center, cause when keyboard comes out once child get focus,
    // will make the child stick to the top of the container.

    EdgeInsets _margin = EdgeInsets.zero;

    // padding as margin
    // when the Scaffold's body is Padding instead of Container (or Container without height & alignment) , you should calculate the top padding
    // if you do not use a calculated value as padding top (when use the alignment or set height for align center chile), it child will stick to screen top when keyboard show up !!!
    double defMarginTop =
        _height != null ? (kHeight - _height) / 2 : 0; // [Center Vertically] if height is given but margin not given or top is negative
    if (margin != null) {
      EdgeInsets m = margin!;
      if (m.top < 0) {
        _margin = EdgeInsets.fromLTRB(m.left, defMarginTop, m.right, m.bottom);
      } else {
        _margin = m;
      }
    } else {
      _margin = EdgeInsets.only(top: defMarginTop);
    }

    assert(() {
      __log_print__('_margin: ${_margin}');
      return true;
    }());

    _showInternal(_child, _margin, _width, _height);
    return this;
  }

  Future<void> _showInternal(Widget _child, EdgeInsets _margin, double? _width, double? _height) async {
    _isShowing = true;

    assert(() {
      __log_print__('>>>>>>>>>>>>>> showing: $routeName');
      return true;
    }());

    _future = showGeneralDialog(
      context: context!,
      useRootNavigator: isUseRootNavigator,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      routeSettings: RouteSettings(
        name: routeName,
      ),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return _getInternalWidget(_child, _margin, _width, _height);
      },
    );

    assert(() {
      __log_print__('>>>>>>>>>>>>>> showed: $routeName');
      return true;
    }());
    return future;
  }

  Widget _getInternalWidget(Widget _child, EdgeInsets _margin, double? _width, double? _height) {
    return BuilderEx(
      // return Builder(
      // key: _builderKey,
      showCallBack: () {
        showCallBack?.call(this);
        for (int i = 0; i < (showCallbacks?.length ?? 0); i++) {
          showCallbacks?.elementAt(i).call(this);
        }
      },
      dismissCallBack: () {
        dismissCallBack?.call(this);
        for (int i = 0; i < (dismissCallbacks?.length ?? 0); i++) {
          dismissCallbacks?.elementAt(i).call(this);
        }
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
              __log_print__('Click found, keyboard is ${isKeyboardShowed ? '' : 'not'} showing');
              return true;
            }());

            if (_tapUpDetails != null) {
              RenderBox renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox;
              double w = renderBox.size.width;
              double h = renderBox.size.height;
              Offset p = renderBox.localToGlobal(Offset.zero);
              double x = p.dx;
              double y = p.dy;

              Offset point = _tapUpDetails!.globalPosition;
              double dx = point.dx;
              double dy = point.dy;
              bool isTapInsideX = x < dx && dx < (x + w);
              bool isTapInsideY = y < dy && dy < (y + h);
              bool isTapInside = isTapInsideX && isTapInsideY;

              assert(() {
                __log_print__('HitTest: $p, ${renderBox.size}, $point, X$isTapInsideX && Y$isTapInsideY = $isTapInside,'
                    ' barrierDismissible: $barrierDismissible, isShowing: $isShowing');
                return true;
              }());

              bool v = wholeOnTapCallback?.call(this, point) ?? false;
              if (v) {
                return;
              }

              if (isKeyboardShowed) {
                // https://github.com/flutter/flutter/issues/48464
                FocusManager.instance.primaryFocus?.unfocus();
                // FocusScope.of(context).requestFocus(FocusNode());
              }

              if (isTapInside) {
                bool v = dialogOnTapCallback?.call(this, point) ?? false;
              } else {
                bool v = barrierOnTapCallback?.call(this, point) ?? false;
                if (v) {
                  return;
                }
                if (barrierDismissible) {
                  // wait for keyboard dismiss done the dismiss dialog
                  if (isKeyboardShowed && !(_isAlignCenterHorizontal() && transitionBuilder == _transition)) {
                    Future.delayed(const Duration(milliseconds: 250), () {
                      dismiss();
                    });
                  } else {
                    dismiss();
                  }
                }
              }
            }
          },
          child: Scaffold(
            backgroundColor: scaffoldBackgroundColor,
            appBar: null,
            body:
                // Container(
                // color: Colors.red,
                // alignment: Alignment.center,  // when set alignment, content center & width height just like android's match_parent
                // padding: _margin,          // use Container padding instead of Padding with padding attr as child, it child(Row now) will stick to screen top!!!
                // child:
                Padding(
              padding: _margin,
              child: _isAlignCenterHorizontal()
                  ? Container(
                      // color: Colors.red,
                      alignment: alignment,
                      child: _getContainer(_child, _width, _height),
                    )
                  : Row(
                      textDirection: textDirection,
                      children: [
                        _getContainer(_child, _width, _height),
                      ],
                    ),
            ),
          ),
          // ),
        );
      },
    );
  }

  Future<void> dismiss() async {
    if (_isShowing) {
      _isShowing = false;
      Future.microtask(() {
        assert(() {
          __log_print__('>>>>>>>>>>>>>> popping: $routeName');
          return true;
        }());
        Navigator.of(context!, rootNavigator: isUseRootNavigator).pop();
      });

      /// ISSUE: Failed assertion: line 4595 pos 12: '!_debugLocked': is not true.
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
    transition = transition ?? _transition;
    pageBuilder = pageBuilder ?? (ctx, animOne, animTwo) => widget;
    routeBuilder = routeBuilder ??
        PageRouteBuilder<T>(
          pageBuilder: pageBuilder,
          transitionsBuilder: transition,
          settings: settings,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          opaque: opaque,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
    return getNavigator()!.push<T>(routeBuilder);
  }

  void pop<T>({T? result}) {
    getNavigator()?.pop<T>(result);
  }

  /*
  /// self defined setState
  void setState(VoidCallback fn) {
    assert((){
      __log_print__('rebuilding...');
      return true;
    }());
    _builderKey.currentState?.setState(fn);
  }
  */

  /// Private methods
  bool _isAlignCenterHorizontal() {
    return textDirection == null;
  }

  Widget _transition(BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child) {
    return _transitionRaw(ctx, animOne, animTwo, child, textDirection);
  }

  Widget _transitionRaw(BuildContext ctx, Animation<double> animOne, Animation<double> animTwo, Widget child, TextDirection? direction) {
    // Bottom to Up, Right to Left, Left to Right
    Offset offset =
        direction == null ? const Offset(0.0, 1.0) : (direction == TextDirection.rtl ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0));
    return SlideTransition(
      position: Tween<Offset>(
        begin: offset,
        end: const Offset(0.0, 0.0),
      ).animate(animOne),
      child: child,
    );
  }

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
    return Container(
      key: _containerKey,
      width: width,
      height: height,
      // cause add Clip.antiAlias, the radius will not cover by child, u need to set Clip.none if u paint shadow by your self
      clipBehavior: containerClipBehavior,
      decoration: containerDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(containerBorderRadius),
            // color: Colors.yellow,
            color: containerBackgroundColor,
            boxShadow: containerBoxShadow ??
                [
                  BoxShadow(
                    color: containerShadowColor,
                    blurRadius: containerShadowBlurRadius,
                  ),
                ],
          ),
      child: widget, //child,
    );
  }

  /// Other Utils Methods
  // Note: you should DialogShower.init(context) first ~~~
  static bool isKeyboardShowing() {
    double viewInsetsBottom = MediaQuery.of(DialogShower.gContext!).viewInsets.bottom;
    return viewInsetsBottom > 0;
  }
}

/// For setSate & callback
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
  Widget build(BuildContext context) {
    try {
      widget.showCallBack?.call();
    } catch (e) {
      assert(() {
        __log_print__(e.toString());
        return true;
      }());
    }
    return widget.builder(context);
  }

  @override
  void dispose() {
    try {
      widget.dismissCallBack?.call();
    } catch (e) {
      assert(() {
        __log_print__(e.toString());
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

  static init() {
    statesChangingShowers = statesChangingShowers ?? {};
  }

  NavigatorObserverEx() : super();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
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

__log_print__(String log) {
  assert(() {
    print('[DialogShower] $log');
    return true;
  }());
}

typedef ShowerVisibilityCallBack = void Function(DialogShower shower);
