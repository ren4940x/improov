import 'package:flutter/material.dart';

class MemosBinderPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasShadow;
  final double tabWidth;
  final double tabHeight;
  final double tabLeftOffset;

  MemosBinderPainter({
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2.0,
    this.hasShadow = true,
    this.tabWidth = 130.0,
    this.tabHeight = 40.0,
    this.tabLeftOffset = 118.0, // Slight overlap behind first tab
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    const r = 18.0;

    final tabStart = tabLeftOffset;
    final tabEnd = tabStart + tabWidth;

    path.moveTo(0, tabHeight + r);
    path.lineTo(0, h - r);
    path.quadraticBezierTo(0, h, r, h);
    path.lineTo(w - r, h);
    path.quadraticBezierTo(w, h, w, h - r);
    path.lineTo(w, tabHeight + r);
    path.quadraticBezierTo(w, tabHeight, w - r, tabHeight);

    // Right fillet down from tab
    path.lineTo(tabEnd + 28, tabHeight);
    path.quadraticBezierTo(tabEnd + 12, tabHeight, tabEnd + 8, tabHeight - 10);
    path.lineTo(tabEnd, 10);
    path.quadraticBezierTo(tabEnd - 4, 0, tabEnd - 20, 0);

    // Top edge of middle tab
    path.lineTo(tabStart + 20, 0);
    path.quadraticBezierTo(tabStart + 4, 0, tabStart, 10);
    path.lineTo(tabStart - 8, tabHeight - 10);

    // Left fillet into the left shoulder
    path.quadraticBezierTo(tabStart - 12, tabHeight, tabStart - 28, tabHeight);
    path.lineTo(r, tabHeight);
    path.quadraticBezierTo(0, tabHeight, 0, tabHeight + r);
    path.close();

    // 1. Hard Paper Drop Shadow
    if (hasShadow) {
      final shadowPaint = Paint()
        ..color = const Color(0x002e2b27).withOpacity(0.18)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    }

    // 2. Body Fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Tonal Stroke
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant MemosBinderPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.hasShadow != hasShadow;
}