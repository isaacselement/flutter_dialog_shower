import 'package:example/util/logger.dart';
import 'package:example/view/manager/pages_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PagesManager.initPageController();
    PagesManager.initPages();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [DialogShower.getObserver()],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  static late List<OverlayEntry> initialEntries;

  @override
  Widget build(BuildContext context) {
    Logger.d("[HomePage] ----------->>>>>>>>>>>> build/rebuild!!!");

    /// init the dialog shower & overly shower
    DialogShower.init(context);
    OverlayShower.init(context);
    DialogWrapper.centralOfShower ??= (DialogShower shower, {Widget? child}) {
      shower
        // null indicate that: dismiss keyboard first while keyboard is showing, else dismiss dialog immediately
        ..barrierDismissible = null
        ..containerShadowColor = Colors.grey
        ..containerShadowBlurRadius = 20.0
        ..containerBorderRadius = 10.0;
    };
    OverlayWrapper.centralOfShower ??= (OverlayShower shower) {
      Logger.d("a new overlay show: $shower");
    };

    /// init the size utilities with context
    SizesUtils.init(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          /// get init entries during this period
          /// 1. get init entries from navigator state
          NavigatorState navigatorState = Navigator.of(OverlayShower.gContext!, rootNavigator: true);
          initialEntries = navigatorState.overlay!.widget.initialEntries;

          /// 2. get init entries from overlay state
          // OverlayState overlayState = Overlay.of(OverlayShower.gContext!, rootOverlay: true)!;
          // initialEntries = overlayState.widget.initialEntries;
          return const HomeBody();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.white,
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                width: 70,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Btw(
                          builder: (context) {
                            return Column(
                              children: PagesManager.getTabs(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.25, 0.25, 0.5, 0.5, 0.75, 0.75, 1],
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFF8181A5),
                    Color(0xFF8181A5),
                    Color(0xFF8181A5),
                    Color(0xFF8181A5),
                    Color(0xFF8181A5),
                    Color(0xFF8181A5),
                    Color(0xFFFFFFFF),
                  ],
                )),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
                    return PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: PagesManager.getPageController(),
                      children: PagesManager.getPages(),
                    );
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
