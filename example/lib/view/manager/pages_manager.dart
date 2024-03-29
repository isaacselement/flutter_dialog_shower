// ignore_for_file: must_be_immutable

import 'package:example/util/logger.dart';
import 'package:example/view/page_of_basic.dart';
import 'package:example/view/page_of_brother.dart';
import 'package:example/view/page_of_bubble.dart';
import 'package:example/view/page_of_homeless.dart';
import 'package:example/view/page_of_keyboard.dart';
import 'package:example/view/page_of_navigator.dart';
import 'package:example/view/page_of_overlay.dart';
import 'package:example/view/page_of_tester.dart';
import 'package:example/view/page_of_widigets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PagesManager {
  static void initPages() {
    if (tabsPages.isNotEmpty) {
      return;
    }
    // addTabPage(
    //   true,
    //   'Home',
    //   const Icon(Icons.home_outlined, size: 32, color: Colors.black26),
    //   const Icon(Icons.home, size: 32, color: Colors.orange),
    //   const PageOfHome(),
    // );
    addTabPage(
      true,
      'Basic',
      const Icon(Icons.sports_football, size: 32, color: Colors.black26),
      const Icon(Icons.sports_football_sharp, size: 32, color: Colors.orange),
      const PageOfBasic(),
    );
    addTabPage(
      false,
      'Widgets',
      const Icon(Icons.widgets, size: 32, color: Colors.black26),
      const Icon(Icons.widgets_sharp, size: 32, color: Colors.orange),
      const PageOfWidgets(),
    );
    addTabPage(
      false,
      'Keyboard',
      const Icon(Icons.keyboard, size: 32, color: Colors.black26),
      const Icon(Icons.keyboard_sharp, size: 32, color: Colors.orange),
      const PageOfKeyboard(),
    );
    addTabPage(
      false,
      'Bubble',
      const Icon(Icons.bubble_chart, size: 32, color: Colors.black26),
      const Icon(Icons.bubble_chart_sharp, size: 32, color: Colors.orange),
      const PageOfBubble(),
    );
    addTabPage(
      false,
      'Navigator',
      const Icon(Icons.navigation, size: 32, color: Colors.black26),
      const Icon(Icons.navigation_sharp, size: 32, color: Colors.orange),
      PageOfNavigator(),
    );
    addTabPage(
      false,
      'Overlay',
      const Icon(Icons.auto_awesome_motion, size: 32, color: Colors.black26),
      const Icon(Icons.auto_awesome_motion, size: 32, color: Colors.orange),
      const PageOfOverlay(),
    );
    addTabPage(
      false,
      'Brother',
      const Icon(Icons.refresh, size: 32, color: Colors.black26),
      const Icon(Icons.refresh_sharp, size: 32, color: Colors.orange),
      const PageOfBrother(),
    );
    addTabPage(
      false,
      'Homeless',
      const Icon(Icons.attachment, size: 32, color: Colors.black26),
      const Icon(Icons.attachment_sharp, size: 32, color: Colors.orange),
      const PageOfHomeless(),
    );
    addTabPage(
      false,
      'Smoke Test',
      const Icon(Icons.directions_bike, size: 32, color: Colors.black26),
      const Icon(Icons.directions_bike_sharp, size: 32, color: Colors.orange),
      PageOfTester(),
    );
  }

  static void initPageController() {
    if (!Broker.contains<PageController>()) {
      Broker.setIfAbsent<PageController>(PageController());
      PageController pageController = getPageController()!;
      pageController.addListener(() {
        Logger.d('PagesManager jump to page:  ${pageController.page}');
      });
    }
  }

  static PageController? getPageController() {
    return Broker.get<PageController>();
  }

  /// tabs & pages

  static Map<String, TabPageInstance> tabsPages = {};

  static Btv<int> currentPageIndex = 0.btv;

  static void addTabPage(bool isKeepAlive, String name, Widget tabIcon, Widget tabIconSelected, Widget page) {
    TabPageInstance inst;
    inst = TabPageInstance(name: name, isKeepAlive: isKeepAlive);
    add(inst);
    inst.pageBuilder = (inst) {
      return inst.isKeepAlive
          ? KeepAlivePageWidget(builder: (ctx, setState) {
              Logger.d('PagesManager >>>>>>>>>>>>> KeepAlivePageWidget rebuild: $name');
              return page;
            })
          : StatefulBuilder(builder: (ctx, setState) {
              Logger.d('PagesManager >>>>>>>>>>>>> StatefulBuilder rebuild: $name');
              return page;
            });
    };
    inst.tabBuilder = (inst) {
      bool isSelected = currentPageIndex.value == inst.ordinal;
      Color textColor = isSelected ? (inst.isKeepAlive ? Colors.red : Colors.orangeAccent) : Colors.grey;
      return CupertinoButton(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
        child: Column(
          children: [
            isSelected ? tabIconSelected : tabIcon,
            const SizedBox(height: 2.0),
            Text(name, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w300)),
          ],
        ),
        onPressed: () {
          currentPageIndex.value = inst.ordinal;
          Broker.get<PageController>().jumpToPage(inst.ordinal);
        },
      );
    };
  }

  static void add(TabPageInstance inst) {
    inst.ordinal = tabsPages.length;
    set(inst);
  }

  static void set(TabPageInstance inst) {
    tabsPages[inst.name] = inst;
  }

  static TabPageInstance? getByOrdinal(int ordinal) {
    List<String> list = tabsPages.keys.toList();
    for (int i = 0; i < list.length; i++) {
      TabPageInstance? b = tabsPages[list[i]];
      if (b?.ordinal == ordinal) {
        return b;
      }
    }
    return null;
  }

  static TabPageInstance? getByName(String name) {
    List<String> list = tabsPages.keys.toList();
    for (int i = 0; i < list.length; i++) {
      TabPageInstance? val = tabsPages[list[i]];
      if (val?.name == name) {
        return val;
      }
    }
    for (int i = 0; i < list.length; i++) {
      TabPageInstance? val = tabsPages[list[i]];
      if (val?.name.contains(name) ?? false) {
        return val;
      }
    }
    return null;
  }

  static List<TabPageInstance> _getSortedTabsPages() {
    List<TabPageInstance> list = [];
    tabsPages.forEach((key, val) {
      list.add(val);
    });
    list.sort((a, b) => a.ordinal.compareTo(b.ordinal));
    return list;
  }

  static List<Widget> getTabs() {
    return _getSortedTabsPages().map((e) => e.tabBuilder(e)).toList();
  }

  static List<Widget> getPages() {
    return _getSortedTabsPages().map((e) => e.pageBuilder(e)).toList();
  }
}

class TabPageInstance {
  String name;
  late int ordinal;
  late Widget Function(TabPageInstance inst) tabBuilder;
  late Widget Function(TabPageInstance inst) pageBuilder;

  bool isKeepAlive;

  TabPageInstance({required this.name, this.isKeepAlive = false});
}

class KeepAlivePageWidget extends StatefulWidget {
  Widget Function(BuildContext context, StateSetter setState) builder;

  KeepAlivePageWidget({Key? key, required this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeepAlivePageWidgetState();
}

class _KeepAlivePageWidgetState extends State<KeepAlivePageWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(context, setState);
  }
}
