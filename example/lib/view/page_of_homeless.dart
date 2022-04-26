import 'package:example/util/logger.dart';
import 'package:example/util/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class PageOfHomeless extends StatelessWidget {
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
        ],
      ),
    );
  }

  Widget _buildBoxesWidgets() {
    return Column(
      children: [
        Row(
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
                      child: const SizedBox(width: 200, height: 200, child: ColoredBox(color: Colors.red)),
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
                      child: const SizedBox(width: 303, height: 188, child: ColoredBox(color: Colors.red)),
                      onLayoutChanged: (RenderBox box, Offset offset, Size size) {
                        _showToastOnTop('I got your position: $offset');
                        _showToastOnTop('I got your size: $size');
                      },
                    ),
                  )
                    ..dx = 202
                    ..dy = 208
                    ..onTapCallback = (shower) => shower.dismiss();
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _initSettings() {
    boxes_log_enable = true;
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

  void _showToastOnTop(String message) {
    OverlayWidgets.showToastInQueue(message)
      ..alignment = Alignment.topCenter
      ..margin = const EdgeInsets.only(top: 80);
  }
}
