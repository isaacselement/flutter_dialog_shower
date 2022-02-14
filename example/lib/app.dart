import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';

import 'util/logger.dart';
import 'view/manager/pages_manager.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PagesManager.init();

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            Container(
              // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: 70,
              decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.black))),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: PagesManager.getTabs(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
