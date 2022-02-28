import 'package:example/view/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/broker.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';

import '../../util/logger.dart';
import '../page_of_basic.dart';
import '../page_of_homeless.dart';
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
      addTabPage(
        false,
        'Basic',
        const Icon(Icons.sports_football, size: 32, color: Colors.black26),
        const Icon(Icons.sports_football, size: 32, color: Colors.orange),
        PageOfBasic(),
      );
      addTabPage(
        true,
        'Keyboard',
        const Icon(Icons.keyboard, size: 32, color: Colors.black26),
        const Icon(Icons.keyboard, size: 32, color: Colors.orange),
        PageOfKeyboard(),
      );
      addTabPage(
        false,
        'Widgets',
        const Icon(Icons.widgets, size: 32, color: Colors.black26),
        const Icon(Icons.widgets, size: 32, color: Colors.orange),
        PageOfWidgets(),
      );
      addTabPage(
        false,
        'Homeless',
        const Icon(Icons.auto_awesome_motion, size: 32, color: Colors.black26),
        const Icon(Icons.auto_awesome_motion, size: 32, color: Colors.orange),
        PageOfHomeless(),
      );
    }
  }

  static PageController? getPageController() {
    return Broker.get<PageController>();
  }

  /// tabs & pages

  static Map<String, TabPageInstance> tabsPages = {};

  static Bt<int> currentPageIndex = 0.btw;

  static void addTabPage(bool isKeepAlive, String name, Widget tabIcon, Widget tabIconSelected, Widget page) {
    TabPageInstance inst;
    inst = TabPageInstance(name: name);
    add(inst);
    inst.pageBuilder = () {
      return isKeepAlive
          ? KeepAlivePageWidget(builder: (ctx, setState) {
              Logger.d('PagesManager >>>>>>>>>>>>> KeepAlivePageWidget rebuild: $name');
              return page;
            })
          : StatefulBuilder(builder: (ctx, setState) {
              Logger.d('PagesManager >>>>>>>>>>>>> StatefulBuilder rebuild: $name');
              return page;
            });
    };
    inst.tabBuilder = () {
      bool isSelected = currentPageIndex.value == inst.ordinal;
      return CupertinoButton(
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
          child: Column(
            children: [
              isSelected ? tabIconSelected : tabIcon,
              const SizedBox(height: 2.0),
              Text(name, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          onPressed: () {
            currentPageIndex.value = inst.ordinal;
            Broker.get<PageController>()?.jumpToPage(inst.ordinal);
          });
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
    return _getSortedTabsPages().map((e) => e.tabBuilder()).toList();
  }

  static List<Widget> getPages() {
    return _getSortedTabsPages().map((e) => e.pageBuilder()).toList();
  }
}

class TabPageInstance {
  String name;
  late int ordinal;
  late Widget Function() tabBuilder;
  late Widget Function() pageBuilder;

  TabPageInstance({required this.name});
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
