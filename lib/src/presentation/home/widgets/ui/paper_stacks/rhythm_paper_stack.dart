// lib/src/presentation/home/widgets/folder_stack/spreads/widgets/rhythm_paper_stack.dart
import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/svg_hard_shadow.dart';

class RhythmPaperStack extends StatelessWidget {
  const RhythmPaperStack({super.key});

  // Tonal shadow colors for ink-on-paper look
  static const Color _kBinderShadow = Color.fromARGB(62, 44, 38, 32);// Shadow onto folder
  static const Color _kPaperContactShadow = Color(0x1F5A3E36); // Shadow of top sheet onto bottom sheet

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // =========================================================
        // 1. UNDER-SHEET (Tilted / Offset Backing Sheet)
        // =========================================================
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 6.0, right: 2.0, bottom: 2.0),
            child: const SvgHardShadow(
              assetPath: 'assets/images/svg_assets/rhythm_binder/bottom_card.svg',
              offset: Offset(1, 3.5),
              shadowColor: _kBinderShadow,
              fit: BoxFit.fill,
            ),
          ),
        ),

        // =========================================================
        // 2. TOP-SHEET (Main writing surface)
        // Casts a distinct hard contact shadow onto the backing sheet
        // =========================================================
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 6.0, bottom: 8.0),
            child: const SvgHardShadow(
              assetPath: 'assets/images/svg_assets/rhythm_binder/top_card.svg',
              offset: Offset(2.5, 3.0),
              shadowColor: _kPaperContactShadow,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}