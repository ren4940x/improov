import 'package:flutter/material.dart';

class RhythmsBinderPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasShadow;
  final double tabWidth;
  final double tabHeight;

  RhythmsBinderPainter({
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2.0,
    this.hasShadow = true,
    this.tabWidth = 130.0,
    this.tabHeight = 40.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    const r = 18.0;

    // Flush-left tab path with smooth concave fillet
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(tabWidth - 20, 0);
    path.quadraticBezierTo(tabWidth - 4, 0, tabWidth, 10);
    path.lineTo(tabWidth + 8, tabHeight - 10);
    path.quadraticBezierTo(tabWidth + 12, tabHeight, tabWidth + 28, tabHeight);
    path.lineTo(w - r, tabHeight);
    path.quadraticBezierTo(w, tabHeight, w, tabHeight + r);
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.close();

    // 1. Hard Paper Drop Shadow (Only when active on top)
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
  bool shouldRepaint(covariant RhythmsBinderPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.hasShadow != hasShadow;
}