import 'package:example/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';

class PageOfBrother extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfBrother] ----------->>>>>>>>>>>> build/rebuild!!!");
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
            return SingleChildScrollView(child: buildContainer());
          },
        );
      },
    );
  }

  Widget buildContainer() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Wrap(
          spacing: 32,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Btw & btv', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBtwBtv(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Btw & btv null', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBtwBtvNull(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Btw & btKey', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBtwBtKey(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Btw & String Key', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBtwWithStringKey(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        BrotherBasicView(),
        const SizedBox(height: 96),
        BrotherAdvanceView(),
      ],
    );
  }

  Widget _buildBtwBtv() {
    Btv<Color> color = Colors.black26.btv;
    return Btw(
      builder: (context) {
        return CupertinoButton(
            child: Icon(Icons.swipe, size: 50, color: color.value),
            onPressed: () {
              color.value = (color.value == Colors.black) ? Colors.green : Colors.black;
            });
      },
    );
  }

  Widget _buildBtwBtvNull() {
    Btv<Color?> color = Btv<Color?>(null);
    return Btw(
      builder: (context) {
        return CupertinoButton(
            child: Icon(Icons.flare, size: 50, color: color.value??Colors.purpleAccent),
            onPressed: () {
              if (color.value == null) {
                color.value = Colors.deepOrange;
              } else if (color.value == Colors.deepOrange) {
                color.value = Colors.black;
              } else if (color.value == Colors.black) {
                color.value = null;
              }
            });
      },
    );
  }

  Widget _buildBtwBtKey() {
    Color color = Colors.black26;
    BtKey btKey = BtKey();
    return Btw(
      builder: (context) {
        btKey.eye; // Put an eye here. Just like ... Dota/LOL online game 插个眼.
        return CupertinoButton(
            child: Icon(Icons.fingerprint, size: 50, color: color),
            onPressed: () {
              color = color == Colors.red ? Colors.purpleAccent : Colors.red;
              btKey.update();
            });
      },
    );
  }

  Widget _buildBtwWithStringKey() {
    Color colorHello = Colors.black26;
    Color colorRefresh = Colors.black26;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Btw(
          updateKey: '__hello_hello_hello__',
          builder: (context) {
            return CupertinoButton(
                child: Icon(Icons.restore_from_trash, size: 50, color: colorHello),
                onPressed: () {
                  colorHello = colorHello == Colors.red ? Colors.purpleAccent : Colors.red;
                  Btw.update('__hello_hello_hello__');
                });
          },
        ),
        Btw(
          updateKey: '__can_you_see__',
          builder: (context) {
            return CupertinoButton(
                child: Icon(Icons.refresh, size: 50, color: colorRefresh),
                onPressed: () {
                  colorHello = colorHello == Colors.red ? Colors.purpleAccent : Colors.red;
                  colorRefresh = colorRefresh == Colors.red ? Colors.purpleAccent : Colors.red;
                  Btw.updates(['__hello_hello_hello__', '__can_you_see__']);
                });
          },
        ),
      ],
    );
  }
}

class BrotherBasicView extends StatelessWidget {
  BrotherBasicView({Key? key}) : super(key: key);

  Btv<int> basicIndex = 0.btv;
  Btv<String> basicString = ''.btv;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Basic usage of Btw & btv', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Just click icons below', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
        Btw(builder: (context) {
          return Wrap(
            spacing: 20,
            children: [
              ViewsGenerator.createIconTabButton(
                'Support',
                0,
                const Icon(Icons.support, size: 50, color: Colors.black26),
                const Icon(Icons.support_sharp, size: 50, color: Colors.deepOrange),
                basicIndex,
                basicString,
              ),
              ViewsGenerator.createIconTabButton(
                'Surround',
                1,
                const Icon(Icons.surround_sound, size: 50, color: Colors.black26),
                const Icon(Icons.surround_sound_sharp, size: 50, color: Colors.deepOrange),
                basicIndex,
                basicString,
              ),
              ViewsGenerator.createIconTabButton(
                'Store',
                2,
                const Icon(Icons.store, size: 50, color: Colors.black26),
                const Icon(Icons.store_sharp, size: 50, color: Colors.deepOrange),
                basicIndex,
                basicString,
              ),
              ViewsGenerator.createIconTabButton(
                'Esports',
                3,
                const Icon(Icons.sports_esports, size: 50, color: Colors.black26),
                const Icon(Icons.sports_esports_sharp, size: 50, color: Colors.deepOrange),
                basicIndex,
                basicString,
              ),
              ViewsGenerator.createIconTabButton(
                'Spa',
                4,
                const Icon(Icons.spa, size: 50, color: Colors.black26),
                const Icon(Icons.spa_sharp, size: 50, color: Colors.deepOrange),
                basicIndex,
                basicString,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class BrotherAdvanceView extends StatelessWidget {
  BrotherAdvanceView({Key? key}) : super(key: key);

  BtKey updateWidgetsKey = BtKey();

  Btv<List<String>> changeMeLists = <String>[].btv;
  Btv<Map<String, String>> changeMeMaps = <String, String>{}.btv;

  Btv<int> advancedIndex = 0.btv;
  Btv<String> advancedString = ''.btv;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Btw(builder: (context) {
          updateWidgetsKey.eye; // Put an eye here. Dota/LOL online game 插个眼.

          return Column(
            children: [
              const Text('Advanced usage of Btw & btv', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Btw(
                builder: (context) {
                  String text = changeMeLists.value.isEmpty ? 'Change me [List]' : changeMeLists.value.toString();
                  return InkWell(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.purple))),
                    onTap: () {
                      List<String> list = ['Niu', 'Ok', 'Six', 'Wa', 'Ha', 'WuLa'];
                      changeMeLists.value.add((list..shuffle()).first);
                      changeMeLists.update();
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Btw(
                builder: (context) {
                  String text = changeMeMaps.value.isEmpty ? 'Change me {Map}' : changeMeMaps.value.toString();
                  return InkWell(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.purple))),
                    onTap: () {
                      List<String> v = ['❗️', '🔴', '👠', '⌘', '🏁', '啦', '呀', '呜', '吓', '喝', '嘻', '哈', '咳', 'か', 'нг', 'зз'];
                      changeMeMaps.value[(v..shuffle()).first] = (v..shuffle()).first;
                      changeMeMaps.update();
                    },
                  );
                },
              ),
              Btw(builder: (context) {
                return Wrap(
                  spacing: 20,
                  children: [
                    ViewsGenerator.createIconTabButton(
                      'Support',
                      0,
                      const Icon(Icons.support, size: 50, color: Colors.black26),
                      const Icon(Icons.support_sharp, size: 50, color: Colors.deepOrange),
                      advancedIndex,
                      advancedString,
                    ),
                    ViewsGenerator.createIconTabButton(
                      'Surround',
                      1,
                      const Icon(Icons.surround_sound, size: 50, color: Colors.black26),
                      const Icon(Icons.surround_sound_sharp, size: 50, color: Colors.deepOrange),
                      advancedIndex,
                      advancedString,
                    ),
                    ViewsGenerator.createIconTabButton(
                      'Store',
                      2,
                      const Icon(Icons.store, size: 50, color: Colors.black26),
                      const Icon(Icons.store_sharp, size: 50, color: Colors.deepOrange),
                      advancedIndex,
                      advancedString,
                    ),
                    ViewsGenerator.createIconTabButton(
                      'Esports',
                      3,
                      const Icon(Icons.sports_esports, size: 50, color: Colors.black26),
                      const Icon(Icons.sports_esports_sharp, size: 50, color: Colors.deepOrange),
                      advancedIndex,
                      advancedString,
                    ),
                    ViewsGenerator.createIconTabButton(
                      'Spa',
                      4,
                      const Icon(Icons.spa, size: 50, color: Colors.black26),
                      const Icon(Icons.spa_sharp, size: 50, color: Colors.deepOrange),
                      advancedIndex,
                      advancedString,
                    ),
                  ],
                );
              }),
            ],
          );
        }),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Click me', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                List<String> list = [':)', ':P', 'Orz', 'T_T'];
                changeMeLists.value.add((list..shuffle()).first);
                changeMeLists.update();
              },
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Change the selected icon text with dot value', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                List<String> list = [DateTime.now().toString(), 'It\'s not my name', 'Go go go', 'Copy that'];
                advancedString.value = (list
                      ..remove(advancedString.value)
                      ..shuffle())
                    .first;
              },
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Reset icons with update method', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                // batch update values, set state once
                advancedIndex.data = 0;
                advancedString.data = '';
                advancedString.update();
              },
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Reset all with BtKey', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                // using BtKey update values, set state once
                advancedString.data = '';
                advancedIndex.data = 0;
                changeMeLists.value.clear(); // will not update the view, unless .value = something will trigger the setState
                changeMeMaps.value.clear(); // will not update the view, unless .value = something will trigger the setState
                updateWidgetsKey.update();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ViewsGenerator {
  static Widget createIconTabButton(
      String myName, int myIndex, Widget icon, Widget iconSelected, Btv<int> selectedIndex, Btv<String> selectedString) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
      child: Column(
        children: [
          selectedIndex.value == myIndex ? iconSelected : icon,
          const SizedBox(height: 2.0),
          Text(
            selectedIndex.value == myIndex && selectedString.value.isNotEmpty ? selectedString.value : myName,
            style: TextStyle(color: selectedIndex.value == myIndex ? Colors.deepOrange : Colors.grey, fontSize: 11),
          ),
        ],
      ),
      onPressed: () {
        selectedIndex.value = myIndex;
      },
    );
  }
}
