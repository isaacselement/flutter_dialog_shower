// ignore_for_file: must_be_immutable

import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CcBubbleWidget extends StatelessWidget {
  Widget? child;

  double? width;
  double? height;
  Color? bubbleColor;
  double bubbleRadius;
  Color? bubbleShadowColor;
  double bubbleShadowRadius;
  double? bubbleTriangleLength;
  Offset? bubbleTrianglePointOffset;
  double? bubbleTriangleTranslation;
  CcBubbleArrowDirection bubbleTriangleDirection;
  bool isTriangleOccupiedSpace;

  CcBubbleWidget({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.bubbleColor = Colors.white,
    this.bubbleRadius = 8.0,
    this.bubbleShadowColor = Colors.grey,
    this.bubbleShadowRadius = 32.0,
    this.bubbleTriangleLength = 12.0,
    this.bubbleTrianglePointOffset, // null we will caculate a Offset value base on the length, here is Offset(-12.0, -6.0) for arrow left,
    this.bubbleTriangleTranslation,
    this.bubbleTriangleDirection = CcBubbleArrowDirection.left,
    this.isTriangleOccupiedSpace = true, // if true we ask for more space using margin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(bubbleRadius);
    BorderRadius borderRadius = BorderRadius.all(radius);

    // triangleOffset is based on clockwise direction
    double _triangleLength = bubbleTriangleLength ?? 0;
    if (_triangleLength != 0 && bubbleTrianglePointOffset == null) {
      double offsetAlong = _triangleLength / 2;
      double offsetIntersect = _triangleLength / 3 * 2;
      switch (bubbleTriangleDirection) {
        case CcBubbleArrowDirection.none:
          break;
        case CcBubbleArrowDirection.top:
          bubbleTrianglePointOffset = Offset(offsetAlong, -offsetIntersect);
          break;
        case CcBubbleArrowDirection.right:
          bubbleTrianglePointOffset = Offset(offsetIntersect, offsetAlong);
          break;
        case CcBubbleArrowDirection.bottom:
          bubbleTrianglePointOffset = Offset(-offsetAlong, offsetIntersect);
          break;
        case CcBubbleArrowDirection.left:
          bubbleTrianglePointOffset = Offset(-offsetIntersect, -offsetAlong);
          break;
        case CcBubbleArrowDirection.topLeft:
          bubbleTrianglePointOffset = Offset(-_triangleLength, -_triangleLength);
          // borderRadius = BorderRadius.only(topRight: radius, bottomRight: radius, bottomLeft: radius);
          break;
        case CcBubbleArrowDirection.topRight:
          bubbleTrianglePointOffset = Offset(_triangleLength, -_triangleLength);
          // borderRadius = BorderRadius.only(topLeft: radius, bottomRight: radius, bottomLeft: radius);
          break;
        case CcBubbleArrowDirection.bottomRight:
          bubbleTrianglePointOffset = Offset(_triangleLength, _triangleLength);
          // borderRadius = BorderRadius.only(topLeft: radius, topRight: radius, bottomLeft: radius);
          break;
        case CcBubbleArrowDirection.bottomLeft:
          bubbleTrianglePointOffset = Offset(-_triangleLength, _triangleLength);
          // borderRadius = BorderRadius.only(topLeft: radius, topRight: radius, bottomRight: radius);
          break;
      }
    }

    double px = 0;
    double py = 0;
    EdgeInsets margin = EdgeInsets.zero;
    // default triangle is on stage, that means it take position/occupy space
    if (isTriangleOccupiedSpace) {
      double sx = (bubbleTrianglePointOffset?.dx ?? 0).abs();
      double sy = (bubbleTrianglePointOffset?.dy ?? 0).abs();
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

      /// TODO ... need the painter inform us the width & height for the topLeft/topRight/bottomRight/bottomLeft
    }
    assert(() {
      CcBubblePainter.log('margin: $margin, triangleLength: $bubbleTriangleLength, pointOffset: $bubbleTrianglePointOffset');
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
        triangleDirection: bubbleTriangleDirection,
        triangleTranslation: bubbleTriangleTranslation,
        trianglePointOffset: bubbleTrianglePointOffset,
        isTriangleOccupiedSpace: isTriangleOccupiedSpace,
      ),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

/// Painter Below

enum CcBubbleArrowDirection { none, top, right, bottom, left, topRight, bottomRight, bottomLeft, topLeft }

enum _CcBubblePaintingBorder { top, right, bottom, left, topRight, bottomRight, bottomLeft, topLeft }

class CcBubblePainter extends CustomPainter {
  double x;
  double y;
  double? w;
  double? h;
  Color? color;
  double? radius;

  double? triangleLength;
  Offset? trianglePointOffset; // the Offset based on start point, for determined the Peek point

  double? triangleTranslation; // bottom side in the center for null
  bool isTriangleOccupiedSpace;
  CcBubbleArrowDirection triangleDirection = CcBubbleArrowDirection.top;

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
    this.triangleLength,
    this.trianglePointOffset,
    this.triangleTranslation,
    this.triangleDirection = CcBubbleArrowDirection.top,
    this.isTriangleOccupiedSpace = true,
    this.shadowBlurRadius = 10,
    this.shadowSpreadRadius = 0,
    this.shadowColor = Colors.grey,
    this.shadowOffset = Offset.zero,
    this.color = Colors.white,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double _w = w ?? size.width;
    double _h = h ?? size.height;
    double _triangleLength = triangleLength ?? 0;

    assert(() {
      CcBubblePainter.log('paint point offset: $trianglePointOffset');
      CcBubblePainter.log('paint size.width: ${size.width}, size.height: ${size.height}, w: $w, h: $h, _w:$_w, _h:$_h');
      return true;
    }());

    if (isTriangleOccupiedSpace) {
      // isTriangleOccupiedSpace = true, we need to decrease the length we setted in margin ~~~
      if (w == null) {
        if (triangleDirection == CcBubbleArrowDirection.left || triangleDirection == CcBubbleArrowDirection.right) {
          _w = size.width - (trianglePointOffset?.dx ?? 0).abs();
        }
      }
      if (h == null) {
        if (triangleDirection == CcBubbleArrowDirection.top || triangleDirection == CcBubbleArrowDirection.bottom) {
          _h = size.height - (trianglePointOffset?.dy ?? 0).abs();
        }
      }
    }

    assert(() {
      CcBubblePainter.log('paint size.width: ${size.width}, size.height: ${size.height}, w: $w, h: $h, _w:$_w, _h:$_h');
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

    void _drawTriangle(_CcBubblePaintingBorder whichSide, Offset startPoint, Offset overPoint) {
      _applyTriangleArrow(
          pointsPath, whichSide, triangleDirection, startPoint, overPoint, _triangleTranslation, trianglePointOffset, _triangleLength);
    }

    // start from original point
    pointsPath.moveTo(leftCircleCenterX, y);

    Offset fromPoint;
    Offset toPoint;
    Rect rectRadius;

    // top line
    fromPoint = Offset(leftCircleCenterX, y);
    toPoint = Offset(rightCircleCenterX, y);

    _drawTriangle(_CcBubblePaintingBorder.top, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(x + _w, topCircleCenterY);

    if (triangleDirection == CcBubbleArrowDirection.topRight) {
      // top right triangle
      _drawTriangle(_CcBubblePaintingBorder.topRight, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // top right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -0.5, math.pi * 0.5, false);
    }

    // right line
    fromPoint = toPoint;
    toPoint = Offset(x + _w, bottomCircleCenterY);

    _drawTriangle(_CcBubblePaintingBorder.right, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(rightCircleCenterX, y + _h);

    if (triangleDirection == CcBubbleArrowDirection.bottomRight) {
      // bottom right triangle
      _drawTriangle(_CcBubblePaintingBorder.bottomRight, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // bottom right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0, math.pi * 0.5, false);
    }

    // bottom line
    fromPoint = toPoint;
    toPoint = Offset(leftCircleCenterX, y + _h);

    _drawTriangle(_CcBubblePaintingBorder.bottom, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(x, bottomCircleCenterY);

    if (triangleDirection == CcBubbleArrowDirection.bottomLeft) {
      // bottom left triangle
      _drawTriangle(_CcBubblePaintingBorder.bottomLeft, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // bottom left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0.5, math.pi * 0.5, false);
    }

    // left line
    fromPoint = toPoint;
    toPoint = Offset(x, topCircleCenterY);

    _drawTriangle(_CcBubblePaintingBorder.left, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(leftCircleCenterX, y);

    if (triangleDirection == CcBubbleArrowDirection.topLeft) {
      // top left triangle
      _drawTriangle(_CcBubblePaintingBorder.topLeft, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // top left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -1, math.pi * 0.5, false);
    }

    // end to original point
    pointsPath.moveTo(toPoint.dx, toPoint.dy);
    pointsPath.close();

    // draw
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

  // triangleTranslation is based on clockwise direction, offset of the startX/startY
  // _trianglePointOffset is the offset for peek judged, base on startX/startY after the translation
  // _triangleLength:
  // 1. in the line(top, bottom, left, right) is the triangle bottom side length
  // 2. in the corner(topRight, bottomRight, bottomLeft, topLeft) is the offset of overX/overY
  void _applyTriangleArrow(Path path, _CcBubblePaintingBorder paintPosition, CcBubbleArrowDirection triangleDirection, Offset startPoint,
      Offset overPoint, double _triangleTranslation, Offset? _trianglePointOffset, double _triangleLength) {
    if (_trianglePointOffset == null) {
      return;
    }

    double startX = startPoint.dx;
    double startY = startPoint.dy;
    double overX = overPoint.dx;
    double overY = overPoint.dy;
    double peekOffsetDx = _trianglePointOffset.dx;
    double peekOffsetDy = _trianglePointOffset.dy;

    assert(() {
      CcBubblePainter.log('_applyArrow ${triangleDirection.toString()}');
      CcBubblePainter.log('_applyArrow startPoint $startPoint, overPoint $overPoint, peekOffset: $_trianglePointOffset');
      return true;
    }());

    bool isTop = paintPosition == _CcBubblePaintingBorder.top && triangleDirection == CcBubbleArrowDirection.top;
    bool isBottom = paintPosition == _CcBubblePaintingBorder.bottom && triangleDirection == CcBubbleArrowDirection.bottom;
    bool isLeft = paintPosition == _CcBubblePaintingBorder.left && triangleDirection == CcBubbleArrowDirection.left;
    bool isRight = paintPosition == _CcBubblePaintingBorder.right && triangleDirection == CcBubbleArrowDirection.right;

    bool isTopRight = paintPosition == _CcBubblePaintingBorder.topRight && triangleDirection == CcBubbleArrowDirection.topRight;
    bool isBottomRight = paintPosition == _CcBubblePaintingBorder.bottomRight && triangleDirection == CcBubbleArrowDirection.bottomRight;
    bool isBottomLeft = paintPosition == _CcBubblePaintingBorder.bottomLeft && triangleDirection == CcBubbleArrowDirection.bottomLeft;
    bool isTopLeft = paintPosition == _CcBubblePaintingBorder.topLeft && triangleDirection == CcBubbleArrowDirection.topLeft;

    // double triangleEqSide = sqrt(pow(_triangleLength, 2) + pow(triangleHeight, 2));
    if (isTop || isTopRight) {
      double beginX = startX + _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      if (isTop) {
        path.lineTo(beginX + _triangleLength, startY);
      } else if (isTopRight) {
        path.lineTo(overX, overY + _triangleLength);
      }
    } else if (isRight || isBottomRight) {
      double beginY = startY + _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      if (isRight) {
        path.lineTo(startX, beginY + _triangleLength);
      } else if (isBottomRight) {
        path.lineTo(overX - _triangleLength, overY);
      }
    } else if (isBottom || isBottomLeft) {
      double beginX = startX - _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      if (isBottom) {
        path.lineTo(beginX - _triangleLength, startY);
      } else if (isBottomLeft) {
        path.lineTo(overX, overY - _triangleLength);
      }
    } else if (isLeft || isTopLeft) {
      double beginY = startY - _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      if (isLeft) {
        path.lineTo(startX, beginY - _triangleLength);
      } else if (isTopLeft) {
        path.lineTo(overX + _triangleLength, overY);
      }
    }
  }

  static bool isDebugLogEnable = false;

  static log(String log) {
    assert(() {
      if (isDebugLogEnable) {
        if (kDebugMode) {
          print('[class $CcBubblePainter] $log');
        }
      }
      return true;
    }());
  }
}
