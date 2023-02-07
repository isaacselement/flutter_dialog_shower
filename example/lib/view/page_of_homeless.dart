// ignore_for_file: must_be_immutable

import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:example/view/page_of_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfHomeless extends StatelessWidget {
  const PageOfHomeless({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfHomeless] ----------->>>>>>>>>>>> build/rebuild!!!");

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
    _initSettings();
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          WidgetsUtil.newHeaderWithGradient('Homeless'),
          const SizedBox(height: 16),
          _buildBoxesWidgets(),
          const SizedBox(height: 16),
          _buildBrokerTest(),
          const SizedBox(height: 32),
          _buildHomelessWidget(),
          const SizedBox(height: 32),
          _buildAnythingWidget(),
        ],
      ),
    );
  }

  Widget _buildBoxesWidgets() {
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Event Truck Fire', onPressed: (state) {
              EventTruck.fire('object or anything :)');
              _showToastOnTop('fire!!!');
            }),
            WidgetsUtil.newXpelTextButton('Get Size Widget', onPressed: (state) {
              OverlayWrapper.show(
                GetSizeWidget(
                  child: const SizedBox(width: 200, height: 300, child: ColoredBox(color: Colors.purple)),
                  onLayoutChanged: (RenderBox box, Size? legacy, Size size) {
                    _showToastOnTop('I got your size: $size');
                  },
                ),
              )
                ..dx = 202
                ..dy = 208
                ..onTapCallback = (shower) => shower.dismiss();
            }),
            WidgetsUtil.newXpelTextButton('Get Position Widget', onPressed: (state) {
              OverlayWrapper.show(
                GetLayoutWidget(
                  onLayoutChanged: (RenderBox box, Offset offset, Size size) {
                    _showToastOnTop('I got parent position: $offset');
                    _showToastOnTop('I got parent size: $size');
                  },
                  child: Container(
                    width: 400,
                    height: 400,
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    color: Colors.orange,
                    child: GetLayoutWidget(
                      onLayoutChanged: (RenderBox box, Offset offset, Size size) {
                        _showToastOnTop('I got your position: $offset');
                        _showToastOnTop('I got your size: $size');
                      },
                      child: SizedBox(
                        width: 288,

                        /// TODO ... NOT take effect ???
                        height: 188,

                        /// TODO ... NOT take effect ???
                        child: GetLayoutWidget(
                          onLayoutChanged: (RenderBox box, Offset offset, Size size) {
                            _showToastOnTop('I got son position: $offset');
                            _showToastOnTop('I got son size: $size');
                          },
                          child: const ColoredBox(
                            color: Colors.red,
                            child: Center(child: Text('see the logs')),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                ..dx = 202
                ..dy = 208
                ..onTapCallback = (shower) => shower.dismiss();
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildBrokerTest() {
    PageOfHome home = const PageOfHome();
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Push', onPressed: (state) {
              Stacker.push<PageOfHome>(const PageOfHome());
              Stacker.push<PageOfHome>(const PageOfHome());
              Stacker.push<PageOfHome>(const PageOfHome());
              Stacker.push<PageOfHome>(const PageOfHome());
              Stacker.push<PageOfHome>(const PageOfHome());
              Stacker.push<PageOfHome>(home);
            }),
            WidgetsUtil.newXpelTextButton('Pop', onPressed: (state) {
              bool containsInList = Stacker.contains<PageOfHome>();
              Logger.console(() => '=======>>>>>>>>>>>> containsInList: $containsInList');
              int count = Stacker.remove<PageOfHome>();
              // int count =  Stacker.remove(value: home);
              Logger.console(() => '=======>>>>>>>>>>>> removeInList: $count');
              containsInList = Stacker.contains<PageOfHome>();
              Logger.console(() => '=======>>>>>>>>>>>> after containsInList: $containsInList');
            }),
          ],
        ),
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Throttled New', onPressed: (state) {
              AnyThrottle.instance.call(() {
                Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle instance 1');
                AnyThrottle().call(() {
                  Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle New 1');
                  _callInInternal();
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('Throttled Sync', onPressed: (state) {
              AnyThrottle.instance.call(() {
                Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle instance 1');
                AnyThrottle.instance.call(() {
                  Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle instance 2');
                  AnyThrottle().call(() {
                    Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle New 1');
                    AnyThrottle.instance.call(() {
                      Logger.console(() => '=======>>>>>>>>>>>> AnyThrottle instance 3');
                      _callInInternal();
                    });
                  });
                });
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildHomelessWidget() {
    Btv<bool> hidden = true.btv;
    return Column(
      children: [
        Wrap(
          children: [
            WidgetsUtil.newXpelTextButton('Spin', onPressed: (state) {
              hidden.value = !hidden.value;
            }),
            Btw(
              builder: (context) {
                if (hidden.value) {
                  return const Offstage(offstage: true);
                }
                return RotateWidget(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 500),
                  child: PainterWidgetUtil.getOneLoadingCircleWidget(
                    isPaintAnimation: true,
                    isPaintStartStiff: true,
                    side: 80,
                    stroke: 6,
                    duration: const Duration(milliseconds: 1500),
                    colorSmall: Colors.black,
                    colorBig: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnythingWidget() {
    return Column(
      children: [
        Wrap(
          children: [
            AnythingFielder(
              title: 'First Name',
              options: AnythingFielderOptions()..contentHintText = 'i.e. Kethoree',
            ),
            AnythingFielder(
              title: 'Last Name',
              options: AnythingFielderOptions()..contentHintText = 'i.e. Jobs',
            ),
            AnythingFielder(
              title: 'Age',
              funcOfEndClear: (state) {},
              options: AnythingFielderOptions()
                ..contentHintText = 'Just input your age with digital number, just a long hint text. i.e. 18 :P'
                ..keyboardType = TextInputType.phone
                ..isHorizontal = true
                ..textAlign = TextAlign.end
                ..contentDecorationNormal = null
                ..contentDecorationFocused = null,
            ),

          ],
        ),
      ],
    );
  }

  /// Private Methods

  _callInInternal() {
    Logger.console(() => '>>>>>>>>>>>>>>>>> _callInInternal ~~~~~~');
  }

  void _initSettings() {
    Journal.enable = true;
    EventTruck.onWithKey(
      key: 'event_key_1',
      onData: (object) {
        OverlayWidgets.showToastInQueue('Got: $object', increaseOffset: const EdgeInsets.only(bottom: 45)).alignment =
            Alignment.bottomLeft;
      },
    );
    EventTruck.onWithKey(
      key: 'event_key_2',
      onData: (object) {
        OverlayWidgets.showToastInQueue('Received: $object', increaseOffset: const EdgeInsets.only(bottom: 45)).alignment =
            Alignment.bottomRight;
      },
    );
  }

  OverlayShower _showToastOnTop(String message) {
    Logger.console(() => '[Homeless] --------->>>>>> $message');
    return OverlayWidgets.showToastInQueue(message, onScreenDuration: const Duration(milliseconds: 3000))
      ..alignment = Alignment.topCenter
      ..margin = const EdgeInsets.only(top: 80);
  }
}
