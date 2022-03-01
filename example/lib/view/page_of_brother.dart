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
        const Text('Basic usage of Btw & btv', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Just click icons below', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
        Btw(builder: () {
          return Wrap(
            spacing: 20,
            children: [
              createBasicTabButton(
                'Support',
                0,
                const Icon(Icons.support, size: 50, color: Colors.black26),
                const Icon(Icons.support_sharp, size: 50, color: Colors.deepOrange),
              ),
              createBasicTabButton(
                'Surround',
                1,
                const Icon(Icons.surround_sound, size: 50, color: Colors.black26),
                const Icon(Icons.surround_sound_sharp, size: 50, color: Colors.deepOrange),
              ),
              createBasicTabButton(
                'Store',
                2,
                const Icon(Icons.store, size: 50, color: Colors.black26),
                const Icon(Icons.store_sharp, size: 50, color: Colors.deepOrange),
              ),
              createBasicTabButton(
                'Esports',
                3,
                const Icon(Icons.sports_esports, size: 50, color: Colors.black26),
                const Icon(Icons.sports_esports_sharp, size: 50, color: Colors.deepOrange),
              ),
              createBasicTabButton(
                'Spa',
                4,
                const Icon(Icons.spa, size: 50, color: Colors.black26),
                const Icon(Icons.spa_sharp, size: 50, color: Colors.deepOrange),
              ),
            ],
          );
        }),
        const Spacer(),
        buildNestedBtwsWidget(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Click me', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                List<String> list = [':)', ':P', 'Orz', 'T_T'];
                changeMeText.value = (list
                      ..remove(changeMeText.value)
                      ..shuffle())
                    .first;
              },
            ),
            const SizedBox(width: 24),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Change the selected icon text', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                List<String> list = [DateTime.now().toString(), 'It\'s not my name', 'Go go go', 'Copy that'];
                currentAdvancedString.value = (list
                      ..remove(currentAdvancedString.value)
                      ..shuffle())
                    .first;
              },
            ),
            const SizedBox(width: 24),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Reset icons', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                // batch update values, set state once
                currentAdvancedString.data = '';
                currentAdvancedIndex.data = 0;
                currentAdvancedIndex.update();
              },
            ),
            const SizedBox(width: 24),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              child: const Text('Reset all', style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                changeMeText.data = '';
                currentAdvancedString.data = '';
                currentAdvancedIndex.data = 0;
                resetAllFlag.value = !resetAllFlag.value;
              },
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildNestedBtwsWidget() {
    return Btw(builder: () {
      resetAllFlag.value; // a tricky here, place holder for set state in parent, not a good practice :)
      return Column(
        children: [
          const Text('Advanced usage of Btw & btv', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Btw(
            builder: () {
              String text = changeMeText.value.isEmpty ? 'Click me / Change me' : changeMeText.value;
              return InkWell(
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.purple))),
                onTap: () {
                  List<String> list = ['Niu', 'Niu Niu Niu', 'Shadow Niu', 'SixSixSix', 'Hahaha'];
                  changeMeText.value = (list
                        ..remove(changeMeText.value)
                        ..shuffle())
                      .first;
                },
              );
            },
          ),
          buildBtwWidget(),
        ],
      );
    });
  }

  Widget buildBtwWidget() {
    return Btw(builder: () {
      return Wrap(
        spacing: 20,
        children: [
          createAdvancedTabButton(
            'Support',
            0,
            const Icon(Icons.support, size: 50, color: Colors.black26),
            const Icon(Icons.support_sharp, size: 50, color: Colors.deepOrange),
          ),
          createAdvancedTabButton(
            'Surround',
            1,
            const Icon(Icons.surround_sound, size: 50, color: Colors.black26),
            const Icon(Icons.surround_sound_sharp, size: 50, color: Colors.deepOrange),
          ),
          createAdvancedTabButton(
            'Store',
            2,
            const Icon(Icons.store, size: 50, color: Colors.black26),
            const Icon(Icons.store_sharp, size: 50, color: Colors.deepOrange),
          ),
          createAdvancedTabButton(
            'Esports',
            3,
            const Icon(Icons.sports_esports, size: 50, color: Colors.black26),
            const Icon(Icons.sports_esports_sharp, size: 50, color: Colors.deepOrange),
          ),
          createAdvancedTabButton(
            'Spa',
            4,
            const Icon(Icons.spa, size: 50, color: Colors.black26),
            const Icon(Icons.spa_sharp, size: 50, color: Colors.deepOrange),
          ),
        ],
      );
    });
  }

  /// Static fields & methods

  static Bt<int> currentBasicIndex = 0.btv;
  static Bt<String> currentBasicString = ''.btv;

  static Widget createBasicTabButton(String name, int myIndex, Widget tabIcon, Widget tabIconSelected) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
      child: Column(
        children: [
          currentBasicIndex.value == myIndex ? tabIconSelected : tabIcon,
          const SizedBox(height: 2.0),
          Text(
            currentBasicIndex.value == myIndex && currentBasicString.value.isNotEmpty ? currentBasicString.value : name,
            style: TextStyle(color: currentBasicIndex.value == myIndex ? Colors.deepOrange : Colors.grey, fontSize: 11),
          ),
        ],
      ),
      onPressed: () {
        currentBasicIndex.value = myIndex;
      },
    );
  }

  static Bt<bool> resetAllFlag = false.btv;
  static Bt<String> changeMeText = ''.btv;
  static Bt<int> currentAdvancedIndex = 0.btv;
  static Bt<String> currentAdvancedString = ''.btv;

  static Widget createAdvancedTabButton(String name, int myIndex, Widget tabIcon, Widget tabIconSelected) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
      child: Column(
        children: [
          currentAdvancedIndex.value == myIndex ? tabIconSelected : tabIcon,
          const SizedBox(height: 2.0),
          Text(
            currentAdvancedIndex.value == myIndex && currentAdvancedString.value.isNotEmpty ? currentAdvancedString.value : name,
            style: TextStyle(color: currentAdvancedIndex.value == myIndex ? Colors.deepOrange : Colors.grey, fontSize: 11),
          ),
        ],
      ),
      onPressed: () {
        currentAdvancedIndex.value = myIndex;
      },
    );
  }
}
