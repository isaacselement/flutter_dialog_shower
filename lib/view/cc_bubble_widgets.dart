import 'dart:math' as math;
import 'dart:core';

import 'package:flutter/material.dart';

class CcBubbleWidget extends StatelessWidget {
  Widget? child;

  double? width;
  double? height;
  Color? bubbleColor;
  double bubbleRadius;
  Color? bubbleShadowColor;
  double bubbleShadowRadius;
  Offset? bubbleTrianglePoint;
  double? bubbleTriangleLength;
  double? bubbleTriangleTranslation;
  CcBubbleArrowDirection bubbleTriangleDirection;
  bool isTriangleOccupiedSpace;

  CcBubbleWidget({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.bubbleColor = Colors.white,
    this.bubbleRadius = 8.0,
    this.bubbleShadowColor = Colors.grey,
    this.bubbleShadowRadius = 32.0,
    this.bubbleTriangleLength = 12.0,
    this.bubbleTrianglePoint, // null we will caculate a Offset value base on the length, here is Offset(-12.0, -6.0) for arrow left,
    this.bubbleTriangleTranslation,
    this.bubbleTriangleDirection = CcBubbleArrowDirection.left,
    this.isTriangleOccupiedSpace = true, // if true we ask for more space using margin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // triangleOffset is based on clockwise direction
    double _triangleLength = bubbleTriangleLength ?? 0;
    if (_triangleLength != 0 && bubbleTrianglePoint == null) {
      if (bubbleTriangleDirection == CcBubbleArrowDirection.left) {
        bubbleTrianglePoint = Offset(-_triangleLength, -_triangleLength / 2);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.right) {
        bubbleTrianglePoint = Offset(_triangleLength, _triangleLength / 2);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.top) {
        bubbleTrianglePoint = Offset(_triangleLength / 2, -_triangleLength);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.bottom) {
        bubbleTrianglePoint = Offset(-_triangleLength / 2, _triangleLength);
      }
    }

    double px = 0;
    double py = 0;
    EdgeInsets margin = EdgeInsets.zero;
    // default triangle is on stage, that means it take position/occupy space
    if (isTriangleOccupiedSpace) {
      double sx = (bubbleTrianglePoint?.dx ?? 0).abs();
      double sy = (bubbleTrianglePoint?.dy ?? 0).abs();
      if (bubbleTriangleDirection == CcBubbleArrowDirection.left) {
        px = sx;
        margin = EdgeInsets.only(left: sx);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.top) {
        py = sy;
        margin = EdgeInsets.only(top: sy);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.right) {
        margin = EdgeInsets.only(right: sx);
      } else if (bubbleTriangleDirection == CcBubbleArrowDirection.bottom) {
        margin = EdgeInsets.only(bottom: sy);
      }
    }
    assert(() {
      print('[CcBubbleWidget] >>>>>>>>>>> margin: $margin');
      return true;
    }());

    // CustomPaint as parent
    return CustomPaint(
      painter: CcBubblePainter(
        x: px,
        y: py,
        w: width,
        h: height,
        color: bubbleColor,
        radius: bubbleRadius,
        shadowColor: bubbleShadowColor,
        shadowBlurRadius: bubbleShadowRadius,
        triangleLength: bubbleTriangleLength,
        trianglePoint: bubbleTrianglePoint,
        triangleDirection: bubbleTriangleDirection,
        triangleTranslation: bubbleTriangleTranslation,
        isTriangleOccupiedSpace: isTriangleOccupiedSpace,
      ),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // color: Colors.red,
          // border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(bubbleRadius)),
        ),
        child: child,
      ),
    );
  }
}

/// Painter Below

enum CcBubbleArrowDirection { none, top, right, bottom, left, topRight, bottomRight, bottomLeft, topLeft }

enum _PaintingBorder { top, right, bottom, left, topRight, bottomRight, bottomLeft, topLeft }

class CcBubblePainter extends CustomPainter {
  double x;
  double y;
  double? w;
  double? h;
  Color? color;
  double? radius;

  Offset? trianglePoint; // the Offset based on start point, for determined the Peek point
  double? triangleLength;

  double? triangleTranslation; // bottom side in the center for null
  CcBubbleArrowDirection triangleDirection = CcBubbleArrowDirection.top;
  bool isTriangleOccupiedSpace;

  Color? shadowColor;
  Offset? shadowOffset;
  double? shadowBlurRadius;
  double? shadowSpreadRadius;

  CcBubblePainter({
    required this.x,
    required this.y,
    this.w,
    this.h,
    this.radius,
    this.trianglePoint,
    this.triangleLength,
    this.triangleTranslation,
    this.triangleDirection = CcBubbleArrowDirection.top,
    this.isTriangleOccupiedSpace = true,
    this.shadowColor = Colors.grey,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 10,
    this.shadowSpreadRadius = 0,
    this.color = Colors.white,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double _w = w ?? size.width;
    double _h = h ?? size.height;
    double _triangleLength = triangleLength ?? 0;

    assert(() {
      print('[CcBubblePainter] paint point offset: $trianglePoint');
      print('[CcBubblePainter] paint size.width: ${size.width}, size.height: ${size.height}, w: $w, h: $h, _w:$_w, _h:$_h');
      return true;
    }());

    if (isTriangleOccupiedSpace) {
      // isTriangleOccupiedSpace = true, we need to decrease the length we setted in margin ~~~
      if (w == null) {
        if (triangleDirection == CcBubbleArrowDirection.left || triangleDirection == CcBubbleArrowDirection.right) {
          _w = size.width - (trianglePoint?.dx ?? 0).abs();
        }
      }
      if (h == null) {
        if (triangleDirection == CcBubbleArrowDirection.top || triangleDirection == CcBubbleArrowDirection.bottom) {
          _h = size.height - (trianglePoint?.dy ?? 0).abs();
        }
      }
    }

    assert(() {
      print('[CcBubblePainter] paint size.width: ${size.width}, size.height: ${size.height}, w: $w, h: $h, _w:$_w, _h:$_h');
      return true;
    }());

    double _radius = radius ?? 0;

    Path pointsPath = Path();

    double leftCircleCenterX = x + _radius;
    double rightCircleCenterX = x + _w - _radius;
    double topCircleCenterY = y + _radius;
    double bottomCircleCenterY = y + _h - _radius;

    // make triangle is in center or by custom
    double _triangleTranslation = 0;
    if (triangleTranslation == null) {
      if (triangleDirection == CcBubbleArrowDirection.left || triangleDirection == CcBubbleArrowDirection.right) {
        _triangleTranslation = _h / 2 - _triangleLength / 2 - _radius;
      } else if (triangleDirection == CcBubbleArrowDirection.top || triangleDirection == CcBubbleArrowDirection.bottom) {
        _triangleTranslation = _w / 2 - _triangleLength / 2 - _radius;
      }
    } else {
      _triangleTranslation = triangleTranslation!;
    }

    void _drawTriangle(_PaintingBorder whichSide, Offset startPoint) {
      _applyTriangleArrow(pointsPath, whichSide, triangleDirection, startPoint, _triangleTranslation, trianglePoint, _triangleLength);
    }

    // start from original point
    pointsPath.moveTo(leftCircleCenterX, y);

    Offset nowPoint;
    Rect rectRadius;

    // top line
    nowPoint = Offset(leftCircleCenterX, y);
    _drawTriangle(_PaintingBorder.top, nowPoint);
    pointsPath.lineTo(rightCircleCenterX, y);

    if (triangleDirection == CcBubbleArrowDirection.topRight) {
      // top right triangle
      nowPoint = Offset(rightCircleCenterX, y);

    } else if (radius != 0) {
      // top right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -0.5, math.pi * 0.5, false);
    }

    // right line
    nowPoint = Offset(x + _w, topCircleCenterY);
    _drawTriangle(_PaintingBorder.right, nowPoint);
    pointsPath.lineTo(x + _w, bottomCircleCenterY);

    if (radius != 0) {
      // bottom right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0, math.pi * 0.5, false);
    }

    // bottom line
    nowPoint = Offset(rightCircleCenterX, y + _h);
    _drawTriangle(_PaintingBorder.bottom, nowPoint);
    pointsPath.lineTo(leftCircleCenterX, y + _h);

    if (radius != 0) {
      // bottom left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0.5, math.pi * 0.5, false);
    }

    // left line
    nowPoint = Offset(x, bottomCircleCenterY);
    _drawTriangle(_PaintingBorder.left, nowPoint);
    pointsPath.lineTo(x, topCircleCenterY);

    if (radius != 0) {
      // top left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -1, math.pi * 0.5, false);
    }

    // end to original point
    pointsPath.moveTo(leftCircleCenterX, y);

    pointsPath.close();

    // draw phase
    // canvas.drawShadow(pointsPath, Colors.black, 10.0, true);

    // canvas.drawRRect(
    //   const BorderRadius.all(Radius.circular(10)).resolve(TextDirection.ltr).toRRect(const Rect.fromLTRB(30, 30, 50, 50)),
    //   const BoxShadow(color: Colors.black, offset: Offset.zero, blurRadius: 10, spreadRadius: 20,).toPaint(),
    // );

    // 1. first draw shadow
    if (shadowColor != null) {
      BoxShadow boxShadow = BoxShadow(
        color: shadowColor ?? Colors.grey,
        offset: shadowOffset ?? Offset.zero,
        blurRadius: shadowBlurRadius ?? 10.0,
        spreadRadius: shadowSpreadRadius ?? 0.0,
      );
      Paint boxShadowPaint = boxShadow.toPaint();
      canvas.drawPath(pointsPath, boxShadowPaint);
    }

    // 2. second file the path
    canvas.drawPath(
      pointsPath,
      Paint()
        ..color = color!
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1,
    );
  }

  // triangleTranslation is based on clockwise direction
  // draw a small equilateral triangle pointing to a certain direction  // 绘制指向某个方向的等边小三角
  void _applyTriangleArrow(Path path, _PaintingBorder pathPosition, CcBubbleArrowDirection triangleDirection, Offset startPoint,
      double _triangleTranslation, Offset? _trianglePointOffset, double _triangleLength) {
    if (_trianglePointOffset == null || _triangleLength <= 0) {
      return;
    }

    double startX = startPoint.dx;
    double startY = startPoint.dy;

    assert(() {
      print('[CcBubblePainter] _applyArrow ${triangleDirection.toString()}: startX $startX, startY $startY');
      return true;
    }());
    double pointDx = _trianglePointOffset.dx;
    double pointDy = _trianglePointOffset.dy;
    // double triangleEqSide = sqrt(pow(_triangleLength, 2) + pow(triangleHeight, 2));
    if (pathPosition == _PaintingBorder.top && triangleDirection == CcBubbleArrowDirection.top) {
      double beginX = startX + _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + pointDx, startY + pointDy);
      path.lineTo(beginX + _triangleLength, startY);
    } else if (pathPosition == _PaintingBorder.bottom && triangleDirection == CcBubbleArrowDirection.bottom) {
      double beginX = startX - _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + pointDx, startY + pointDy);
      path.lineTo(beginX - _triangleLength, startY);
    } else if (pathPosition == _PaintingBorder.left && triangleDirection == CcBubbleArrowDirection.left) {
      double bY = startY - _triangleTranslation;
      path.lineTo(startX, bY);
      path.lineTo(startX + pointDx, bY + pointDy);
      path.lineTo(startX, bY - _triangleLength);
    } else if (pathPosition == _PaintingBorder.right && triangleDirection == CcBubbleArrowDirection.right) {
      double bY = startY + _triangleTranslation;
      path.lineTo(startX, bY);
      path.lineTo(startX + pointDx, bY + pointDy);
      path.lineTo(startX, bY + _triangleLength);
    }
  }
}
