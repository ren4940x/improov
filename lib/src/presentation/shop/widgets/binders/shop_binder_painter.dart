// lib/src/presentation/shop/widgets/shop_binder_painter.dart
import 'package:flutter/material.dart';

class ShopBinderPainter extends CustomPainter {
  final int tabIndex; // 0 to 6
  final int totalTabs; // 7 tabs
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasShadow;
  final double tabHeight;

  const ShopBinderPainter({
    required this.tabIndex,
    this.totalTabs = 7,
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2.0,
    this.hasShadow = true,
    this.tabHeight = 28.0, // Scaled down to prevent tab pinching
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
    const tabRadius = 8.0; // Proportional to ~50px tab width
    const filletRadius = 6.0;

    final tabWidth = w / totalTabs;
    final tabLeft = tabIndex * tabWidth;
    final tabRight = tabLeft + tabWidth;

    // Start at bottom-left corner
    path.moveTo(0, h - bodyRadius);
    path.quadraticBezierTo(0, h, bodyRadius, h);

    // Bottom edge across to bottom-right corner
    path.lineTo(w - bodyRadius, h);
    path.quadraticBezierTo(w, h, w, h - bodyRadius);

    if (tabIndex == totalTabs - 1) {
      // ========================================================
      // CASE A: FAR-RIGHT TAB (Active Tab 6 in mockup)
      // ========================================================
      // Right edge straight up into tab outer corner
      path.lineTo(w, tabRadius);
      path.quadraticBezierTo(w, 0, w - tabRadius, 0);

      // Tab top shelf moving left
      path.lineTo(tabLeft + tabRadius, 0);
      path.quadraticBezierTo(tabLeft, 0, tabLeft, tabRadius);

      // Down the tab left vertical edge
      path.lineTo(tabLeft, tabHeight - filletRadius);

      // Left concave fillet scooping into body shelf
      path.quadraticBezierTo(
        tabLeft, tabHeight,
        tabLeft - filletRadius, tabHeight,
      );

      // Body top shelf to top-left corner
      path.lineTo(bodyRadius, tabHeight);
      path.quadraticBezierTo(0, tabHeight, 0, tabHeight + bodyRadius);

      // Left edge down
      path.lineTo(0, h - bodyRadius);
    } else if (tabIndex == 0) {
      // ========================================================
      // CASE B: FAR-LEFT TAB (Tab 0)
      // ========================================================
      // Right edge up to body top shelf
      path.lineTo(w, tabHeight + bodyRadius);
      path.quadraticBezierTo(w, tabHeight, w - bodyRadius, tabHeight);

      // Body shelf to tab right
      path.lineTo(tabRight + filletRadius, tabHeight);

      // Right concave fillet scooping up to tab
      path.quadraticBezierTo(
        tabRight, tabHeight,
        tabRight, tabHeight - filletRadius,
      );

      // Tab right edge up
      path.lineTo(tabRight, tabRadius);
      path.quadraticBezierTo(tabRight, 0, tabRight - tabRadius, 0);

      // Tab top edge to top-left corner
      path.lineTo(tabRadius, 0);
      path.quadraticBezierTo(0, 0, 0, tabRadius);

      // Left edge down
      path.lineTo(0, h - bodyRadius);
    } else {
      // ========================================================
      // CASE C: MIDDLE TABS (Tabs 1 to 5)
      // ========================================================
      // Right edge up to body shelf
      path.lineTo(w, tabHeight + bodyRadius);
      path.quadraticBezierTo(w, tabHeight, w - bodyRadius, tabHeight);

      // Body shelf to tab right
      path.lineTo(tabRight + filletRadius, tabHeight);

      // Right concave fillet scooping up to tab
      path.quadraticBezierTo(
        tabRight, tabHeight,
        tabRight, tabHeight - filletRadius,
      );

      // Tab right edge up
      path.lineTo(tabRight, tabRadius);
      path.quadraticBezierTo(tabRight, 0, tabRight - tabRadius, 0);

      // Tab top edge
      path.lineTo(tabLeft + tabRadius, 0);
      path.quadraticBezierTo(tabLeft, 0, tabLeft, tabRadius);

      // Tab left edge down
      path.lineTo(tabLeft, tabHeight - filletRadius);

      // Left concave fillet scooping into body shelf
      path.quadraticBezierTo(
        tabLeft, tabHeight,
        tabLeft - filletRadius, tabHeight,
      );

      // Left body shelf to top-left corner
      path.lineTo(bodyRadius, tabHeight);
      path.quadraticBezierTo(0, tabHeight, 0, tabHeight + bodyRadius);

      // Left edge down
      path.lineTo(0, h - bodyRadius);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ShopBinderPainter oldDelegate) =>
      oldDelegate.tabIndex != tabIndex ||
      oldDelegate.totalTabs != totalTabs ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.tabHeight != tabHeight;
}