import 'dart:async';

import 'package:example/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/core/dialog_shower.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class PageOfInfoView extends StatelessWidget {
  static bool isInited = false;

  static void ensureInited() {
    Logger.d('PageOfInfoView ensureInited---> $isInited');
    if (isInited) {
      return;
    }
    isInited = !isInited;
    EventChannel eventChannel = const EventChannel('shower_keyboard_visibility');
    Stream<dynamic> stream = eventChannel.receiveBroadcastStream();
    StreamSubscription streamSubscription = stream.listen((event) {
      Logger.d('PageOfInfoView 【keyboard visibility】---> $event');
      if (event is int) {
        DialogShower? topDialog = DialogWrapper.getTopDialog();
        if (topDialog != null) {
          DialogShower shower = topDialog;
          if (shower.obj is int || shower.obj is List) {
            shower.obj = shower.obj is int ? [shower.alignment, shower.margin] : shower.obj;
            Alignment ancientA = (shower.obj as List)[0];
            Alignment novelA = Alignment(ancientA.x, -1.0);
            EdgeInsets? ancientE = (shower.obj as List)[1];
            EdgeInsets novelE =
                EdgeInsets.only(left: ancientE?.left ?? 0, right: ancientE?.right ?? 0, bottom: ancientE?.bottom ?? 0, top: 30);
            shower.setState(() {
              shower.alignment = event == 1 ? novelA : ancientA;
              shower.margin = event == 1 ? novelE : ancientE;
            });
          }
        }
      }
    });

    // streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Logger.d("[PageOfInfoView] ----------->>>>>>>>>>>> build/rebuild!!!");
    ensureInited();

    return Container(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(width: 500, height: 600),
                    isFixed: true,
                    // width: 500,
                    // height: 600,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                    isFixed: true,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                    isFixed: true,
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    isFixed: true,
                    x: 200,
                    y: 50,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Un Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    x: 200,
                    y: 50,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Custome Positioned: '),
              CupertinoButton(
                child: const Text('Show center'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show left'),
                onPressed: () {
                  DialogWrapper.showLeft(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show right'),
                onPressed: () {
                  DialogWrapper.showRight(
                    _getEditBox(),
                  ).obj = 1;
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    x: 200,
                    y: 200,
                  ).obj = 1;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getEditBox({double width = 500, double height = 600}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(border: Border.all(color: Colors.lightGreen, width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField(
              padding: const EdgeInsets.all(6.0),
              style: const TextStyle(fontSize: 15, color: Colors.black),
              maxLines: 100,
              maxLength: 1000,
              onChanged: (str) {},
            )
          ],
        ),
      ),
    );
  }
}
