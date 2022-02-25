import 'dart:math' as Math;

import 'package:flutter/material.dart';

class BubbleWidget extends StatelessWidget {

  Widget? child;

  double width;
  double height;
  double bubbleRadius;
  Color? bubbleShadowColor;
  double bubbleShadowRadius;
  double? bubbleTriangleWidth;
  double bubbleTriangleHeight;
  double? bubbleTriangleOffset;
  TriangleArrowDirection triangleDirection;

  BubbleWidget({
    required this.width,
    required this.height,
    this.child,
    this.bubbleRadius = 12.0,
    this.bubbleShadowColor = Colors.grey,
    this.bubbleShadowRadius = 32.0,
    this.bubbleTriangleHeight = 8.0,
    this.bubbleTriangleWidth  = 12.0,
    this.bubbleTriangleOffset,
    this.triangleDirection = TriangleArrowDirection.left,
  }) ;

  @override
  Widget build(BuildContext context) {
    double triangleOffset = width / 2;
    if (triangleDirection == TriangleArrowDirection.left || triangleDirection == TriangleArrowDirection.right) {
      triangleOffset = height / 2 - bubbleTriangleWidth! / 2 - bubbleRadius;
    } else if (triangleDirection == TriangleArrowDirection.top || triangleDirection == TriangleArrowDirection.bottom) {
      triangleOffset = width / 2 - bubbleTriangleWidth! / 2 - bubbleRadius;
    }
    triangleOffset = bubbleTriangleOffset ?? triangleOffset;

    EdgeInsets innerMargin = EdgeInsets.zero;
    if (triangleDirection == TriangleArrowDirection.left) {
      innerMargin = EdgeInsets.only(left: bubbleTriangleHeight);
    } else if (triangleDirection == TriangleArrowDirection.top) {
      innerMargin = EdgeInsets.only(top: bubbleTriangleHeight);
    } else if (triangleDirection == TriangleArrowDirection.right) {
      innerMargin = EdgeInsets.only(right: bubbleTriangleHeight);
    } else if (triangleDirection == TriangleArrowDirection.bottom) {
      innerMargin = EdgeInsets.only(bottom: bubbleTriangleHeight);
    }

    double px = triangleDirection == TriangleArrowDirection.left ? bubbleTriangleHeight : 0;
    double py = triangleDirection == TriangleArrowDirection.top ? bubbleTriangleHeight : 0;

    return CustomPaint(
      painter: BubblePainter(
        x: px,
        y: py,
        w: width,
        h: height,
        radius: bubbleRadius,
        shadowColor: bubbleShadowColor,
        shadowBlurRadius: bubbleShadowRadius,
        triangleWidth: bubbleTriangleWidth!,
        triangleHeight: bubbleTriangleHeight,
        triangleDirection: triangleDirection,
        triangleOffset: triangleOffset,
      ),
      child: Container(
        width: width,
        height: height,
        margin: innerMargin,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.red,
          // border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(bubbleRadius)),
        ),
        child: child ?? const Offstage(offstage: true),
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
  double w;
  double h;
  double radius;

  double triangleWidth = 0;
  double triangleHeight = 0;
  double triangleOffset = 0;
  TriangleArrowDirection triangleDirection = TriangleArrowDirection.top;

  Color? shadowColor;
  Offset shadowOffset;
  double shadowBlurRadius;
  double shadowSpreadRadius;

  Color? paintColor;

  BubblePainter({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.radius = 0,
    this.triangleWidth = 0,
    this.triangleHeight = 0,
    this.triangleOffset = 0,
    this.triangleDirection = TriangleArrowDirection.top,
    this.shadowColor,
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
    Path pointsPath = Path();

    double leftCircleCenterX = x + radius;
    double rightCircleCenterX = x + w - radius;
    double topCircleCenterY = y + radius;
    double bottomCircleCenterY = y + h - radius;

    // start from original point
    pointsPath.moveTo(leftCircleCenterX, y);

    // top line
    _applyTriangleArrow(
        pointsPath, PathLinePosition.top, leftCircleCenterX, y, rightCircleCenterX, y, triangleDirection, triangleWidth, triangleHeight, triangleOffset);
    pointsPath.lineTo(rightCircleCenterX, y);

    Rect rect;
    if (radius != 0) {
      // top right arc
      rect = Rect.fromCircle(center: Offset(rightCircleCenterX, topCircleCenterY), radius: radius);
      pointsPath.arcTo(rect, Math.pi * -0.5, Math.pi * 0.5, false);
    }

    // right line
    _applyTriangleArrow(pointsPath, PathLinePosition.right, x + w, topCircleCenterY, x + w, bottomCircleCenterY, triangleDirection, triangleWidth,
        triangleHeight, triangleOffset);
    pointsPath.lineTo(x + w, bottomCircleCenterY);

    if (radius != 0) {
      // bottom right arc
      rect = Rect.fromCircle(center: Offset(rightCircleCenterX, bottomCircleCenterY), radius: radius);
      pointsPath.arcTo(rect, Math.pi * 0, Math.pi * 0.5, false);
    }

    // bottom line
    _applyTriangleArrow(pointsPath, PathLinePosition.bottom, rightCircleCenterX, y + h, leftCircleCenterX, y + h, triangleDirection, triangleWidth,
        triangleHeight, triangleOffset);
    pointsPath.lineTo(leftCircleCenterX, y + h);

    if (radius != 0) {
      // bottom left arc
      rect = Rect.fromCircle(center: Offset(leftCircleCenterX, bottomCircleCenterY), radius: radius);
      pointsPath.arcTo(rect, Math.pi * 0.5, Math.pi * 0.5, false);
    }

    // left line
    _applyTriangleArrow(pointsPath, PathLinePosition.left, x, bottomCircleCenterY, x, topCircleCenterY, triangleDirection, triangleWidth,
        triangleHeight, triangleOffset);
    pointsPath.lineTo(x, topCircleCenterY);

    if (radius != 0) {
      // top left arc
      rect = Rect.fromCircle(center: Offset(leftCircleCenterX, topCircleCenterY), radius: radius);
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
        color: shadowColor!,
        offset: shadowOffset,
        blurRadius: shadowBlurRadius,
        spreadRadius: shadowSpreadRadius,
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
