// lib/src/core/widgets/svg_hard_shadow.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgHardShadow extends StatelessWidget {
  final String assetPath;
  final Offset offset;
  final Color shadowColor;
  final BoxFit fit;

  const SvgHardShadow({
    super.key,
    required this.assetPath,
    this.offset = const Offset(0, 3.5),
    this.shadowColor = const Color(0x2E2E2B27), // ~18% opacity Sumi Ink
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        // 1. Hard Shadow Silhouette
        Transform.translate(
          offset: offset,
          child: SvgPicture.asset(
            assetPath,
            fit: fit,
            colorFilter: ColorFilter.mode(
              shadowColor,
              BlendMode.srcIn,
            ),
          ),
        ),

        // 2. Original Vector Artwork
        SvgPicture.asset(
          assetPath,
          fit: fit,
        ),
      ],
    );
  }
}