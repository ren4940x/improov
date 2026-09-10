// lib/src/presentation/diary/widgets/binders/profile_binder.dart
import 'package:flutter/material.dart';

class ProfileBinder extends StatelessWidget {
  final Widget? child;
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final double tabExtension;

  const ProfileBinder({
    super.key,
    this.child,
    this.hasShadow = true,
    this.fillColor = const Color(0xFFA29FD4), // Soft Lavender cardstock
    this.borderColor = const Color(0xFF8481B5),
    this.borderWidth = 2.0,
    this.tabHeight = 120.0,
    this.tabExtension = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ProfileBinderPainter(
        hasShadow: hasShadow,
        fillColor: fillColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        tabHeight: tabHeight,
        tabExtension: tabExtension,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 18.0,
          left: 18.0,
          bottom: 18.0,
          right: tabExtension + 18.0, // Protects content from bleeding into the tab
        ),
        child: child,
      ),
    );
  }
}

class ProfileBinderPainter extends CustomPainter {
  final bool hasShadow;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double tabHeight;
  final double tabExtension;

  const ProfileBinderPainter({
    this.hasShadow = true,
    this.fillColor = const Color(0xFFA29FD4),
    this.borderColor = const Color(0xFF8481B5),
    this.borderWidth = 2.0,
    this.tabHeight = 120.0,
    this.tabExtension = 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // 1. Hard Paper Drop Shadow
    if (hasShadow) {
      final shadowPaint = Paint()
        ..color = const Color(0xFF2E2B27).withOpacity(0.18)
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
    final bodyWidth = w - tabExtension;

    const cornerRadius = 20.0;
    const tabCornerRadius = 14.0;
    const filletRadius = 14.0;

    final tabTop = h - tabHeight;

    // 1. Start at top-left corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // 2. Top body edge
    path.lineTo(bodyWidth - cornerRadius, 0);
    path.quadraticBezierTo(bodyWidth, 0, bodyWidth, cornerRadius);

    // 3. Down the right body edge towards the tab top shelf
    path.lineTo(bodyWidth, tabTop - filletRadius);

    // 4. Upper Concave Fillet (curves outward onto tab shelf)
    path.quadraticBezierTo(
      bodyWidth, tabTop,
      bodyWidth + filletRadius, tabTop,
    );

    // 5. Tab top shelf moving right
    path.lineTo(w - tabCornerRadius, tabTop);
    path.quadraticBezierTo(w, tabTop, w, tabTop + tabCornerRadius);

    // 6. Tab outer vertical edge straight down to bottom-right corner
    path.lineTo(w, h - tabCornerRadius);
    path.quadraticBezierTo(w, h, w - tabCornerRadius, h);

    // 7. Continuous bottom edge all the way across both tab and body
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);

    // 8. Left edge back up to top
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant ProfileBinderPainter oldDelegate) =>
      oldDelegate.hasShadow != hasShadow ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.tabHeight != tabHeight ||
      oldDelegate.tabExtension != tabExtension;
}