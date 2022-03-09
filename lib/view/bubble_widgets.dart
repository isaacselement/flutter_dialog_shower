import 'dart:math' as Math;

import 'package:flutter/material.dart';

class BubbleWidget extends StatelessWidget {
  Widget? child;

  double? width;
  double? height;
  Color? bubbleColor;
  double bubbleRadius;
  Color? bubbleShadowColor;
  double bubbleShadowRadius;
  double? bubbleTriangleWidth;
  double? bubbleTriangleHeight;
  double? bubbleTriangleOffset;
  TriangleArrowDirection triangleDirection;
  bool isTriangleOccupiedSpace;

  BubbleWidget({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.bubbleColor = Colors.white,
    this.bubbleRadius = 12.0,
    this.bubbleShadowColor = Colors.grey,
    this.bubbleShadowRadius = 32.0,
    this.bubbleTriangleWidth,
    this.bubbleTriangleHeight,
    this.bubbleTriangleOffset,
    this.triangleDirection = TriangleArrowDirection.left,
    this.isTriangleOccupiedSpace = true,
  }) : super(key: key) {
    _bubbleTriangleWidth = bubbleTriangleWidth ?? 12.0;
    _bubbleTriangleHeight = bubbleTriangleHeight ?? 8.0;
  }

  double _bubbleTriangleWidth = 12.0;
  double _bubbleTriangleHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    double px = 0;
    double py = 0;
    EdgeInsets margin = EdgeInsets.zero;
    // default triangle is on stage, that means it take position/occupy space
    if (isTriangleOccupiedSpace) {
      if (triangleDirection == TriangleArrowDirection.left) {
        px = _bubbleTriangleHeight;
        margin = EdgeInsets.only(left: _bubbleTriangleHeight);
      } else if (triangleDirection == TriangleArrowDirection.top) {
        py = _bubbleTriangleHeight;
        margin = EdgeInsets.only(top: _bubbleTriangleHeight);
      } else if (triangleDirection == TriangleArrowDirection.right) {
        margin = EdgeInsets.only(right: _bubbleTriangleHeight);
      } else if (triangleDirection == TriangleArrowDirection.bottom) {
        margin = EdgeInsets.only(bottom: _bubbleTriangleHeight);
      }
    }

    // CustomPaint as parent
    return CustomPaint(
      painter: BubblePainter(
        x: px,
        y: py,
        w: width,
        h: height,
        radius: bubbleRadius,
        paintColor: bubbleColor,
        shadowColor: bubbleShadowColor,
        shadowBlurRadius: bubbleShadowRadius,
        triangleWidth: _bubbleTriangleWidth,
        triangleHeight: _bubbleTriangleHeight,
        triangleDirection: triangleDirection,
        triangleOffset: bubbleTriangleOffset,
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

enum TriangleArrowDirection { top, right, bottom, left }
enum PathLinePosition { top, right, bottom, left }

class BubblePainter extends CustomPainter {
  double x;
  double y;
  double? w;
  double? h;
  double? radius;

  double triangleWidth = 0;
  double triangleHeight = 0;
  double? triangleOffset; // null for in the center
  TriangleArrowDirection triangleDirection = TriangleArrowDirection.top;
  bool isTriangleOccupiedSpace;

  Color? shadowColor;
  Offset? shadowOffset;
  double? shadowBlurRadius;
  double? shadowSpreadRadius;

  Color? paintColor;

  BubblePainter({
    required this.x,
    required this.y,
    this.w,
    this.h,
    this.radius = 0,
    this.triangleWidth = 0,
    this.triangleHeight = 0,
    this.triangleOffset,
    this.triangleDirection = TriangleArrowDirection.top,
    this.isTriangleOccupiedSpace = true,
    this.shadowColor = Colors.grey,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 10,
    this.shadowSpreadRadius = 0,
    this.paintColor = Colors.white,
  }) {
    triangleWidth = triangleWidth == 0 && triangleHeight != 0 ? triangleHeight : triangleWidth;
    triangleHeight = triangleHeight == 0 && triangleWidth != 0 ? triangleWidth : triangleHeight;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  // triangleOffset is based on clockwise direction
  // draw a small equilateral triangle pointing to a certain direction  // 绘制指向某个方向的等边小三角
  void _applyTriangleArrow(Path path, PathLinePosition pathPosition, double startX, double startY, double endX, double endY,
      TriangleArrowDirection triangleDirection, double triangleWidth, double triangleHeight, double triangleOffset) {
    if (triangleWidth <= 0 || triangleHeight <= 0) {
      return;
    }
    // double triangleEqSide = sqrt(pow(triangleWidth, 2) + pow(triangleHeight, 2));
    if (pathPosition == PathLinePosition.top && triangleDirection == TriangleArrowDirection.top) {
      path.lineTo(startX + triangleOffset, startY);
      path.lineTo(startX + (triangleOffset + triangleWidth / 2), startY - triangleHeight);
      path.lineTo(startX + (triangleOffset + triangleWidth), startY);
    } else if (pathPosition == PathLinePosition.right && triangleDirection == TriangleArrowDirection.right) {
      path.lineTo(startX, startY + triangleOffset);
      path.lineTo(startX + triangleHeight, startY + (triangleOffset + triangleWidth / 2));
      path.lineTo(startX, startY + (triangleOffset + triangleWidth));
    } else if (pathPosition == PathLinePosition.bottom && triangleDirection == TriangleArrowDirection.bottom) {
      path.lineTo(endX + (triangleOffset + triangleWidth), endY);
      path.lineTo(endX + (triangleOffset + triangleWidth / 2), endY + triangleHeight);
      path.lineTo(endX + triangleOffset, endY);
    } else if (pathPosition == PathLinePosition.left && triangleDirection == TriangleArrowDirection.left) {
      path.lineTo(endX, endY + (triangleOffset + triangleWidth));
      path.lineTo(endX - triangleHeight, endY + (triangleOffset + triangleWidth / 2));
      path.lineTo(endX, endY + triangleOffset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // triangleHeight indeed, we defind the triangleHeight is the middle line to the arrow
    double _w = w ?? size.width;
    double _h = h ?? size.height;
    if (isTriangleOccupiedSpace) {
      if (w == null && (triangleDirection == TriangleArrowDirection.left || triangleDirection == TriangleArrowDirection.right)) {
        _w = size.width - triangleHeight;
      }
      if (h == null && (triangleDirection == TriangleArrowDirection.top || triangleDirection == TriangleArrowDirection.bottom)) {
        _h = size.height - triangleHeight;
      }
    }

    double _radius = radius ?? 0;

    Path pointsPath = Path();

    double leftCircleCenterX = x + _radius;
    double rightCircleCenterX = x + _w - _radius;
    double topCircleCenterY = y + _radius;
    double bottomCircleCenterY = y + _h - _radius;

    // make triangle is in center or by custom
    double _triangleOffset = 0;
    if (triangleOffset == null) {
      if (triangleDirection == TriangleArrowDirection.left || triangleDirection == TriangleArrowDirection.right) {
        _triangleOffset = _h / 2 - triangleWidth / 2 - _radius;
      } else if (triangleDirection == TriangleArrowDirection.top || triangleDirection == TriangleArrowDirection.bottom) {
        _triangleOffset = _w / 2 - triangleWidth / 2 - _radius;
      }
    } else {
      _triangleOffset = triangleOffset!;
    }

    // start from original point
    pointsPath.moveTo(leftCircleCenterX, y);

    // top line
    _applyTriangleArrow(pointsPath, PathLinePosition.top, leftCircleCenterX, y, rightCircleCenterX, y, triangleDirection, triangleWidth,
        triangleHeight, _triangleOffset);
    pointsPath.lineTo(rightCircleCenterX, y);

    Rect rect;
    if (radius != 0) {
      // top right arc
      rect = Rect.fromCircle(center: Offset(rightCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rect, Math.pi * -0.5, Math.pi * 0.5, false);
    }

    // right line
    _applyTriangleArrow(pointsPath, PathLinePosition.right, x + _w, topCircleCenterY, x + _w, bottomCircleCenterY, triangleDirection,
        triangleWidth, triangleHeight, _triangleOffset);
    pointsPath.lineTo(x + _w, bottomCircleCenterY);

    if (radius != 0) {
      // bottom right arc
      rect = Rect.fromCircle(center: Offset(rightCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rect, Math.pi * 0, Math.pi * 0.5, false);
    }

    // bottom line
    _applyTriangleArrow(pointsPath, PathLinePosition.bottom, rightCircleCenterX, y + _h, leftCircleCenterX, y + _h, triangleDirection,
        triangleWidth, triangleHeight, _triangleOffset);
    pointsPath.lineTo(leftCircleCenterX, y + _h);

    if (radius != 0) {
      // bottom left arc
      rect = Rect.fromCircle(center: Offset(leftCircleCenterX, bottomCircleCenterY), radius: _radius);
      pointsPath.arcTo(rect, Math.pi * 0.5, Math.pi * 0.5, false);
    }

    // left line
    _applyTriangleArrow(pointsPath, PathLinePosition.left, x, bottomCircleCenterY, x, topCircleCenterY, triangleDirection, triangleWidth,
        triangleHeight, _triangleOffset);
    pointsPath.lineTo(x, topCircleCenterY);

    if (radius != 0) {
      // top left arc
      rect = Rect.fromCircle(center: Offset(leftCircleCenterX, topCircleCenterY), radius: _radius);
      pointsPath.arcTo(rect, Math.pi * -1, Math.pi * 0.5, false);
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
        ..color = paintColor!
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1,
    );
  }
}
