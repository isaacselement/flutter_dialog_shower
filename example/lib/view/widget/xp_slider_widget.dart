import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:example/util/header_util.dart';
import 'package:example/util/shower_helper.dart';
import 'package:example/util/toast_util.dart';
import 'package:example/view/widget/xp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class XpSliderWidget extends StatelessWidget {
  XpSliderWidget({Key? key}) : super(key: key);

  Btv<String> title = 'Nested Navigator & Layer'.btv;
  Btv<bool> isResetButtonDisable = true.btv;

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
    DialogShower? shower = DialogWrapper.getTopDialog();
    double mOriginalWidth = shower?.width ?? 600;

    void transform(double from, double to, void Function()? onFinish) {
      if (shower == null || shower.isWithTicker != true) {
        return;
      }
      ShowerHelper.transformWidth(
        shower: shower,
        begin: from,
        end: to,
        onDuring: (v) {
          // show the toast during expand animation
          String msg = 'Progress: ${v.toStringAsFixed(5)}';
          AnyToastWidget? widget = ElementsUtil.getWidgetOfType<AnyToastWidget>(OverlayShower.gContext);
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
        onFinish: onFinish,
      );
    }

    Btv<bool> isExpanded = false.btv;
    return Btw(builder: (context) {
      return HeaderUtil.headerWidget(
        title: title.value,
        rightTitlesList: [isExpanded.value ? 'Full Screen' : '', isExpanded.value ? 'Shrink' : 'Expand', 'Done'],
        rightEventsList: [
          () {
            transform(shower?.width ?? 600, SizesUtil.screenWidth, null);
          },
          () {
            double w = shower?.width ?? 600;
            transform(w, isExpanded.value ? mOriginalWidth : w + w / 2, () {
              isExpanded.value = !isExpanded.value;
            });
          },
          () {
            isResetButtonDisable.value = !isResetButtonDisable.value;
          },
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
                  values: _getStringsListValues(),
                  funcOfItemOnTapped: (state, index, value) {
                    title.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Single Selection',
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  funcOfValues: () async {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    return _getStringsListValues();
                  },
                  funcOfItemOnTapped: (state, index, value) {
                    title.value = value as String;
                    return false;
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Loading Selection',
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  selectedValues: selectedValues,
                  // as a repository, important for support multi-selections !!!
                  funcOfValues: () {
                    return _getEmployeesListValues();
                  },
                  funcOfItemName: (state, i, e) {
                    return (e as Employee).name;
                  },
                  funcOfItemOnTapped: (state, i, e) {
                    title.value = (e as Employee).title;
                    return false;
                  },
                  builderOfItemInner: (state, i, e) {
                    Employee employee = e as Employee;
                    bool isTapping = state.itemIsTapping(i);
                    bool isSelected = state.itemIsSelected(i, e);
                    Color color = isTapping ? Colors.orange : (isSelected ? Colors.grey.withOpacity(0.4) : Colors.white);
                    return Container(
                      height: 45,
                      decoration:
                          BoxDecoration(color: color, border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)))),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.person_outlined, color: isSelected ? Colors.redAccent : Colors.black),
                          const SizedBox(width: 8),
                          Text(employee.title, style: isSelected ? const TextStyle(fontWeight: FontWeight.bold) : null),
                          const Spacer(),
                          Text('Name: ${employee.name}', style: const TextStyle(color: Colors.deepOrangeAccent)),
                        ],
                      ),
                    );
                  },
                  options: AnythingPickerOptions()..contentHintText = 'Multiple Selection',
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  title: 'AnythingPicker with arrow ',
                  funcOfValues: () {
                    return _getStudentsListValues();
                  },
                  funcOfItemName: (state, i, e) {
                    return (e as Student).name;
                  },
                  funcOfItemOnTapped: (state, index, value) {
                    return false;
                  },
                  funcOfTitleOnTapped: (state, context) {
                    Offset offset = OffsetsUtil.getOffsetB(context) ?? Offset.zero;
                    String msg =
                        'But Flexible with FlexFit.\nloose acts like Expanded so the \nSuffixIcon gets pushed to the end \neven though TextGoesHere is a short text.';
                    ToastUtil.showDialogToast(msg, x: offset.dx + 200, y: offset.dy - 36);
                  },
                  options: AnythingPickerOptions()
                    ..contentHintText = ''
                    ..titleEndIcon = const Icon(Icons.info_outlined, size: 16, color: Colors.black54)
                    ..bubbleShadowColor = Colors.purpleAccent
                    ..bubbleTriangleDirection = CcBubbleArrowDirection.top,
                ),
                const SizedBox(height: 64),
                _bodyTips(),
                const SizedBox(height: 64),
                AnythingLevelsPicker(
                  title: 'City multi-level selection demonstration',
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
                  isHasNextLevel: (view, i, e) {
                    return (e is Map ? e['children'] : null) != null;
                  },
                  funcOfLeafItemOnTapped: (view, i, e) {
                    void showQueueLeftToast(String msg) {
                      OverlayWidgets.showToastInQueue(
                        msg,
                        increaseOffset: const EdgeInsets.only(top: 45, left: 18),
                        slideBegin: const Offset(-1000, 0),
                      )
                        ..alignment = Alignment.topLeft
                        ..margin = const EdgeInsets.only(top: 220, left: 20);
                    }

                    showQueueLeftToast('You select the leaf: $e');
                    Future.delayed(const Duration(milliseconds: 500), () {
                      String address = view.relativeElements.map((e) => e['areaName']).toList().join('/');
                      showQueueLeftToast('Detail address is: $address');
                    });
                    return false;
                  },
                  onShowerWidth: (view) => math.max((DialogWrapper.getTopDialog()?.width ?? 600) / 3 * 2, 450),
                  onPickerOptions: (view, options) {
                    options.titleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
                    return null;
                  },
                ),
                const SizedBox(height: 64),
                AnythingPicker(
                  title: 'AnythingPicker with auto position. (Arrowed. Scroll me up and down ~~~)  ',
                  values: _getStringsListValues(),
                  funcOfItemOnTapped: (state, index, value) {
                    return false;
                  },
                  options: AnythingPickerOptions()
                    ..contentHintText = ''
                    // ..titleEndIcon = const Icon(Icons.info_outlined, color: Colors.black) // test text overflow ...
                    ..bubbleShadowColor = Colors.purpleAccent
                    // bubbleTriangleDirection: if you don't wanna an arrow set it to null. set it to none, we will auto change it .
                    ..bubbleTriangleDirection = CcBubbleArrowDirection.none,
                ),
                const SizedBox(height: 32),
                AnythingPicker(
                  title: 'AnythingPicker with auto position. (Scroll me up and down ~~~)',
                  values: _getStringsListValues(),
                  funcOfItemOnTapped: (state, index, value) {
                    return false;
                  },
                  options: AnythingPickerOptions()
                    ..contentHintText = ''
                    ..bubbleShadowColor = Colors.purpleAccent
                    // bubbleTriangleDirection: if you don't wanna an arrow set it to null. set it to none, we will auto change it .
                    ..bubbleTriangleDirection = null,
                ),
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

  Widget _bodyTips() {
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

  static List<String> _getStringsListValues() {
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

  static List<Employee> _getEmployeesListValues() {
    return [
      Employee('UI Manager', 'Koko.Lee'),
      Employee('Soft Manager', 'Oreoea.ss'),
      Employee('Device Manager', 'Cell.SU'),
      Employee('DB Manager', 'India.USA'),
      Employee('Computer Manager', 'Austria.Iv'),
      Employee('CPU Manager', 'Oppo.Chen'),
      Employee('CPU President', 'John.Trump'),
      Employee('CEO', 'John.Ceo'),
    ];
  }

  static List<Student> _getStudentsListValues() {
    return [
      Student(18, 'TheBoy'),
      Student(22, 'Lcuy'),
      Student(31, 'Cicie'),
      Student(22, 'Lukas'),
      Student(21, 'Isasie'),
      Student(31, 'QiCue'),
      Student(19, 'BaBee'),
    ];
  }
}

class Employee {
  String title;
  String name;

  Employee(this.title, this.name);
}

class Student {
  int age;
  String name;

  Student(this.age, this.name);
}
