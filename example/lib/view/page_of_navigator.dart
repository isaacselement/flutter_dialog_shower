import 'dart:convert';

import 'package:example/util/header_util.dart';
import 'package:example/util/logger.dart';
import 'package:example/util/toast_util.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/widget/xp_slider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfNavigator extends StatelessWidget {
  PageOfNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfNavigator] ----------->>>>>>>>>>>> build/rebuild!!!");

    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
            return buildBody();
          },
        );
      },
    );
  }

  Widget buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildGlobalContextMenus(),
                const SizedBox(height: 8),
                buildInnerContextMenus(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Row(
            children: [
              Container(width: 1, color: Colors.black),
              Expanded(child: buildInnerNavigator()),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGlobalContextMenus() {
    return Column(
      children: [
        WidgetsUtil.newHeaderWithGradient('Navigator global context shower'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show with navigator with Width & Height', onPressed: (state) {
              DialogWrapper.pushRoot(
                getScrollView(),
                width: SizesUtils.screenWidth / 3 * 2,
                height: SizesUtils.screenHeight / 3 * 2,
              );
            }),
            WidgetsUtil.newXpelTextButton('Show with navigator Auto size (Depends on child\'s width & height)', onPressed: (state) {
              DialogWrapper.pushRoot(
                SizedBox(
                  child: getScrollView(),
                ),
              );
            }),
            WidgetsUtil.newXpelTextButton('Show a list with nested navigator', onPressed: (state) async {
              Widget widget = getListWidget(
                  value: json.decode(await rootBundle.loadString('assets/json/CN.json')),
                  onHeaderOptions: (options) {
                    options.leftWidget = null;
                    return null;
                  },
                  onTappedLeaf: (depth, value) {
                    DialogWrapper.dismissTopDialog();
                    ToastUtil.show('You select: $value');
                    return true;
                  });
              DialogShower shower = DialogWrapper.pushRoot(widget);
              // shower.transitionBuilder = (c, a1, a2, w) => FadeTransition(child: w, opacity: Tween(begin: 0.0, end: 1.0).animate(a1));
              // shower.transitionBuilder = (c, a1, a2, w) => ScaleTransition(child: w, scale: Tween(begin: 0.0, end: 1.0).animate(a1));
              shower.transitionBuilder = (c, a1, a2, w) => SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(a1),
                    child: w,
                  );
            }),
            WidgetsUtil.newXpelTextButton('Bubbles & pickers demonstrations in Dialog', onPressed: (state) {
              double screenWidth = SizesUtils.screenWidth;
              double width = screenWidth > 600 ? screenWidth / 4 * 2 : screenWidth;
              DialogShower shower = DialogWrapper.showRight(XpSliderWidget(), width: width);
              shower.isWithTicker = true;
              shower.padding = const EdgeInsets.only(right: 0);
              shower
                ..containerBoxShadow = []
                ..containerBorderRadius = 8.0
                ..barrierColor = const Color(0x4D1C1D21)
                ..dismissCallBack = (shower) {};
            }),
          ],
        ),
      ],
    );
  }

  Widget buildInnerContextMenus() {
    return Column(
      children: [
        WidgetsUtil.newHeaderWithGradient('Navigator inner shower'),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show Center in inner navigator', onPressed: (state) {
              DialogShower shower = DialogWrapper.showCenter(const ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: 200,
                  height: 200,
                ),
              ));
              shower.context = innerNavigatorKey.currentContext;
              shower.isUseRootNavigator = false;
            }),
            WidgetsUtil.newXpelTextButton('Show Center in inner navigator', onPressed: (state) {
              DialogShower shower = DialogWrapper.showCenter(const ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: TextField(),
                ),
              ));
              BuildContext? context = innerNavigatorKey.currentContext;
              shower.scaffoldBodyBuilder = (DialogShower shower) {
                Size? size = ElementsUtils.getSize(context);
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: size?.width,
                    height: size?.height,
                    // color: Colors.amberAccent,
                    alignment: Alignment.center,
                    child: shower.getScaffoldBody(
                      const ColoredBox(
                        color: Colors.white,
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: TextField(),
                        ),
                      ),
                    ),
                  ),
                );
              };
            }),
            WidgetsUtil.newXpelTextButton('Show Center in inner navigator', onPressed: (state) {
              double kItemSide = 200;
              BuildContext? context = innerNavigatorKey.currentContext;
              Size size = ElementsUtils.getSize(context) as Size;
              Offset offset = ElementsUtils.getOffset(context) as Offset;
              double x = offset.dx + (size.width - kItemSide) / 2;
              double y = offset.dy + (size.height - kItemSide) / 2;
              DialogShower shower = DialogWrapper.show(
                ColoredBox(
                  color: Colors.white,
                  child: SizedBox(
                    width: kItemSide,
                    height: kItemSide,
                    child: const TextField(),
                  ),
                ),
                x: x,
                y: y,
              );
            }),
          ],
        ),
      ],
    );
  }

  final GlobalKey innerNavigatorKey = GlobalKey<NavigatorState>();

  Widget buildInnerNavigator() {
    return Navigator(
      key: innerNavigatorKey,
      initialRoute: 'content_navigator',
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
            return Container(
              color: Colors.grey.withAlpha(64),
              alignment: Alignment.center,
              child: const SizedBox(),
            );
          },
        );
      },
    );
  }

  /// Static Methods

  static SingleChildScrollView getScrollView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // as small as possible
        children: [
          CupertinoButton(
            child: const Text('Dismiss'),
            onPressed: () {
              DialogWrapper.dismissTopDialog();
            },
          ),
          const SizedBox(width: 380, height: 250),
          CupertinoButton(
            child: const Text('Push a new page'),
            onPressed: () {
              rootBundle.loadString('assets/json/CN.json').then((string) {
                List<dynamic> value = json.decode(string);
                DialogWrapper.push(getListWidget(value: value));
              });
            },
          ),
        ],
      ),
    );
  }

  static Widget getListWidget({
    required Object value,
    int depth = 0,
    AnythingHeaderOptions? Function(AnythingHeaderOptions options)? onHeaderOptions,
    AnythingSelectorOptions? Function(AnythingSelectorOptions options)? onSelectorOptions,
    bool? Function(int depth, Object value)? onTappedLeaf,
  }) {
    AnythingHeaderOptions headerOptions = HeaderUtil.headerOptions()
      ..leftWidget = const Icon(Icons.arrow_back_ios, size: 20, color: Colors.blueAccent)
      ..leftEvent = () => DialogWrapper.popOrDismiss();
    headerOptions = onHeaderOptions?.call(headerOptions) ?? headerOptions;

    AnythingSelectorOptions selectorOptions = AnythingSelectorOptions()
      ..itemSuffixWidget = const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
    selectorOptions = onSelectorOptions?.call(selectorOptions) ?? selectorOptions;

    Widget widget = AnythingSelector(
      isSearchEnable: true,
      header: (value is Map) ? value['areaName'] : 'Select City',
      values: ((value is Map ? value['children'] : value) as List<dynamic>).cast(),
      funcOfItemName: (s, i, e) => e is Map ? e['areaName'] : '',
      options: selectorOptions,
      headerOptions: headerOptions,
      funcOfItemOnTapped: (state, index, value) {
        if (value is! Map) {
          return false;
        }
        // leaf
        var children = value['children'];
        if (children == null || children!.isEmpty) {
          if (onTappedLeaf?.call(depth, value) ?? false) {
            return true;
          }
          while (depth-- >= 0) {
            DialogWrapper.pop();
          }
          return true;
        }
        // recursively call
        Widget nextPage = getListWidget(
          value: value,
          depth: ++depth,
          onHeaderOptions: onHeaderOptions,
          onSelectorOptions: onSelectorOptions,
          onTappedLeaf: onTappedLeaf,
        );
        DialogWrapper.push(nextPage, settings: RouteSettings(name: 'depth-->>$depth'));
        return true;
      },
    );
    return ColoredBox(color: Colors.white, child: widget);
  }
}
