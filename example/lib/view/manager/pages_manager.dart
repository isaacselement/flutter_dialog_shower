import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';

import '../../util/logger.dart';
import '../page_of_keyboard.dart';
import '../page_of_widigets.dart';

class PagesManager {
  static void init() {
    if (getPageController() == null) {
      Broker.setIfAbsent<PageController>(PageController());
      PageController pageController = getPageController()!;
      pageController.addListener(() {
        Logger.d('PagesManager jump to page:  ${pageController.page}');
      });
    }

    if (tabsPages.isEmpty) {
      addTabPage(true, 'Tab1', const Icon(Icons.keyboard, size: 32), PageOfKeyboard());
      addTabPage(false, 'Tab2', const Icon(Icons.event, size: 32), PageOfWidgets());
      addTabPage(false, 'Tab3', const Icon(Icons.security, size: 32), Container(color: Colors.white, alignment: Alignment.center));
    }
  }

  static PageController? getPageController() {
    return Broker.get<PageController>();
  }

  /// tabs & pages

  static Map<String, TabPageInstance> tabsPages = {};

  static void addTabPage(bool isKeepAlive, String name, Widget tab, Widget page) {
    TabPageInstance inst;
    inst = TabPageInstance(
      name: name,
      pageBuilder: () {
        return isKeepAlive
            ? KeepAlivePageWidget(builder: (ctx, setState) {
                Logger.d('PagesManager >>>>>>>>>>>>> KeepAlivePageWidget rebuild: $name');
                return page;
              })
            : StatefulBuilder(builder: (ctx, setState) {
                Logger.d('PagesManager >>>>>>>>>>>>> StatefulBuilder rebuild: $name');
                return page;
              });
      },
    );
    add(inst);
    inst.tabBuilder = () => CupertinoButton(
        child: tab,
        onPressed: () {
          Broker.get<PageController>()?.jumpToPage(inst.ordinal);
        });
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
    return _getSortedTabsPages().map((e) => e.tabBuilder()).toList();
  }

  static List<Widget> getPages() {
    return _getSortedTabsPages().map((e) => e.pageBuilder()).toList();
  }
}

class TabPageInstance {
  late int ordinal;
  String name;

  late Widget Function() tabBuilder;
  Widget Function() pageBuilder;

  TabPageInstance({required this.name, required this.pageBuilder});
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
