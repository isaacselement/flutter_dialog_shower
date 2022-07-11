import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

/// Anything Picker Class
//ignore: must_be_immutable
class AnythingPicker extends StatefulWidget {
  String? title;

  // false/null/none-implement for continue using the default behaviour
  void Function(AnythingPickerState state, BuildContext context)? funcOfTitleOnTapped;
  bool? Function(AnythingPickerState state, BuildContext context)? funcOfContentOnTapped;

  String? Function(AnythingPickerState state)? funcOfContent;
  Widget? Function(AnythingPickerState state)? builderOfContentInner;
  Widget? Function(AnythingPickerState state)? builderOfContentOuter;

  void Function(AnythingPickerState state)? funcOfEndClear;
  Widget? Function(AnythingPickerState state)? builderOfEndWidget;
  Widget? Function(AnythingPickerState state)? builderOfStartWidget;
  void Function(AnythingPickerState state, List<Widget> children)? builderOfContentChildren;

  List<dynamic>? values;
  FutureOr<List<dynamic>?> Function()? funcOfValues;

  dynamic selectedValue;
  List<dynamic>? selectedValues; // indicate that is multi-selection mode when it's not null
  List<dynamic>? disabledValues;

  // false/null/none-implement for continue using the default behaviour
  String? Function(AnythingPickerState state, int? index, dynamic object)? funcOfItemName;
  bool? Function(AnythingPickerState state, int index, dynamic object)? funcOfItemOnTapped;
  bool Function(AnythingPickerState state, dynamic element, dynamic e)? funcOfItemIsEqual;
  bool? Function(AnythingPickerState state, int index, dynamic object)? funcOfItemIfSelected;
  bool? Function(AnythingPickerState state, int index, dynamic object)? funcOfItemIfDisabled;

  Widget? Function(AnythingPickerState state, DialogShower shower, List<dynamic>? values)? builderOfPicker;

  Widget? Function(AnythingPickerState state, int index, dynamic object)? builderOfItemOuter;
  Widget? Function(AnythingPickerState state, int index, dynamic object)? builderOfItemInner;
  Widget? Function(AnythingPickerState state, int index, dynamic object, List<Widget> children)? builderOfItemChildren;

  void Function(AnythingPickerState state, DialogShower shower)? showerCallback;
  void Function(AnythingPickerState state, DialogShower shower)? showerShowedCallback;
  void Function(AnythingPickerState state, DialogShower shower)? showerDismissedCallback;

  bool? isDisable;
  bool? isLoading;
  bool? isRequired; // null will at leading, true will display, false just for occupied the place.
  AnythingPickerOptions? options;

  AnythingPicker({
    Key? key,
    this.title,
    this.funcOfTitleOnTapped,
    this.funcOfContentOnTapped,
    this.funcOfContent,
    this.builderOfContentInner,
    this.builderOfContentOuter,
    this.funcOfEndClear,
    this.builderOfEndWidget,
    this.builderOfStartWidget,
    this.builderOfContentChildren,
    this.values,
    this.funcOfValues,
    this.selectedValue,
    this.selectedValues,
    this.disabledValues,
    this.funcOfItemName,
    this.funcOfItemOnTapped,
    this.funcOfItemIsEqual,
    this.funcOfItemIfSelected,
    this.funcOfItemIfDisabled,
    this.builderOfPicker,
    this.builderOfItemOuter,
    this.builderOfItemInner,
    this.builderOfItemChildren,
    this.showerCallback,
    this.showerShowedCallback,
    this.showerDismissedCallback,
    this.isDisable = false,
    this.isLoading = false,
    this.isRequired,
    this.options,
  }) : super(key: key);

  @override
  State<AnythingPicker> createState() => AnythingPickerState();
}

class AnythingPickerState extends State<AnythingPicker> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  AnythingPickerOptions? _options;

  AnythingPickerOptions get options => widget.options ?? (_options ??= AnythingPickerOptions());

  Btv<bool> isFocused = false.btv;

  Btv<bool> isItemTapping = false.btv;

  DialogShower? mShower;

  // GlobalKey mPickerKey = GlobalKey();
  StateSetter? setStateOfPicker;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? requiredWidget;
    if (widget.isRequired != null) {
      assert(options.requiredIcon != null, 'Required widget cannot be null when isRequired is true!');
      requiredWidget = options.requiredIcon;
    }
    if (requiredWidget == null) {
      return _build(context);
    }
    bool isRequired = widget.isRequired!;
    Widget spaceHolder = requiredWidget;
    if (!isRequired) {
      spaceHolder = Opacity(opacity: 0, child: requiredWidget);
    }

    // wrapped with a builder, automatically getting width for the picker
    Widget builder = Builder(
      builder: (context) {
        return _build(context);
      },
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spaceHolder,
        Expanded(child: builder),
      ],
    );
  }

  Widget _build(BuildContext context) {
    List<Widget> allWholeColumnChildren = [];

    /// 1. title
    List<Widget> titleRowChildren = [];

    if (widget.title != null) {
      titleRowChildren.add(Text(widget.title!, style: options.titleStyle));
    }
    if (options.titleEndIcon != null) {
      titleRowChildren.add(options.titleEndIcon!);
    }

    Row? titleRow = titleRowChildren.isNotEmpty ? Row(children: titleRowChildren) : null;

    Widget? titleWidget;
    if (widget.funcOfTitleOnTapped != null) {
      titleWidget = Builder(builder: (context) {
        return InkWell(
            child: titleRow,
            onTap: () {
              widget.funcOfTitleOnTapped?.call(this, context);
            });
      });
    } else {
      titleWidget = titleRow;
    }
    if (titleWidget != null) {
      allWholeColumnChildren.add(titleWidget);
    }

    /// 2. content
    List<Widget> contentRowInnerChildren = [];

    /// 2.0 content start view
    Widget? contentStartWidget = widget.builderOfStartWidget?.call(this) ?? options.contentStartWidget;
    if (contentStartWidget != null) {
      contentRowInnerChildren.add(contentStartWidget);
    }

    /// 2.1 content display view
    String? displayedText = widget.funcOfContent?.call(this);
    if (displayedText == null) {
      if (widget.funcOfItemName != null) {
        if (widget.selectedValues != null) {
          displayedText = widget.selectedValues!.map((e) => widget.funcOfItemName!.call(this, null, e)).toList().join('; ');
          displayedText = displayedText.isNotEmpty ? displayedText : null;
        } else if (widget.selectedValue != null) {
          displayedText = widget.funcOfItemName!.call(this, null, widget.selectedValue!);
        }
      }
    }
    Widget? contentCenterWidget = widget.builderOfContentInner?.call(this);
    if (contentCenterWidget == null) {
      String text = displayedText ?? options.contentHintText;
      TextStyle? style = displayedText != null ? options.contentTextStyle : options.contentHintStyle;
      Text displayedValueWidget = Text(
        text,
        maxLines: 1,
        style: style,
        overflow: TextOverflow.ellipsis,
      );
      contentCenterWidget = Container(
        padding: options.contentPadding,
        child: displayedValueWidget,
      );
    }
    contentRowInnerChildren.add(Expanded(child: contentCenterWidget));

    /// 2.2 content end view
    Widget? contentEndWidget;
    if (widget.builderOfEndWidget != null) {
      contentEndWidget = widget.builderOfEndWidget?.call(this);
    } else {
      contentEndWidget = options.contentEndWidget;

      // default end widget
      if (!(widget.isDisable ?? false) && contentEndWidget == null) {
        if (widget.isLoading ?? false) {
          assert(options.contentLoadingIcon != null, 'Loading widget cannot be null when isLoading is true!');
          contentEndWidget = options.contentLoadingIcon!;
        } else if (displayedText != null && displayedText.isNotEmpty && widget.funcOfEndClear != null) {
          // if funcOfClear supplied, we offered the clear button
          contentEndWidget = CcTapWidget(
            onTap: (state) {
              setState(() {
                widget.funcOfEndClear!.call(this);
                widget.selectedValue = null;
                widget.selectedValues?.clear();
              });
            },
            child: options.contentClearIcon,
          );
        } else {
          contentEndWidget = RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(animationController!),
            child: options.contentArrowIcon,
          );
        }
      }
    }

    if (contentEndWidget != null) {
      contentRowInnerChildren.add(contentEndWidget);
    }

    widget.builderOfContentChildren?.call(this, contentRowInnerChildren);

    /// 2.3 content container & border wrapped all elements view
    Widget contentWidget = widget.builderOfContentOuter?.call(this) ??
        Btw(
          builder: (context) {
            return Container(
              width: options.contentWidth,
              height: options.contentHeight,
              margin: options.contentMargin,
              // padding: options.contentPadding,
              decoration: isFocused.value ? options.contentDecorationFocused : options.contentDecorationNormal,
              child: Row(
                children: contentRowInnerChildren,
              ),
            );
          },
        );

    onTap() {
      if (widget.funcOfContentOnTapped?.call(this, context) ?? false) {
        // return true do nothing ...
      } else {
        // return false or null or not implement do the default behaviour ...
        DialogShower shower = onEventShowPicker(context);
        mShower = shower;
        widget.showerCallback?.call(this, shower);
        shower.addShowCallBack((shower) {
          widget.showerShowedCallback?.call(this, shower);
        });
        shower.addDismissCallBack((shower) {
          widget.showerDismissedCallback?.call(this, shower);
        });
      }
    }

    Widget contentOnTapWidget = InkWell(onTap: widget.isDisable ?? false ? null : onTap, child: contentWidget);

    allWholeColumnChildren.add(contentOnTapWidget);

    return Column(children: allWholeColumnChildren);
  }

  DialogShower onEventShowPicker(BuildContext context) {
    // wrap content widget x,y,w,h to a rect
    RenderBox box = context.findRenderObject()! as RenderBox;
    Size size = box.size;
    double w = size.width;
    double h = size.height;
    Offset position = box.localToGlobal(Offset.zero);
    double x = position.dx;
    double y = position.dy;
    Rect rect = Rect.fromLTWH(x, y, w, h);

    double? width = w;
    double? height = 100;

    // set a default max height to picker when is show on top
    if (options.stickToSide == AnythingPickerStickTo.top) {
      options.pickerMaxHeight ??= y;
    }

    Widget _wrapWithBubble(DialogShower shower, Widget child) {
      if (options.bubbleTriangleDirection == CcBubbleArrowDirection.none) {
        return child;
      }
      shower.containerDecoration = null;
      return CcBubbleWidget(
        bubbleShadowColor: options.bubbleShadowColor,
        bubbleShadowRadius: options.bubbleShadowRadius,
        bubbleTriangleDirection: options.bubbleTriangleDirection,
        bubbleColor: options.bubbleColor,
        bubbleRadius: options.bubbleRadius,
        bubbleTriangleLength: options.bubbleTriangleLength,
        isTriangleOccupiedSpace: options.isTriangleOccupiedSpace,
        bubbleTrianglePointOffset: options.bubbleTrianglePointOffset,
        bubbleTriangleTranslation: options.bubbleTriangleTranslation,
        child: child,
      );
    }

    // show the indicator
    double showerWidth = options.pickerWidth ?? math.min(options.pickerMaxWidth ?? width, width);
    double showerHeight = options.pickerHeight ?? math.min(options.pickerMaxHeight ?? height, height);
    DialogShower shower = DialogShower();
    shower.x = x + (options.pickerShowOffsetX ?? 0);
    shower.y = _getOnBottomSideShowerY(rect); // default load indicator on bottom for AUTO ...
    shower.width = showerWidth;
    shower.height = showerHeight;
    _refreshShowerY(options, shower, rect);
    shower.alignment = Alignment.topLeft;
    Widget indicator = const CupertinoActivityIndicator();
    indicator = _wrapWithBubble(shower, indicator);

    // OverlayWidgets.showWithLayerLink(child: indicator, width: showerWidth, layerLink: _layerLink);

    DialogWrapper.showWith(shower, indicator);
    shower
      ..barrierDismissible = true
      ..transitionBuilder = null
      ..addShowCallBack((shower) {
        animationController?.forward();
        isFocused.value = true;
      })
      ..addDismissCallBack((shower) {
        animationController?.reverse();
        isFocused.value = false;
      });

    // show the picker list after values returned
    () async {
      List? items = await widget.funcOfValues?.call() ?? widget.values;

      Widget picker = StatefulBuilder(
          // key: mPickerKey,
          builder: (BuildContext context, StateSetter setState) {
        setStateOfPicker = setState;
        return widget.builderOfPicker?.call(this, shower, items) ?? getValuesPicker(items);
      });

      if (options.pickerHeight == null) {
        // Label A: auto deciding height
        shower.height = null;
        if (options.stickToSide == AnythingPickerStickTo.top || options.stickToSide == AnythingPickerStickTo.auto) {
          shower.y = (options.pickerMarginScreenTop ?? 0);
        }
      }

      shower.builder = (shower) {
        // Label B: height determined
        if (shower.height != null) {
          return _wrapWithBubble(shower, picker);
        }
        // Label A: auto deciding height
        Size screenSize = MediaQuery.of(DialogShower.gContext!).size;
        double screenHeight = screenSize.height;
        // double screenWidth = screenSize.width;
        return Offstage(
          offstage: true,
          child: GetSizeWidget(
            child: picker,
            onLayoutChanged: (RenderBox box, Size? legacy, Size size) {
              console(() => '[AnythingPicker] onLayoutChanged width: ${size.width}, height: ${size.height}, y: ${shower.y}');

              // Label B: height determined
              shower.height = math.min(options.pickerMaxHeight ?? size.height, size.height);
              _refreshShowerY(options, shower, rect);

              double remainSpaceBottom() {
                double bottomY = _getOnBottomSideShowerY(rect);
                return screenHeight - bottomY - (options.pickerMarginScreenBottom ?? 0);
              }

              double remainSpaceTop() {
                double topY = rect.top - (options.pickerShowOffsetY ?? 0);
                return topY - (options.pickerMarginScreenTop ?? 0);
              }

              double overflowBottom() {
                double overflowB = shower.height! - remainSpaceBottom();
                return overflowB;
              }

              double overflowTop() {
                double overflowT = shower.height! - remainSpaceTop();
                return overflowT;
              }

              AnythingPickerOptions _op = options;
              if (_op.stickToSide == AnythingPickerStickTo.auto) {
                _op = options.clone();
                double _heightBak = shower.height!;

                // -------------------- auto determined the height & the direction --------------------
                // if overflow on BOTTOM or TOP, reduce the height. Then will break when BOTTOM or TOP (one of them) not overflow
                double overflowB = 0;
                double overflowT = 0;
                double notOverflowHeightB = 0;
                double notOverflowHeightT = 0;

                while ((overflowB = overflowBottom()) > 0) {
                  shower.height = shower.height! - 10;
                }
                notOverflowHeightB = shower.height!;
                shower.height = _heightBak;
                while ((overflowT = overflowTop()) > 0) {
                  shower.height = shower.height! - 10;
                }
                notOverflowHeightT = shower.height!;
                shower.height = _heightBak;

                // if left height in bottom less then two-thirds of left height in top, use TOP preferred
                bool isTopHasMoreSpace = remainSpaceBottom() < remainSpaceTop() / 3 * 2;
                if (isTopHasMoreSpace) {
                  shower.height = notOverflowHeightT;
                  _op.stickToSide = AnythingPickerStickTo.top;
                } else {
                  shower.height = notOverflowHeightB;
                  _op.stickToSide = AnythingPickerStickTo.bottom;
                }
                console(() => '[AnythingPicker] determined shower height: ${shower.height}, y: ${shower.y}, stick: ${_op.stickToSide}');

                // -------------------- calculate again for support min height --------------------
                if (_op.pickerMinHeight != null) {
                  double revisionismHeight = math.max(_op.pickerMinHeight ?? 0, shower.height!);
                  if (shower.height != revisionismHeight) {
                    double _heightBackup = shower.height!;
                    shower.height = revisionismHeight;
                    overflowB = overflowBottom();
                    overflowT = overflowTop();
                    if (overflowB > 0 && overflowT > 0) {
                      assert(() {
                        console(() =>
                            '[AnythingPicker] ❗️❗️❗️the picker mini height is too large for none of direction have enough space!!!');
                        return true;
                      }());
                      shower.height = _heightBackup;
                    }
                    if (_op.stickToSide == AnythingPickerStickTo.bottom && overflowB > 0) {
                      _op.stickToSide = AnythingPickerStickTo.top;
                    }
                    if (_op.stickToSide == AnythingPickerStickTo.top && overflowT > 0) {
                      _op.stickToSide = AnythingPickerStickTo.bottom;
                    }
                  }
                  console(() => '[AnythingPicker] Mini shower height ${shower.height}, y: ${shower.y}, stickToSide: ${_op.stickToSide}');
                }
              }

              // -------------------- calculate height by specified direction --------------------
              if (_op.stickToSide == AnythingPickerStickTo.bottom && _op.pickerMarginScreenBottom != null) {
                double overflowB = overflowBottom();
                if (overflowB > 0) {
                  shower.height = shower.height! - overflowB;
                }
              } else if (_op.stickToSide == AnythingPickerStickTo.top && _op.pickerMarginScreenTop != null) {
                double overflowT = overflowTop();
                if (overflowT > 0) {
                  shower.height = shower.height! - overflowT;
                }
              }
              _refreshShowerY(_op, shower, rect);

              console(() => '[AnythingPicker] finally shower height: ${shower.height}, y: ${shower.y}, stickToSide: ${_op.stickToSide}');

              shower.setState();
            },
          ),
        );
      };

      shower.setState();
    }();
    return shower;
  }

  void _refreshShowerY(AnythingPickerOptions options, DialogShower shower, Rect rect) {
    if (options.stickToSide == AnythingPickerStickTo.bottom) {
      shower.y = _getOnBottomSideShowerY(rect);
    } else if (options.stickToSide == AnythingPickerStickTo.top) {
      shower.y = _getOnTopSideShowerY(shower, rect);
    }
  }

  double _getOnBottomSideShowerY(Rect rect) {
    return rect.top + rect.height + (options.pickerShowOffsetY ?? 0);
  }

  double _getOnTopSideShowerY(DialogShower shower, Rect rect) {
    return rect.top - (shower.height ?? 0) - (options.pickerShowOffsetY ?? 0);
  }

  Widget getValuesPicker(List? items) {
    bool? isContains(List<dynamic>? list, dynamic element) {
      if (list == null) {
        return null;
      }
      if (widget.funcOfItemIsEqual != null) {
        for (dynamic e in list) {
          if (widget.funcOfItemIsEqual?.call(this, element, e) ?? false) {
            return true;
          }
        }
      }
      return list.contains(element);
    }

    bool fnIsSelected(i, e) =>
        widget.funcOfItemIfSelected?.call(this, i, e) ?? isContains(widget.selectedValues, e) ?? widget.selectedValue == e;
    bool fnIsDisabled(i, e) => widget.funcOfItemIfDisabled?.call(this, i, e) ?? isContains(widget.disabledValues, e) ?? false;

    int length = items?.length ?? 0;
    List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      dynamic e = items!.elementAt(i);
      String itemName = widget.funcOfItemName?.call(this, i, e) ?? e.toString();

      _itemOnTap() {
        bool isItemSelected = fnIsSelected(i, e);
        bool isItemDisabled = fnIsDisabled(i, e);

        if (isItemDisabled) {
          return;
        }
        if (widget.funcOfItemOnTapped?.call(this, i, e) ?? false) {
          // handle by caller already if return true
        } else {
          // handle by default if return false or null
          if (widget.selectedValues != null) {
            // Multi-choice. Note: if funcOfItemOnTapped call and return false, u should ensure that selectedValues changed is correct
            isItemSelected ? widget.selectedValues?.remove(e) : widget.selectedValues?.add(e);
          } else {
            // Single-selection. Dismiss by default
            widget.selectedValue = e;
            DialogWrapper.dismissTopDialog();
          }
        }
        // update whole display content widget
        setState(() {});
      }

      _itemBuilder() {
        bool isItemSelected = fnIsSelected(i, e);
        bool isItemDisabled = fnIsDisabled(i, e);

        List<Widget> children = [];

        // prefix
        if (options.itemPrefixWidget != null) {
          children.add(options.itemPrefixWidget!);
        }

        // 1. text widget
        TextStyle? itemNameStyle = options.itemStyleNormal;
        if (isItemSelected) {
          itemNameStyle = options.itemStyleSelected;
        } else if (isItemDisabled) {
          itemNameStyle = options.itemStyleDisabled;
        }
        Widget itemTextWidget = Expanded(
          child: Text(
            itemName,
            style: itemNameStyle,
          ),
        );
        children.add(itemTextWidget);

        // 2. checkbox widget
        if (widget.selectedValues != null) {
          Widget itemCheckedWidget = Offstage(
            offstage: !isItemSelected,
            child: options.itemCheckedWidget,
          );
          children.add(itemCheckedWidget);
        }

        // suffix
        if (options.itemSuffixWidget != null) {
          children.add(options.itemSuffixWidget!);
        }

        widget.builderOfItemChildren?.call(this, i, e, children);

        // 3. item container
        Decoration? decoration = options.itemDecorationNormal;
        if (isItemDisabled) {
          decoration = options.itemDecorationDisabled;
        } else if (isItemTapping.value) {
          decoration = options.itemDecorationTapped;
        }
        return Container(
          width: options.itemWidth,
          height: options.itemHeight,
          margin: options.itemMargin,
          padding: options.itemPadding,
          alignment: options.itemAlignment,
          decoration: decoration,
          child: Row(
            children: children,
          ),
        );
      }

      _itemBuilderWrap() {
        return widget.builderOfItemInner?.call(this, i, e) ?? _itemBuilder();
      }

      Widget item = widget.builderOfItemOuter?.call(this, i, e) ??
          CcTapWidget(
            onTap: (state) {
              _itemOnTap();
            },
            builder: (state) {
              isItemTapping.value = (state as CcTapWidgetState).isTapingDown;
              return _itemBuilderWrap();
            },
          );

      children.add(item);
    }

    if (children.isEmpty) {
      return options.itemNoDataWidget;
    }
    return ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: children);
  }

  static void console(String Function() expr) {
    assert(() {
      if (kDebugMode) {
        print(expr());
      }
      return true;
    }());
  }
}

/// Widget Loading Class
class AnythingLoadingWidget extends StatelessWidget {
  final double side;
  final double stroke;

  const AnythingLoadingWidget({Key? key, required this.side, required this.stroke}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotateWidget(
      child: CustomPaint(
        painter: LoadingIconPainter(
          radius: side / 2,
          strokeWidth: stroke,
          colorSmall: Colors.black,
          startAngleBig: 0,
          sweepAngleBig: 2 * math.pi / 3 * 2,
          startAngleSmall: 2 * math.pi / 3 * 2,
          sweepAngleSmall: 2 * math.pi / 3 * 1,
        ),
        child: SizedBox(width: side, height: side),
      ),
    );
  }
}

enum AnythingPickerStickTo { auto, top, bottom }

/// Anything Picker Options/Configs Class
class AnythingPickerOptions {
  CcBubbleArrowDirection bubbleTriangleDirection = CcBubbleArrowDirection.none;
  bool isTriangleOccupiedSpace = true;
  Color? bubbleColor;
  double bubbleRadius = 8.0;
  double bubbleShadowRadius = 100;
  Color? bubbleShadowColor = Colors.grey.withAlpha(128);
  double? bubbleTriangleLength;
  Offset? bubbleTrianglePointOffset;
  double? bubbleTriangleTranslation;

  Widget? requiredIcon = const Padding(
    padding: EdgeInsets.only(right: 4),
    child: Text('*', style: TextStyle(fontSize: 14, color: Color(0xFFFF616F))),
  );

  // title widget
  TextStyle? titleStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1D21));
  Widget? titleEndIcon;

  // content widget
  double? contentWidth;
  double? contentHeight;
  EdgeInsets? contentMargin;
  EdgeInsets? contentPadding = const EdgeInsets.only(top: 10, bottom: 10);
  BoxDecoration? contentDecorationNormal = const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))));
  BoxDecoration? contentDecorationFocused = const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFF4275FF))));

  // content text widget
  String contentHintText = 'Select';
  TextStyle? contentHintStyle = const TextStyle(fontSize: 16, color: Color(0xFFBFBFD2));
  TextStyle? contentTextStyle = const TextStyle(fontSize: 16, color: Color(0xFF1C1D21));

  // content end widget
  Widget? contentStartWidget;
  Widget? contentEndWidget;
  Widget? contentArrowIcon = Transform(
    alignment: Alignment.center,
    transform: Matrix4.rotationZ(-90 / 180 * math.pi),
    child: const Icon(Icons.arrow_back_ios_rounded, size: 13, color: Color(0xFFBFBFD2)),
  );
  Widget? contentClearIcon = Container(
    color: Colors.transparent,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 6, left: 14, top: 10, bottom: 10),
    child: Container(
      width: 13,
      height: 13,
      child: const Icon(Icons.clear_rounded, color: Colors.white, size: 9),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.5)), color: Color(0xFFC2C7D4)),
    ),
  );
  Widget? contentLoadingIcon = const AnythingLoadingWidget(side: 18, stroke: 1.3);

  // picker and its items
  AnythingPickerStickTo stickToSide = AnythingPickerStickTo.auto;
  double? pickerMarginScreenTop = 25;
  double? pickerMarginScreenBottom = 25;

  double? pickerWidth;
  double? pickerHeight;
  double? pickerMaxWidth;
  double? pickerMaxHeight;
  double? pickerMinWidth;
  double? pickerMinHeight;
  double? pickerShowOffsetX;
  double? pickerShowOffsetY = 5;

  double? itemWidth;
  double? itemHeight;
  EdgeInsets? itemMargin;
  EdgeInsets? itemPadding = const EdgeInsets.all(16);
  Alignment? itemAlignment;
  Decoration? itemDecorationNormal = const BoxDecoration(color: Color(0xFFFFFFFF));
  Decoration? itemDecorationTapped = const BoxDecoration(color: Color(0xFFE0E0E0));
  Decoration? itemDecorationDisabled;

  TextStyle? itemStyleNormal = const TextStyle(fontSize: 16, color: Color(0xFF1C1D21));
  TextStyle? itemStyleSelected = const TextStyle(fontSize: 16, color: Color(0xFF5E81F4));
  TextStyle? itemStyleDisabled = const TextStyle(fontSize: 16, color: Color(0xFFBDBDBD));

  Widget? itemPrefixWidget;

  Widget? itemSuffixWidget;

  Widget? itemCheckedWidget = const Icon(Icons.check, size: 18, color: Color(0xFF4275FF));
  Widget itemNoDataWidget = const SizedBox(height: 100, child: Center(child: Text('No data', style: TextStyle(color: Colors.grey))));

  AnythingPickerOptions();

  AnythingPickerOptions clone() {
    AnythingPickerOptions newInstance = AnythingPickerOptions();

    newInstance.bubbleTriangleDirection = bubbleTriangleDirection;
    newInstance.isTriangleOccupiedSpace = isTriangleOccupiedSpace;
    newInstance.bubbleColor = bubbleColor;
    newInstance.bubbleRadius = bubbleRadius;
    newInstance.bubbleShadowRadius = bubbleShadowRadius;
    newInstance.bubbleShadowColor = bubbleShadowColor;
    newInstance.bubbleTriangleLength = bubbleTriangleLength;
    newInstance.bubbleTrianglePointOffset = bubbleTrianglePointOffset;
    newInstance.bubbleTriangleTranslation = bubbleTriangleTranslation;

    newInstance.requiredIcon = requiredIcon;

    newInstance.titleStyle = titleStyle;
    newInstance.titleEndIcon = titleEndIcon;

    newInstance.contentWidth = contentWidth;
    newInstance.contentHeight = contentHeight;
    newInstance.contentMargin = contentMargin;
    newInstance.contentPadding = contentPadding;
    newInstance.contentDecorationNormal = contentDecorationNormal;
    newInstance.contentDecorationFocused = contentDecorationFocused;

    newInstance.contentHintText = contentHintText;
    newInstance.contentHintStyle = contentHintStyle;
    newInstance.contentTextStyle = contentTextStyle;

    newInstance.contentStartWidget = contentStartWidget;
    newInstance.contentEndWidget = contentEndWidget;
    newInstance.contentArrowIcon = contentArrowIcon;
    newInstance.contentClearIcon = contentClearIcon;
    newInstance.contentLoadingIcon = contentLoadingIcon;

    newInstance.stickToSide = stickToSide;
    newInstance.pickerMarginScreenTop = pickerMarginScreenTop;
    newInstance.pickerMarginScreenBottom = pickerMarginScreenBottom;

    newInstance.pickerWidth = pickerWidth;
    newInstance.pickerHeight = pickerHeight;
    newInstance.pickerMaxWidth = pickerMaxWidth;
    newInstance.pickerMaxHeight = pickerMaxHeight;
    newInstance.pickerMinWidth = pickerMinWidth;
    newInstance.pickerMinHeight = pickerMinHeight;
    newInstance.pickerShowOffsetX = pickerShowOffsetX;
    newInstance.pickerShowOffsetY = pickerShowOffsetY;

    newInstance.itemWidth = itemWidth;
    newInstance.itemHeight = itemHeight;
    newInstance.itemMargin = itemMargin;
    newInstance.itemPadding = itemPadding;
    newInstance.itemAlignment = itemAlignment;
    newInstance.itemDecorationNormal = itemDecorationNormal;
    newInstance.itemDecorationTapped = itemDecorationTapped;
    newInstance.itemDecorationDisabled = itemDecorationDisabled;

    newInstance.itemStyleNormal = itemStyleNormal;
    newInstance.itemStyleSelected = itemStyleSelected;
    newInstance.itemStyleDisabled = itemStyleDisabled;

    newInstance.itemPrefixWidget = itemPrefixWidget;
    newInstance.itemSuffixWidget = itemSuffixWidget;
    newInstance.itemCheckedWidget = itemCheckedWidget;
    newInstance.itemNoDataWidget = itemNoDataWidget;
    return newInstance;
  }
}
