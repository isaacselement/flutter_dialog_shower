import 'package:example/controller/controller_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';

import 'view/handler/pages_handler.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PagesHandler.init();

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

    DialogShower.init(context);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 70,
            decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.black))),
            child: Column(
              children: [
                CupertinoButton(child: const Icon(Icons.home, size: 38), onPressed: () {}),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: PagesHandler.getTabs(),
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
                    controller: PagesHandler.getPageController(),
                    children: PagesHandler.getPages(),
                  );
                });
              },
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
