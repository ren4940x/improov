// lib/src/presentation/diary/widgets/binders/calendar_binder.dart
import 'package:flutter/material.dart';

class CalendarBinder extends StatelessWidget {
  final Widget? child;
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabBottomOffset;
  final double tabHeight;
  final double tabExtension;

  const CalendarBinder({
    super.key,
    this.child,
    this.hasShadow = true,
    this.fillColor = const Color(0xFF9BB7C5), // Slate Blue cardstock
    this.borderColor = const Color(0xFF7693A0),
    this.borderWidth = 2.0,
    this.tabBottomOffset = 360.0, // 3 * 120.0
    this.tabHeight = 120.0,
    this.tabExtension = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CalendarBinderPainter(
        hasShadow: hasShadow,
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        tabBottomOffset: tabBottomOffset,
        tabHeight: tabHeight,
        tabExtension: tabExtension,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 18.0,
          left: 18.0,
          bottom: 18.0,
          right: tabExtension + 18.0,
        ),
        child: child,
      ),
    );
  }
}

class CalendarBinderPainter extends CustomPainter {
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabBottomOffset;
  final double tabHeight;
  final double tabExtension;

  const CalendarBinderPainter({
    this.hasShadow = true,
    this.fillColor = const Color(0xFF9BB7C5),
    this.borderColor = const Color(0xFF7693A0),
    this.borderWidth = 2.0,
    this.tabBottomOffset = 360.0,
    this.tabHeight = 120.0,
    this.tabExtension = 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    if (hasShadow) {
      final shadowPaint = Paint()
        ..color = const Color(0xFF2E2B27).withOpacity(0.18)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    }

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  Path _buildPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final bodyWidth = w - tabExtension;

    const cornerRadius = 20.0;
    const tabCornerRadius = 14.0;
    const filletRadius = 14.0;

    final tabBottom = h - tabBottomOffset;
    final tabTop = tabBottom - tabHeight;

    // 1. Top-Left corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // 2. Top Edge
    if (tabTop <= 0) {
      path.lineTo(w - tabCornerRadius, 0);
      path.quadraticBezierTo(w, 0, w, tabCornerRadius);
    } else {
      path.lineTo(bodyWidth - cornerRadius, 0);
      path.quadraticBezierTo(bodyWidth, 0, bodyWidth, cornerRadius);
      path.lineTo(bodyWidth, tabTop - filletRadius);
      path.quadraticBezierTo(bodyWidth, tabTop, bodyWidth + filletRadius, tabTop);
      path.lineTo(w - tabCornerRadius, tabTop);
      path.quadraticBezierTo(w, tabTop, w, tabTop + tabCornerRadius);
    }

    // 3. Tab outer vertical edge
    path.lineTo(w, tabBottom - tabCornerRadius);
    path.quadraticBezierTo(w, tabBottom, w - tabCornerRadius, tabBottom);

    // 4. Tab bottom shelf and lower fillet
    path.lineTo(bodyWidth + filletRadius, tabBottom);
    path.quadraticBezierTo(bodyWidth, tabBottom, bodyWidth, tabBottom + filletRadius);

    // 5. Lower body edge down to bottom-right corner
    path.lineTo(bodyWidth, h - cornerRadius);
    path.quadraticBezierTo(bodyWidth, h, bodyWidth - cornerRadius, h);

    // 6. Bottom edge across
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);

    // 7. Left edge
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CalendarBinderPainter oldDelegate) =>
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.tabBottomOffset != tabBottomOffset ||
      oldDelegate.tabHeight != tabHeight ||
      oldDelegate.tabExtension != tabExtension;
}