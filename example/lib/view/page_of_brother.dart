import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/broker/brother.dart';

class PageOfBrother extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
              return buildContainer();
            },
          );
        },
      ),
      // child: smallestContainer(),
    );
  }

  Widget buildContainer() {
    return Column(
      children: [
        const Spacer(),
        buildBtwsWidget(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Change the selected text', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                List<String> list = [DateTime.now().toString(), 'It\'s not my name', 'Go go go', 'Copy that'];
                currentTapedString.value = (list
                      ..remove(currentTapedString.value)
                      ..shuffle())
                    .first;
              },
            ),
            const SizedBox(width: 24),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Reset', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                currentTapedString.data = '';
                currentTapedIndex.data = 0;
                currentTapedIndex.update();
              },
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildBtwsWidget() {
    return Btw(builder: () {
      return Wrap(
        spacing: 20,
        children: [
          createTabButton(
            'Support',
            0,
            const Icon(Icons.support, size: 50, color: Colors.black26),
            const Icon(Icons.support_sharp, size: 50, color: Colors.deepOrange),
          ),
          createTabButton(
            'Surround',
            1,
            const Icon(Icons.surround_sound, size: 50, color: Colors.black26),
            const Icon(Icons.surround_sound_sharp, size: 50, color: Colors.deepOrange),
          ),
          createTabButton(
            'Store',
            2,
            const Icon(Icons.store, size: 50, color: Colors.black26),
            const Icon(Icons.store_sharp, size: 50, color: Colors.deepOrange),
          ),
          createTabButton(
            'Esports',
            3,
            const Icon(Icons.sports_esports, size: 50, color: Colors.black26),
            const Icon(Icons.sports_esports_sharp, size: 50, color: Colors.deepOrange),
          ),
          createTabButton(
            'Spa',
            4,
            const Icon(Icons.spa, size: 50, color: Colors.black26),
            const Icon(Icons.spa_sharp, size: 50, color: Colors.deepOrange),
          ),
        ],
      );
    });
  }

  static Bt<int> currentTapedIndex = 0.btw;
  static Bt<String> currentTapedString = ''.btw;

  static Widget createTabButton(String name, int myIndex, Widget tabIcon, Widget tabIconSelected) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
      child: Column(
        children: [
          currentTapedIndex.value == myIndex ? tabIconSelected : tabIcon,
          const SizedBox(height: 2.0),
          Text(
            currentTapedIndex.value == myIndex && currentTapedString.value.isNotEmpty ? currentTapedString.value : name,
            style: TextStyle(color: currentTapedIndex.value == myIndex ? Colors.deepOrange : Colors.grey, fontSize: 11),
          ),
        ],
      ),
      onPressed: () {
        currentTapedIndex.value = myIndex;
      },
    );
  }
}
