// lib/src/presentation/home/widgets/folder_stack/spreads/widgets/memo_paper_stack.dart
import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/svg_hard_shadow.dart';

class MemoPaperStack extends StatelessWidget {
  const MemoPaperStack({super.key});

  // Tonal shadow tokens matching the warm paper aesthetic
  static const Color _kFolderDropShadow = Color.fromARGB(62, 44, 38, 32);
  static const Color _kSheetContactShadow = Color(0x1F6B5848);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // =========================================================
        // 1. UNDER-SHEET (Offset / Backing Deckled Sheet)
        // Casts a hard shadow onto the binder surface
        // =========================================================
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 18,
              left: 4.0,
              right: 6.0,
              bottom: 4.0,
            ),
            child: const SvgHardShadow(
              assetPath: 'assets/images/svg_assets/memo_binder/card.svg',
              offset: Offset(2, 3.5),
              shadowColor: _kFolderDropShadow,
              fit: BoxFit.fill,
            ),
          ),
        ),

        // =========================================================
        // 2. TOP-SHEET (Perforated Memo Sheet)
        // Casts a distinct contact shadow onto the backing sheet
        // =========================================================
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 2.0,
              bottom: 10,
            ),
            child: const SvgHardShadow(
              assetPath: 'assets/images/svg_assets/memo_binder/punched_paper.svg',
              offset: Offset(3, 6),
              shadowColor: Color.fromARGB(62, 44, 38, 32),
              fit: BoxFit.fill,
            ),
          ),
        ),

        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 1,
              right: 250,
              bottom: 230,
            ),
            child: const SvgHardShadow(
              assetPath: 'assets/images/svg_assets/memo_binder/tape.svg',
              offset: Offset(1, 2),
              shadowColor: _kSheetContactShadow,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}