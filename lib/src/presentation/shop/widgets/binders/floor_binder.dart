// lib/src/presentation/shop/widgets/binders/floor_binder.dart
import 'package:flutter/material.dart';

class FloorBinder extends StatelessWidget {
  final Widget? child;
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const FloorBinder({
    super.key,
    this.child,
    this.hasShadow = true,
    this.fillColor = const Color(0xFFE8BAC6), // Dusty Rose cardstock
    this.borderColor = const Color(0xFFC994A3), // Tonal rose border
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 1, // Slot 1 (Middle-left tab in 1/4-cut system)
    this.totalSlots = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FloorBinderPainter(
        hasShadow: hasShadow,
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        tabHeight: tabHeight,
        tabSlot: tabSlot,
        totalSlots: totalSlots,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: tabHeight + 16.0,
          left: 20.0,
          right: 20.0,
          bottom: 16.0,
        ),
        child: child,
      ),
    );
  }
}

class FloorBinderPainter extends CustomPainter {
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const FloorBinderPainter({
    this.hasShadow = true,
    this.fillColor = const Color(0xFFE8BAC6),
    this.borderColor = const Color(0xFFC994A3),
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 1,
    this.totalSlots = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // 1. Soft Paper Drop Shadow
    if (hasShadow) {
      final shadowPaint = Paint()
        ..color = const Color(0xFF2E2B27).withOpacity(0.14)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    }

    // 2. Cardstock Fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Tonal Stroke Outline
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

    const bodyRadius = 20.0;
    final slotWidth = w / totalSlots;
    final tabLeft = tabSlot * slotWidth;
    final tabRight = tabLeft + slotWidth;

    // 1. Top-left body shoulder
    path.moveTo(0, tabHeight + bodyRadius);
    path.quadraticBezierTo(0, tabHeight, bodyRadius, tabHeight);

    // 2. Body shelf to left slant
    path.lineTo(tabLeft - 22, tabHeight);
    // Left concave fillet scooping up
    path.quadraticBezierTo(
      tabLeft - 10, tabHeight,
      tabLeft - 6, tabHeight - 8,
    );
    // Left diagonal slant
    path.lineTo(tabLeft, 8);
    // Left convex rounding onto tab top shelf
    path.quadraticBezierTo(tabLeft + 3, 0, tabLeft + 16, 0);

    // 3. Tab top edge across
    path.lineTo(tabRight - 16, 0);

    // 4. Right slant
    path.quadraticBezierTo(tabRight - 3, 0, tabRight, 8);
    path.lineTo(tabRight + 6, tabHeight - 8);
    path.quadraticBezierTo(
      tabRight + 10, tabHeight,
      tabRight + 22, tabHeight,
    );

    // 5. Body shelf to right shoulder
    path.lineTo(w - bodyRadius, tabHeight);
    path.quadraticBezierTo(w, tabHeight, w, tabHeight + bodyRadius);

    // 6. Right edge, bottom edge, left edge back up
    path.lineTo(w, h - bodyRadius);
    path.quadraticBezierTo(w, h, w - bodyRadius, h);
    path.lineTo(bodyRadius, h);
    path.quadraticBezierTo(0, h, 0, h - bodyRadius);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant FloorBinderPainter oldDelegate) =>
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.tabHeight != tabHeight ||
      oldDelegate.tabSlot != tabSlot ||
      oldDelegate.totalSlots != totalSlots;
}