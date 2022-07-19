import 'dart:async';
import 'dart:convert';
import 'package:example/util/header_util.dart';
import 'package:example/util/shower_helper.dart';
import 'package:example/util/toast_util.dart';
import 'package:example/view/widget/xp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class XpSliderWidget extends StatelessWidget {
  XpSliderWidget({Key? key}) : super(key: key);

  Btv<bool> isResetButtonDisable = true.btv;
  Btv<String> selectCountryValue = ''.btv;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _header(),
        const SizedBox(height: 10),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _header() {
    Btv<bool> isExpanded = false.btv;
    double originalWidth = DialogWrapper.getTopDialog()?.width ?? 600;
    void shrinkExpandEvent(BuildContext context) {
      DialogShower? shower = DialogWrapper.getTopDialog();
      if (shower != null && shower.isWithTicker == true) {
        ShowerHelper.transformWidth(
          shower: shower,
          begin: shower.width,
          end: isExpanded.value ? originalWidth : SizesUtil.screenWidth,
          onDuring: (v) {
            // show the toast during expand animation
            String msg = 'Progress: ${v.toStringAsFixed(5)}';
            AnyToastWidget? widget = ElementsUtil.getWidgetOfType<AnyToastWidget>(context);
            if (widget == null) {
              ToastUtil.show(msg);
            } else {
              Boxes.getWidgetsBinding().addPostFrameCallback((timeStamp) {
                ElementsUtil.rebuild<AnyToastWidget>(shower.statefulKey.currentContext, (widget) {
                  widget.text = msg;
                });
              });
            }
          },
          onFinish: () {
            isExpanded.value = !isExpanded.value;
          },
        );
      }
    }

    void doneEvent() {
      isResetButtonDisable.value = !isResetButtonDisable.value;
    }

    return Btw(builder: (context) {
      return HeaderUtil.headerWidget(
        title: 'Nested Navigator & Layer',
        rightTitlesList: [isExpanded.value ? 'Shrink' : 'Expand', 'Done'],
        rightEventsList: [
          () {
            shrinkExpandEvent(context);
          },
          doneEvent
        ],
      );
    });
  }

  Widget _body() {
    List<dynamic> selectedValues = [];

    return Container(
      padding: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                AnythingPicker(
                  title: 'AnythingPicker demonstration',
                  values: _getListValues(),
                  funcOfItemOnTapped: (state, index, value) {
                    selectCountryValue.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Single Selection',
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  funcOfValues: () async {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    return _getListValues();
                  },
                  funcOfItemOnTapped: (state, index, value) {
                    selectCountryValue.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Loading Selection',
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  funcOfValues: () {
                    return _getListValues();
                  },
                  funcOfItemOnTapped: (state, index, value) {
                    selectCountryValue.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Multiple Selection',
                  selectedValues: selectedValues,
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  title: 'AnythingPicker with arrow',
                  values: _getListValues(),
                  funcOfItemOnTapped: (state, index, value) {
                    selectCountryValue.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()
                    ..contentHintText = ''
                    // ..bubbleTriangleDirection = CcBubbleArrowDirection.top,  /// TODO ...
                ),
                const SizedBox(height: 80),
                _bodyRowTips(),
                const SizedBox(height: 100),
                _bodyCityPicker(),
                const SizedBox(height: 200),
                const SizedBox(height: 500),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _bodyBottomButtons(),
      ]),
    );
  }

  Widget _bodyRowTips() {
    LayerLink _layerLink = LayerLink();

    return Row(
      children: [
        CcTapWidget(
          child: Row(children: const [Text('Click me '), Icon(Icons.info_outline, color: Colors.blueAccent)]),
          onTap: (state) {
            Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
            Size size = SizesUtil.getSizeS(state) ?? Size.zero;
            ToastUtil.showWithArrow(
              '1. You know that ~~~~~~~~~~~~\n2. HuaHuHuaHaHua~~~~~~~ \n3. I don\'t know that!!!',
              x: position.dx + size.width,
              y: position.dy - 25,
            );
          },
        ),
        const SizedBox(width: 50),
        CcTapWidget(
          child: const Icon(Icons.info_outline, color: Colors.grey),
          onTap: (state) {
            Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
            Size size = SizesUtil.getSizeS(state) ?? Size.zero;
            ToastUtil.showDialogToast(
              '1. You know that ~~~~~~~~~~~~\n2. HuaHuHuaHaHua~~~~~~~ \n3. I don\'t know that!!!',
              x: position.dx + size.width,
              y: position.dy - 25,
            );
          },
        ),
        const SizedBox(width: 50),
        CompositedTransformTarget(
          link: _layerLink,
          child: CcTapWidget(
            child: Row(children: const [Text('Scroll with me '), Icon(Icons.info_outline, color: Colors.blueAccent)]),
            onTap: (state) {
              ToastUtil.showWithArrowSticky(
                '1. You know that ~~~~~~~~~~~~\n2. HuaHuHuaHaHua~~~~~~~ \n3. I don\'t know that!!!',
                layerLink: _layerLink,
                width: 200,
                offset: const Offset(120, -7),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _bodyCityPicker() {
    return AnythingGangedPicker(
      title: 'City selection demonstration',
      showerWidth: 450,
      funcOfTitle: (view, i, e) {
        return e is Map ? e['areaName'] : 'Province';
      },
      funcOfValues: (view, i, e) async {
        if (e == null) {
          String string = await rootBundle.loadString('assets/json/CN.json');
          return (json.decode(string)) as List<dynamic>?;
        }
        return (e is Map ? e['children'] : e) as List<dynamic>?;
      },
      funcOfItemName: (view, i, e) {
        return e is Map ? e['areaName'] : '';
      },
      hasNext: (view, i, e) {
        return (e is Map ? e['children'] : null) != null;
      },
      funcOfLeafItemOnTapped: (view, i, e) {
        return false;
      },
    );
  }

  Widget _bodyBottomButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            const Spacer(),
            Btw(builder: (context) {
              return XpTextButton(
                'Reset',
                width: constraints.maxWidth / 3,
                height: 40,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                borderColor: const Color(0xFFDADAE8),
                isDisable: isResetButtonDisable.value,
                backgroundColor: null,
                backgroundColorDisable: const Color(0xFFF5F5FA),
                textStyleBuilder: (text, isTappingDown) {
                  if (isResetButtonDisable.value) {
                    return const TextStyle(color: Color(0xFFBFBFD2), fontSize: 16);
                  }
                  Color color = const Color(0xFF1C1D21);
                  return TextStyle(color: isTappingDown ? color.withAlpha(128) : color, fontSize: 16);
                },
                onPressed: (state) {},
              );
            }),
            SizedBox(width: constraints.maxWidth / 8),
            XpTextButton(
              'Save',
              width: constraints.maxWidth / 3,
              height: 40,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              borderColor: const Color(0xFFDADAE8),
              textStyleBuilder: (text, isTappingDown) {
                Color color = Colors.white;
                color = isTappingDown ? color.withAlpha(128) : color;
                return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
              },
              onPressed: (state) {
                isResetButtonDisable.value = !isResetButtonDisable.value;
              },
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  /// Static Methods

  static List<String> _getListValues() {
    return const [
      'India',
      'UK',
      'USA',
      'Russia',
      'Korea',
      'Mexico',
      'Italy',
      'Japan',
      'Ukraine',
      'Germany',
    ];
  }
}
