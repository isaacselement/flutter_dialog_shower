import 'package:example/util/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';

import 'util/logger.dart';
import 'view/manager/pages_manager.dart';

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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Logger.d("[HomePage] ----------->>>>>>>>>>>> build/rebuild!!!");

    DialogShower.init(context);

    SizeUtil.init(context);

    return Scaffold(
      body: Container(
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
                            builder: () {
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
                    return PageRouteBuilder(
                        pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
