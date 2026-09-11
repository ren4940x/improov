// lib/src/presentation/shop/widgets/binders/items_binder.dart
import 'package:flutter/material.dart';

class ItemsBinder extends StatelessWidget {
  final Widget? child;
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const ItemsBinder({
    super.key,
    this.child,
    this.hasShadow = true,
    this.fillColor = const Color(0xFFA6D6B6), // Mint / Sage Green
    this.borderColor = const Color(0xFF7CAE8D), // Tonal dark sage border
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 2, // Slot 2 (Middle-right tab in 1/4-cut system)
    this.totalSlots = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ItemsBinderPainter(
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

class ItemsBinderPainter extends CustomPainter {
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const ItemsBinderPainter({
    this.hasShadow = true,
    this.fillColor = const Color(0xFFA6D6B6),
    this.borderColor = const Color(0xFF7CAE8D),
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 2,
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

    // 2. Left Slanted Transition (Scoops up into Tab 2)
    path.lineTo(tabLeft - 22, tabHeight);
    path.quadraticBezierTo(
      tabLeft - 10, tabHeight,
      tabLeft - 6, tabHeight - 8,
    );
    path.lineTo(tabLeft, 8);
    path.quadraticBezierTo(tabLeft + 3, 0, tabLeft + 16, 0);

    // 3. Tab Top Shelf Edge across
    path.lineTo(tabRight - 16, 0);

    // 4. Right Slanted Transition (Scoops down to body shelf)
    path.quadraticBezierTo(tabRight - 3, 0, tabRight, 8);
    path.lineTo(tabRight + 6, tabHeight - 8);
    path.quadraticBezierTo(
      tabRight + 10, tabHeight,
      tabRight + 22, tabHeight,
    );

    // 5. Right Body Shelf to Shoulder
    path.lineTo(w - bodyRadius, tabHeight);
    path.quadraticBezierTo(w, tabHeight, w, tabHeight + bodyRadius);

    // 6. Perimeter: Right edge, Bottom edge, Left edge back up
    path.lineTo(w, h - bodyRadius);
    path.quadraticBezierTo(w, h, w - bodyRadius, h);
    path.lineTo(bodyRadius, h);
    path.quadraticBezierTo(0, h, 0, h - bodyRadius);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant ItemsBinderPainter oldDelegate) =>
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.tabHeight != tabHeight ||
      oldDelegate.tabSlot != tabSlot ||
      oldDelegate.totalSlots != totalSlots;
}