import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

//ignore: must_be_immutable
class AnythingFielder extends StatefulWidget {
  String? title;

  String? value;

  /// false/null/none-implement for continue using the default behaviour
  Widget? Function(AnythingFielderState state)? builderOfTitle;
  void Function(AnythingFielderState state, BuildContext context)? funcOfTitleOnTapped;

  String? Function(AnythingFielderState state)? funcOfValue;
  Widget? Function(AnythingFielderState state)? builderOfContentInner;
  Widget? Function(AnythingFielderState state)? builderOfContentOuter;

  void Function(AnythingFielderState state)? funcOfEndClear;
  Widget? Function(AnythingFielderState state)? builderOfEndWidget;
  Widget? Function(AnythingFielderState state)? builderOfStartWidget;

  void Function(AnythingFielderState state)? onEventTextFocused;
  void Function(AnythingFielderState state, String text)? onEventTextChanged;

  /// disable edit and indicate the content using Text but not the EditableText widget
  bool? isEditable;

  /// show the loading icon at the end when the content end widget is null
  bool? isLoading;

  /// null will not occupy the space and do not display, true will display and occupy, false just occupying the space.
  bool? isRequired;

  /// all the element widget settings
  AnythingFielderOptions? options;

  AnythingFielder({
    Key? key,
    this.title,
    this.value,
    this.builderOfTitle,
    this.funcOfTitleOnTapped,
    this.funcOfValue,
    this.builderOfContentInner,
    this.builderOfContentOuter,
    this.funcOfEndClear,
    this.builderOfEndWidget,
    this.builderOfStartWidget,
    this.onEventTextFocused,
    this.onEventTextChanged,
    this.isEditable = true,
    this.isLoading = false,
    this.isRequired,
    this.options,
  }) : super(key: key);

  @override
  State<AnythingFielder> createState() => AnythingFielderState();
}

class AnythingFielderState extends State<AnythingFielder> {
  /// All the element widget settings
  AnythingFielderOptions? _options;

  AnythingFielderOptions get options => widget.options ?? (_options ??= AnythingFielderOptions());

  /// Handle the ui effect when is on focus
  Btv<bool> isFocused = false.btv;
  FocusNode focusNode = FocusNode();

  /// For keeping the previous text and its selection when setState call
  String? previousText;
  TextSelection? previousTextSelection;
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
      widget.onEventTextFocused?.call(this);
    });
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
    Widget builder = Builder(builder: (context) => _build(context));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [spaceHolder, Expanded(child: builder)],
    );
  }

  /// build title
  Widget? defaultTitleBuilder() {
    List<Widget> titleRowChildren = [];
    String? mTitle = widget.title;
    if (mTitle != null) {
      Widget getTextWidget() {
        Widget textView = Text(mTitle, style: options.titleStyle);
        var onTap = widget.funcOfTitleOnTapped;
        if (onTap != null) {
          /// Important!!! do not use result = Builder... for reusing the return statement, cause dart do a reference copy ...
          return Builder(builder: (context) => GestureDetector(onTap: () => onTap(this, context), child: textView));
        }
        return textView;
      }

      Widget titleWidget = getTextWidget();
      titleRowChildren.add(titleWidget);
    }

    /// title tails
    List<Widget>? titleTailWidgets = options.titleTailWidgets;
    if (titleTailWidgets != null) {
      titleRowChildren.addAll(titleTailWidgets);
    }
    return titleRowChildren.isNotEmpty ? Row(children: titleRowChildren) : null;
  }

  Widget _build(BuildContext context) {
    /// 1. title
    Widget? titleWidgetRow = widget.builderOfTitle?.call(this) ?? defaultTitleBuilder();

    /// 2. content
    List<Widget> contentRowInnerChildren = [];

    String? displayedText = widget.funcOfValue?.call(this) ?? widget.value;

    /// 2.0 content start view
    Widget? contentStartWidget = widget.builderOfStartWidget?.call(this) ?? options.contentStartWidget;

    /// 2.1 content end view
    bool isShouldShowEndClearIcon = false;
    Widget? contentEndWidget = widget.builderOfEndWidget?.call(this) ?? options.contentEndWidget;

    if (contentEndWidget == null && (widget.isEditable ?? true)) {
      if (widget.isLoading ?? false) {
        assert(options.contentLoadingIcon != null, 'Loading widget cannot be null when isLoading is true!');
        contentEndWidget = options.contentLoadingIcon!;
      } else if (widget.funcOfEndClear != null) {
        // if funcOfClear supplied, we offered the clear button
        isShouldShowEndClearIcon = true;
        if (displayedText != null && displayedText.isNotEmpty) {
          contentEndWidget = CcTapWidget(
            onTap: (state) {
              setState(() {
                widget.funcOfEndClear!.call(this);
                widget.value = null;

                previousText = null;
                previousTextSelection = null;
              });
            },
            child: options.contentClearIcon,
          );
        }
      }
    }

    /// 2.2 content center display view
    _setText(String text) {
      bool isSelectionWithinTextBounds(TextEditingController controller, TextSelection selection) {
        String text = controller.text;
        return selection.start <= text.length && selection.end <= text.length;
      }
      valueController.text = text;
      TextSelection selection = previousTextSelection ?? TextSelection.collapsed(offset: (valueController.text).length);
      if (isSelectionWithinTextBounds(valueController, selection)) {
        valueController.selection = selection;
      }
    }

    _setText(displayedText ?? '');
    previousText ??= displayedText;

    Widget? contentCenterWidget = widget.builderOfContentInner?.call(this);
    if (contentCenterWidget == null) {
      Widget displayedValueWidget;
      if (widget.isEditable ?? true) {
        displayedValueWidget = CupertinoTextField(
          focusNode: focusNode,
          controller: valueController,
          padding: options.textPadding,
          textAlign: options.textAlign,
          maxLines: options.maxLines,
          maxLength: options.maxLength,
          style: options.contentTextStyle,
          keyboardType: options.keyboardType,
          placeholder: options.contentHintText,
          placeholderStyle: options.contentHintStyle,
          inputFormatters: options.inputFormatters,
          decoration: isFocused.value ? options.inputDecorationFocused : options.inputDecorationNormal,
          onChanged: (String text) {
            // valueController.text already is text now ...

            // ---------- show out the clear icon ----------
            if (isShouldShowEndClearIcon) {
              String? pt = previousText;
              if ((pt == null || pt.isEmpty) && text.isNotEmpty || text.isEmpty && (pt != null && pt.isNotEmpty)) {
                setState(() {});
              }
            }
            // ---------- show out the clear icon ----------

            if (options.onEventTextChangedRaw?.call(this, text) ?? false) {
              previousText = text;
              return;
            }
            String newText = options.onEventTextChangedFilter?.call(this, text) ?? text;
            previousText = newText;

            if (text != newText) {
              _setText(newText);
            } else {
              previousTextSelection = valueController.selection;
            }
            widget.value = newText;
            widget.onEventTextChanged?.call(this, newText);
          },
        );
      } else {
        displayedValueWidget = Text(
          displayedText ?? '',
          maxLines: 1,
          style: options.contentTextStyle,
          overflow: TextOverflow.ellipsis,
        );
      }
      contentCenterWidget = Container(padding: options.contentPadding, child: displayedValueWidget);
    }

    // add start/center/end widget
    if (contentStartWidget != null) {
      contentRowInnerChildren.add(contentStartWidget);
    }
    contentRowInnerChildren.add(Expanded(child: contentCenterWidget));
    if (contentEndWidget != null) {
      contentRowInnerChildren.add(contentEndWidget);
    }

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

    /// 2.4 default is column for vertical
    if (options.isHorizontal == true) {
      return Row(
        children: [
          titleWidgetRow ?? const Offstage(offstage: true),
          Expanded(child: contentWidget),
        ],
      );
    } else {
      return Column(
        children: [
          titleWidgetRow ?? const Offstage(offstage: true),
          contentWidget,
        ],
      );
    }
  }
}

/// Anything Options/Configs Class
class AnythingFielderOptions {
  bool? isHorizontal;

  /// required icon
  Widget? requiredIcon = const Padding(
    padding: EdgeInsets.only(right: 4),
    child: Text('*', style: TextStyle(fontSize: 14, color: Color(0xFFFF616F))),
  );

  /// title widget
  TextStyle? titleStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1D21));
  List<Widget>? titleTailWidgets;

  /// content widget
  double? contentWidth;
  double? contentHeight;
  EdgeInsets? contentMargin;
  EdgeInsets? contentPadding = const EdgeInsets.only(top: 10, bottom: 10);
  BoxDecoration? contentDecorationNormal =
      const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECF2))));
  BoxDecoration? contentDecorationFocused =
      const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFF4275FF))));

  /// content text widget
  String? contentHintText = 'Enter';
  TextStyle? contentHintStyle = const TextStyle(fontSize: 16, color: Color(0xFFBFBFD2));
  TextStyle? contentTextStyle = const TextStyle(fontSize: 16, color: Color(0xFF1C1D21));

  /// content end widget
  Widget? contentStartWidget;
  Widget? contentEndWidget;
  Widget? contentArrowIcon = Transform(
    alignment: Alignment.center,
    transform: Matrix4.rotationZ(-90 / 180 * math.pi),
    child: const Icon(Icons.arrow_back_ios_rounded, size: 13, color: Color(0xFFBFBFD2)),
  );
  Widget? contentClearIcon = Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Container(
      width: 13,
      height: 13,
      child: const Icon(Icons.clear_rounded, color: Colors.white, size: 9),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.5)), color: Color(0xFFC2C7D4)),
    ),
  );
  Widget? contentLoadingIcon = const AnythingLoadingWidget(side: 18, stroke: 1.3);

  /// value field on [CupertinoTextField] properties
  int? maxLines;
  int maxLength = 0x0800000000000000;
  bool Function(AnythingFielderState state, String text)? onEventTextChangedRaw;
  String? Function(AnythingFielderState state, String text)? onEventTextChangedFilter;
  TextInputType? keyboardType;
  TextAlign textAlign = TextAlign.start;
  EdgeInsets textPadding = EdgeInsets.zero;
  List<TextInputFormatter>? inputFormatters;
  BoxDecoration? inputDecorationNormal;
  BoxDecoration? inputDecorationFocused;

  AnythingFielderOptions();

  AnythingFielderOptions clone() {
    AnythingFielderOptions newInstance = AnythingFielderOptions();

    newInstance.isHorizontal = isHorizontal;
    newInstance.requiredIcon = requiredIcon;

    newInstance.titleStyle = titleStyle;
    newInstance.titleTailWidgets = titleTailWidgets;

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

    newInstance.maxLines = maxLines;
    newInstance.maxLength = maxLength;
    newInstance.onEventTextChangedRaw = onEventTextChangedRaw;
    newInstance.onEventTextChangedFilter = onEventTextChangedFilter;
    newInstance.keyboardType = keyboardType;
    newInstance.textAlign = textAlign;
    newInstance.textPadding = textPadding;
    newInstance.inputFormatters = inputFormatters;
    newInstance.inputDecorationNormal = inputDecorationNormal;
    newInstance.inputDecorationFocused = inputDecorationFocused;

    return newInstance;
  }
}
