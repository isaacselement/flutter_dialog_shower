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
          const SizedBox(height: 16),
          _buildTapWidget(),
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
              ThrottleAny.instance.call(() {
                Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny instance 1');
                ThrottleAny().call(() {
                  Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny New 1');
                  _callInInternal();
                });
              });
            }),
            WidgetsUtil.newXpelTextButton('Throttled Sync', onPressed: (state) {
              ThrottleAny.instance.call(() {
                Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny instance 1');
                ThrottleAny.instance.call(() {
                  Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny instance 2');
                  ThrottleAny().call(() {
                    Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny New 1');
                    ThrottleAny.instance.call(() {
                      Logger.console(() => '=======>>>>>>>>>>>> ThrottleAny instance 3');
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

  Widget _buildTapWidget() {
    return Column(
      children: [
        Wrap(
          children: [
            CcTapWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapWidget ~~~~');
              },
            ),
            CcTapOnceWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapOnceWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapOnceWidget ~~~~');
              },
            ),
            CcTapThrottledWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapThrottledWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapThrottledWidget ~~~~');
              },
            ),
            CcTapDebouncerWidget(
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('CcTapDebouncerWidget'),
              ),
              onTap: (state) {
                Logger.d('CcTapDebouncerWidget ~~~~');
              },
            )
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
