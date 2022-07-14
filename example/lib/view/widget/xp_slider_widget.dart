import 'package:example/util/toast_util.dart';
import 'package:example/view/widget/xp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class XpSliderWidget extends StatelessWidget {
  XpSliderWidget({Key? key}) : super(key: key);

  Btv<bool> isResetButtonDisable = true.btv;
  Btv<String> selectCountryValue = ''.btv;

  @override
  Widget build(BuildContext context) {
    List<dynamic> selectedValues = [];
    return Column(
      children: [
        const SizedBox(height: 32),
        AnythingHeader(
          title: 'LayerLinker',
          options: AnythingHeaderOptions()
            ..leftBuilder = () {
              return XpTextButton(
                'Back',
                width: 200,
                height: 50,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                borderColor: const Color(0xFFDADAE8),
                backgroundColor: Colors.redAccent,
                textStyleBuilder: (text, isTappingDown) {
                  Color color = Colors.white;
                  color = isTappingDown ? color.withAlpha(128) : color;
                  return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
                },
                onPressed: (state) {
                  DialogWrapper.dismissTopDialog();
                },
              );
            }
            ..rightBuilder = () {
              return XpTextButton(
                'Done',
                width: 200,
                height: 54,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                borderColor: const Color(0xFFDADAE8),
                backgroundColor: Colors.lightBlue,
                textStyleBuilder: (text, isTappingDown) {
                  Color color = Colors.white;
                  color = isTappingDown ? color.withAlpha(128) : color;
                  return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold);
                },
                onPressed: (state) {
                  isResetButtonDisable.value = !isResetButtonDisable.value;
                },
              );
            },
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
            child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      CcTapWidget(
                        onTap: (state) {
                          Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizesUtil.getSizeS(state) ?? Size.zero;
                          ToastUtil.showWithArrow(
                            'You know that ~~~~~~~~~~~~\n HahuaHuHuaHaHua~~~~~~~ \n I don\'t know that !',
                            x: position.dx + size.width,
                            y: position.dy - 25,
                          );
                        },
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                      ),
                      AnythingPicker(
                        values: const [
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
                        ],
                        funcOfItemOnTapped: (state, index, value) {
                          selectCountryValue.value = value as String;
                          return false;
                        },
                      ),
                      const SizedBox(height: 32),
                      AnythingPicker(
                        funcOfValues: () async {
                          await Future.delayed(const Duration(milliseconds: 1000));
                          return [
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
                        },
                        funcOfItemOnTapped: (state, index, value) {
                          selectCountryValue.value = value as String;
                          return false;
                        },
                        selectedValues: selectedValues,
                      ),
                      const SizedBox(height: 32),
                      AnythingPicker(
                        funcOfValues: () {
                          return [
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
                        },
                        funcOfItemOnTapped: (state, index, value) {
                          selectCountryValue.value = value as String;
                          return false;
                        },
                      ),
                      const SizedBox(height: 150),
                      getOneSelectWidget(
                        title: 'Country: ',
                        btValue: selectCountryValue,
                        onTap: (state) {
                          Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizesUtil.getSizeS(state) ?? Size.zero;
                          DialogWrapper.show(
                            CcBubbleWidget(
                              bubbleTriangleTranslation: 20.0,
                              bubbleTriangleDirection: CcBubbleArrowDirection.top,
                              child: AnythingPicker(
                                funcOfValues: () async {
                                  await Future.delayed(const Duration(milliseconds: 2000));
                                  return [
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
                                },
                                funcOfItemOnTapped: (state, index, value) {
                                  selectCountryValue.value = value as String;
                                  return false;
                                },
                              ),
                            ),
                            x: position.dx,
                            y: position.dy + size.height + 5,
                            width: size.width,
                            height: size.width,
                          )
                            // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                            ..containerDecoration = null // BubbleWidget already has the shadow
                            ..transitionBuilder = null
                            ..barrierDismissible = true;
                        },
                      ),
                      const SizedBox(height: 300),
                      getOneSelectWidget(
                        title: 'Country: ',
                        btValue: selectCountryValue,
                        onTap: (state) {
                          Offset position = OffsetsUtil.getOffsetS(state) ?? Offset.zero;
                          Size size = SizesUtil.getSizeS(state) ?? Size.zero;
                          DialogWrapper.show(
                            CcBubbleWidget(
                              bubbleTriangleTranslation: size.width - 40,
                              bubbleTriangleDirection: CcBubbleArrowDirection.bottom,
                              child: AnythingSelector(
                                values: const [
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
                                ],
                                funcOfItemOnTapped: (state, index, value) {
                                  selectCountryValue.value = value as String;
                                  return false;
                                },
                              ),
                            ),
                            x: position.dx,
                            y: position.dy - size.width - 5,
                            width: size.width,
                            height: size.width,
                          )
                            // ..containerClipBehavior = Clip.none;  // will set null internal whern containerDecoration is null
                            ..containerDecoration = null // BubbleWidget already has the shadow
                            ..transitionBuilder = null
                            ..barrierDismissible = true;
                        },
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  Btw(builder: (context) {
                    return XpTextButton(
                      'Reset',
                      width: 200,
                      height: 40,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
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
                  const SizedBox(width: 14),
                  XpTextButton(
                    'Save',
                    width: 200,
                    height: 40,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
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
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget getOneSelectWidget({required String title, required Btv<String> btValue, required void Function(State state) onTap}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CcTapWidget(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Btw(
                      builder: (context) => Text(
                        btValue.value.isEmpty ? 'Select' : btValue.value,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  const Icon(Icons.select_all)
                ],
              ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
