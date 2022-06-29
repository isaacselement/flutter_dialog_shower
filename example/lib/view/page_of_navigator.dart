import 'dart:convert';

import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

import '../util/logger.dart';

class PageOfNavigator extends StatelessWidget {
  const PageOfNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfNavigator] ----------->>>>>>>>>>>> build/rebuild!!!");

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
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          WidgetsUtil.newHeaderWithGradient('Navigator inner shower'),
          const SizedBox(height: 16),
          buildButtonsAboutNavigator(),
          const SizedBox(height: 16),
          buildButtonsAboutPickerList(),
        ],
      ),
    );
  }

  Widget buildButtonsAboutNavigator() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show with navigator with Width & Height', onPressed: (state) {
              DialogWrapper.pushRoot(
                WidgetsUtil.newClickMeWidget(clickMeFunctions: {
                  'Click me': (context) {
                    rootBundle.loadString('assets/json/CN.json').then((string) {
                      List<dynamic> value = json.decode(string);
                      DialogWrapper.push(PageOfNavigator.getSelectableListWidget(value: value),
                          settings: const RouteSettings(name: '__root_route__'));
                    });
                  }
                }),
                width: 600,
                height: 600,
              );
            }),
            WidgetsUtil.newXpelTextButton('Show with navigator without W&H (Auto size)', onPressed: (state) {
              DialogWrapper.pushRoot(WidgetsUtil.newClickMeWidget(clickMeFunctions: {
                'Click me to push': (context) {
                  rootBundle.loadString('assets/json/CN.json').then((string) {
                    List<dynamic> value = json.decode(string);
                    DialogWrapper.push(PageOfNavigator.getSelectableListWidget(value: value),
                        settings: const RouteSettings(name: '__root_route__'));
                  });
                },
                'Click me to setState': (context) {
                  DialogWrapper.getTopDialog()?.setState(() {});
                }
              }));
            }),
          ],
        )
      ],
    );
  }

  Widget buildButtonsAboutPickerList() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Show selectabl list', onPressed: (state) {
              rootBundle.loadString('assets/json/CN.json').then((string) {
                List<dynamic> value = json.decode(string);
                DialogWrapper.pushRoot(
                  PageOfNavigator.getSelectableListWidget(value: value, doneSelectEvent: (depth, object) {

                    return true;
                  }),
                  settings: const RouteSettings(name: '__root_route__'),
                  width: 500,
                );
              });
            }),
          ],
        )
      ],
    );
  }

  /// Static Methods
  static AnythingSelector getSelectableListWidget({
    required Object value,
    int depth = 0,
    bool Function(int depth, Object value)? doneSelectEvent,
  }) {
    return AnythingSelector(
      title: 'Select The City',
      values: ((value is Map ? value['children'] : value) as List<dynamic>).cast(),
      funcOfItemName: (s, i, e) => e is Map ? e['areaName'] : '',
      isSearchEnable: true,
      headerOptions: AnythingHeaderOptions()
      ..leftEvent = (){
        DialogWrapper.pop();
      },
        options: AnythingSelectorOptions()..itemSuffixWidget =  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      // itemSuffixBuilder: (state, index, value) {
      //   if (value is Map && value['children'] != null && value['children']!.isNotEmpty) {
      //     return const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
      //   }
      //   return null;
      // },
      funcOfItemOnTapped: (state, index, value) {
        if (value is! Map) {
          return;
        }
        if (value['children'] == null || value['children']!.isEmpty) {
          if (doneSelectEvent?.call(depth, value) ?? false) {
            return;
          }
          DialogWrapper.getTopNavigatorDialog()!.getNavigator()!.popUntil((route) => route.settings.name == '__root_route__');
          DialogWrapper.pop();
          return;
        }
        DialogWrapper.push(getSelectableListWidget(value: value, depth: depth++), settings: RouteSettings(name: 'depth+$depth'));
      },
    );
  }

}
