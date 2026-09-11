// lib/src/presentation/shop/widgets/binders/wall_binder.dart
import 'package:flutter/material.dart';

class WallBinder extends StatelessWidget {
  final Widget? child;
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const WallBinder({
    super.key,
    this.child,
    this.hasShadow = true,
    this.fillColor = const Color(0xFFF7E4DC), // Pale Peach cardstock
    this.borderColor = const Color(0xFFDEBAAC), // Tonal peach border
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 0, // Slot 0 (Far-left tab)
    this.totalSlots = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WallBinderPainter(
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

class WallBinderPainter extends CustomPainter {
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final int tabSlot;
  final int totalSlots;

  const WallBinderPainter({
    this.hasShadow = true,
    this.fillColor = const Color(0xFFF7E4DC),
    this.borderColor = const Color(0xFFDEBAAC),
    this.borderWidth = 2.2,
    this.tabHeight = 32.0,
    this.tabSlot = 0,
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
    const tabRadius = 18.0;

    final slotWidth = w / totalSlots;
    final tabRight = (tabSlot + 1) * slotWidth;

    // 1. Start top-left corner (flush with left edge)
    path.moveTo(0, tabRadius);
    path.quadraticBezierTo(0, 0, tabRadius, 0);

    // 2. Tab top horizontal edge moving right
    path.lineTo(tabRight - 16, 0);

    // 3. Slanted Transition (Mirrors RhythmsBinderPainter)
    // A. Convex top curve into the slant
    path.quadraticBezierTo(tabRight - 3, 0, tabRight, 8);
    // B. Diagonal slanted drop
    path.lineTo(tabRight + 6, tabHeight - 8);
    // C. Concave fillet scooping into the flat body shelf
    path.quadraticBezierTo(
      tabRight + 10, tabHeight,
      tabRight + 22, tabHeight,
    );

    // 4. Body top shelf moving right to shoulder
    path.lineTo(w - bodyRadius, tabHeight);
    path.quadraticBezierTo(w, tabHeight, w, tabHeight + bodyRadius);

    // 5. Right body edge straight down
    path.lineTo(w, h - bodyRadius);
    path.quadraticBezierTo(w, h, w - bodyRadius, h);

    // 6. Bottom edge across to bottom-left corner
    path.lineTo(bodyRadius, h);
    path.quadraticBezierTo(0, h, 0, h - bodyRadius);

    // 7. Left edge straight up to close
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant WallBinderPainter oldDelegate) =>
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.tabHeight != tabHeight ||
      oldDelegate.tabSlot != tabSlot ||
      oldDelegate.totalSlots != totalSlots;
}