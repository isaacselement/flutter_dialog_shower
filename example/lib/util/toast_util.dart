import 'package:flutter/material.dart';
import 'package:flutter_dialog_shower/flutter_dialog_shower.dart';

class ToastUtil {
  static OverlayShower show(
    String msg, {
    bool isStateful = false,
    Duration? duration = const Duration(milliseconds: 3000),
  }) {
    return OverlayWidgets.showToast(msg, isStateful: isStateful, onScreenDuration: duration, shadow: const BoxShadow())
      ..alignment = Alignment.topCenter
      ..margin = const EdgeInsets.only(top: 50);
  }

  static OverlayShower showWithArrow(
    String text, {
    required double x,
    required double y,
    double? width,
    double? height,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    Duration? onScreenDuration = const Duration(milliseconds: 2000),
  }) {
    return OverlayWidgets.show(
      onScreenDuration: onScreenDuration,
      child: getBubbleTipsWidget(
        text: text,
        width: width,
        height: height,
        direction: direction,
        bubbleTriangleTranslation: bubbleTriangleTranslation,
      ),
    )
      ..alignment = Alignment.topLeft
      ..padding = EdgeInsets.only(left: x, top: y);
  }

  static OverlayShower showWithArrowSticky(
    String text, {
    required double width,
    required LayerLink layerLink,
    Offset? offset,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    Duration? onScreenDuration = const Duration(milliseconds: 2000),
  }) {
    OverlayShower shower = OverlayWidgets.showWithLayerLink(
      child: getBubbleTipsWidget(
        text: text,
        direction: direction,
        bubbleTriangleTranslation: bubbleTriangleTranslation,
      ),
      width: width,
      offset: offset,
      layerLink: layerLink,
    );
    if (onScreenDuration != null) {
      Future.delayed(onScreenDuration, () {
        OverlayWrapper.dismissLayer(shower);
      });
    }
    return shower;
  }

  static DialogShower showDialogToast(
    String text, {
    required double x,
    required double y,
    double? width,
    double? height,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    Duration? onScreenDuration = const Duration(milliseconds: 3000),
  }) {
    DialogShower shower = DialogWrapper.show(
      getBubbleTipsWidget(
        text: text,
        width: width,
        height: height,
        direction: direction,
        bubbleTriangleTranslation: bubbleTriangleTranslation,
      ),
    )
      ..padding = EdgeInsets.only(left: x, top: y)
      ..alignment = Alignment.topLeft
      ..transitionBuilder = null
      ..barrierDismissible = true
      ..containerBackgroundColor = null
      ..dialogOnTapCallback = (shower, point) {
        DialogWrapper.dismissDialog(shower);
        return true;
      };
    if (onScreenDuration != null) {
      Future.delayed(onScreenDuration, () {
        DialogWrapper.dismissDialog(shower);
      });
    }
    return shower;
  }

  /// common toast bubble widget
  static Widget getBubbleTipsWidget({
    required String text,
    // text properties
    TextAlign? textAlign = TextAlign.left,
    TextStyle? textStyle = const TextStyle(color: Colors.white),
    // bubble properties
    Color? bubbleColor,
    double? bubbleRadius,
    Color? bubbleShadowColor,
    double? bubbleTriangleLength,
    double? bubbleTriangleTranslation,
    CcBubbleArrowDirection direction = CcBubbleArrowDirection.left,
    // container properties
    double? width,
    double? height,
    EdgeInsets? padding = const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
  }) {
    bubbleTriangleLength ??= 12.0;
    Offset bubbleTrianglePointOffset = Offset(-8.0, -bubbleTriangleLength / 2);
    if (direction == CcBubbleArrowDirection.left) {
      bubbleTrianglePointOffset = Offset(-8.0, -bubbleTriangleLength / 2);
    } else if (direction == CcBubbleArrowDirection.top) {
      bubbleTrianglePointOffset = Offset(bubbleTriangleLength / 2, -8.0);
    } else if (direction == CcBubbleArrowDirection.right) {
      bubbleTrianglePointOffset = Offset(8.0, bubbleTriangleLength / 2);
    } else if (direction == CcBubbleArrowDirection.bottom) {
      bubbleTrianglePointOffset = Offset(-bubbleTriangleLength / 2, 8.0);
    }
    return CcBubbleWidget(
      bubbleRadius: bubbleRadius ?? 6.0,
      bubbleTriangleDirection: direction,
      bubbleShadowColor: bubbleShadowColor,
      bubbleTriangleLength: bubbleTriangleLength,
      bubbleColor: bubbleColor ?? const Color(0xFF1C1D21),
      bubbleTrianglePointOffset: bubbleTrianglePointOffset,
      bubbleTriangleTranslation: bubbleTriangleTranslation,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        child: Text(
          text,
          style: textStyle,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
