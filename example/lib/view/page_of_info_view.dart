import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/core/dialog_wrapper.dart';

class PageOfInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              const Text('Fixed: '),
              CupertinoButton(
                child: const Text('Show center default with width & height specified'),
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
                child: const Text('Show with x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    isFixed: true,
                    x: 50,
                    y: 50,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('NotFixed: '),
              CupertinoButton(
                child: const Text('Show center default'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                  );
                },
              ),
              const SizedBox(width: 20),
              CupertinoButton(
                child: const Text('Show with x/y'),
                onPressed: () {
                  DialogWrapper.show(
                    _getEditBox(),
                    x: 50,
                    y: 50,
                  );
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
