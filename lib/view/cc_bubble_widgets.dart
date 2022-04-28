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
  double? bubbleTriangleLength;
  Offset? bubbleTrianglePointOffset;
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
      switch (bubbleTriangleDirection) {
        case CcBubbleArrowDirection.none:
          break;
        case CcBubbleArrowDirection.top:
          bubbleTrianglePointOffset = Offset(_triangleLength / 2, -_triangleLength);
          break;
        case CcBubbleArrowDirection.right:
          bubbleTrianglePointOffset = Offset(_triangleLength, _triangleLength / 2);
          break;
        case CcBubbleArrowDirection.bottom:
          bubbleTrianglePointOffset = Offset(-_triangleLength / 2, _triangleLength);
          break;
        case CcBubbleArrowDirection.left:
          bubbleTrianglePointOffset = Offset(-_triangleLength, -_triangleLength / 2);
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
      print('[CcBubblePainter] margin: $margin, triangleLength: $bubbleTriangleLength, pointOffset: $bubbleTrianglePointOffset');
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
        trianglePointOffset: bubbleTrianglePointOffset,
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
          borderRadius: borderRadius,
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

  double? triangleLength;
  Offset? trianglePointOffset; // the Offset based on start point, for determined the Peek point

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
    this.trianglePointOffset,
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
      print('[CcBubblePainter] paint point offset: $trianglePointOffset');
      print('[CcBubblePainter] paint size.width: ${size.width}, size.height: ${size.height}, w: $w, h: $h, _w:$_w, _h:$_h');
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

    void _drawTriangle(_PaintingBorder whichSide, Offset startPoint, Offset overPoint) {
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

    _drawTriangle(_PaintingBorder.top, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(x + _w, topCircleCenterY);

    if (triangleDirection == CcBubbleArrowDirection.topRight) {
      // top right triangle
      _drawTriangle(_PaintingBorder.topRight, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // top right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -0.5, math.pi * 0.5, false);
    }

    // right line
    fromPoint = toPoint;
    toPoint = Offset(x + _w, bottomCircleCenterY);

    _drawTriangle(_PaintingBorder.right, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(rightCircleCenterX, y + _h);

    if (triangleDirection == CcBubbleArrowDirection.bottomRight) {
      // bottom right triangle
      _drawTriangle(_PaintingBorder.bottomRight, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // bottom right arc
      rectRadius = Rect.fromCircle(center: Offset(rightCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0, math.pi * 0.5, false);
    }

    // bottom line
    fromPoint = toPoint;
    toPoint = Offset(leftCircleCenterX, y + _h);

    _drawTriangle(_PaintingBorder.bottom, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(x, bottomCircleCenterY);

    if (triangleDirection == CcBubbleArrowDirection.bottomLeft) {
      // bottom left triangle
      _drawTriangle(_PaintingBorder.bottomLeft, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
    } else if (radius != 0) {
      // bottom left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * 0.5, math.pi * 0.5, false);
    }

    // left line
    fromPoint = toPoint;
    toPoint = Offset(x, topCircleCenterY);

    _drawTriangle(_PaintingBorder.left, fromPoint, toPoint);
    pointsPath.lineTo(toPoint.dx, toPoint.dy);

    fromPoint = toPoint;
    toPoint = Offset(leftCircleCenterX, y);

    if (triangleDirection == CcBubbleArrowDirection.topLeft) {
      // top left triangle
      _drawTriangle(_PaintingBorder.topLeft, fromPoint, toPoint);
      pointsPath.lineTo(toPoint.dx, toPoint.dy);
      print('??????????0000000=======>>>>>>>>>> triangle top left');
    } else if (radius != 0) {
      // top left arc
      rectRadius = Rect.fromCircle(center: Offset(leftCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rectRadius, math.pi * -1, math.pi * 0.5, false);
      print('??????????0000000=======>>>>>>>>>> arc top left');
    }

    // end to original point
    pointsPath.moveTo(toPoint.dx, toPoint.dy);

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

  // triangleTranslation is based on clockwise direction, offset of the startX/startY
  // _trianglePointOffset is the offset for peek judged, base on startX/startY after the translation
  // _triangleLength:
  // 1. in the line(top, bottom, left, right) is the triangle bottom side length
  // 2. in the corner(topRight, bottomRight, bottomLeft, topLeft) is the offset of overX/overY
  void _applyTriangleArrow(Path path, _PaintingBorder pathPosition, CcBubbleArrowDirection triangleDirection, Offset startPoint,
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
      print('[CcBubblePainter] _applyArrow ${triangleDirection.toString()}');
      print('[CcBubblePainter] _applyArrow startPoint $startPoint, overPoint $overPoint, peekOffset: $_trianglePointOffset');
      return true;
    }());

    // double triangleEqSide = sqrt(pow(_triangleLength, 2) + pow(triangleHeight, 2));
    if (pathPosition == _PaintingBorder.top && triangleDirection == CcBubbleArrowDirection.top) {
      double beginX = startX + _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      path.lineTo(beginX + _triangleLength, startY);
    } else if (pathPosition == _PaintingBorder.bottom && triangleDirection == CcBubbleArrowDirection.bottom) {
      double beginX = startX - _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      path.lineTo(beginX - _triangleLength, startY);
    } else if (pathPosition == _PaintingBorder.left && triangleDirection == CcBubbleArrowDirection.left) {
      double beginY = startY - _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      path.lineTo(startX, beginY - _triangleLength);
    } else if (pathPosition == _PaintingBorder.right && triangleDirection == CcBubbleArrowDirection.right) {
      double beginY = startY + _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      path.lineTo(startX, beginY + _triangleLength);
    } else if (pathPosition == _PaintingBorder.topRight && triangleDirection == CcBubbleArrowDirection.topRight) {
      double beginX = startX + _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      path.lineTo(overX, overY + _triangleLength);
    } else if (pathPosition == _PaintingBorder.bottomRight && triangleDirection == CcBubbleArrowDirection.bottomRight) {
      double beginY = startY + _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      path.lineTo(overX - _triangleLength, overY);
    } else if (pathPosition == _PaintingBorder.bottomLeft && triangleDirection == CcBubbleArrowDirection.bottomLeft) {
      double beginX = startX - _triangleTranslation;
      path.lineTo(beginX, startY);
      path.lineTo(beginX + peekOffsetDx, startY + peekOffsetDy);
      path.lineTo(overX, overY - _triangleLength);
    } else if (pathPosition == _PaintingBorder.topLeft && triangleDirection == CcBubbleArrowDirection.topLeft) {
      double beginY = startY - _triangleTranslation;
      path.lineTo(startX, beginY);
      path.lineTo(startX + peekOffsetDx, beginY + peekOffsetDy);
      path.lineTo(overX + _triangleLength, overY);
    }
  }
}
