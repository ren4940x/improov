// lib/src/presentation/home/widgets/folder_stack/stationery_folder_stack.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/presentation/home/widgets/ui/binders/memos_binder_painter.dart';
import 'package:improov/src/presentation/home/widgets/ui/binders/rhythms_binder_painter.dart';
import 'package:improov/src/presentation/home/widgets/ui/spreads/memos_spread.dart';
import 'package:improov/src/presentation/home/widgets/ui/spreads/rhythms_spread.dart';

class StationeryFolderStack extends StatefulWidget {
  final Widget? rhythmsContent;
  final Widget? memosContent;

  const StationeryFolderStack({
    super.key,
    this.rhythmsContent,
    this.memosContent,
  });

  @override
  State<StationeryFolderStack> createState() => _StationeryFolderStackState();
}

class _StationeryFolderStackState extends State<StationeryFolderStack> {
  int _activeTab = 0; // 0 = Rhythms, 1 = Memos

  // Styling Tokens
  static const kSumiInk = Color(0xFF2E2B27);
  static const kRhythmsFill = Color.fromARGB(255, 233, 217, 204);
  static const kRhythmsBorder = Color.fromARGB(255, 192, 152, 122);
  static const kMemosFill = Color.fromARGB(255, 250, 233, 186);
  static const kMemosBorder = Color.fromARGB(255, 250, 233, 186);


  void _switchTab(int index) {
    if (_activeTab == index) return;
    HapticFeedback.lightImpact();
    setState(() => _activeTab = index);
  }

  // Helper to build a physical folder with the shared clean paper backing
  Widget _buildFolderShell({
    required CustomPainter painter,
    required Widget content,
    required double tabHeight,
  }) {
    return CustomPaint(
      painter: painter,
      child: Padding(
        padding: EdgeInsets.only(
          top: tabHeight + 14,
          left: 14,
          right: 14,
          bottom: 14,
        ),
        child: Stack(
          children: [

            //Spread Content (Pink notes / Memos pad)
            Positioned.fill(
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const tabHeight = 42.0;
    const tabWidth = 130.0;
    const memosOffset = 116.0;

    // 1. Physical Rhythms Folder Shell
    final rhythmsFolder = _buildFolderShell(
      painter: RhythmsBinderPainter(
        fillColor: kRhythmsFill,
        borderColor: kRhythmsBorder,
        hasShadow: _activeTab == 0,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
      ),
      tabHeight: tabHeight,
      content: widget.rhythmsContent ?? const RhythmsSpread(),
    );

    // 2. Physical Memos Folder Shell
    final memosFolder = _buildFolderShell(
      painter: MemosBinderPainter(
        fillColor: kMemosFill,
        borderColor: kMemosBorder,
        hasShadow: _activeTab == 1,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
        tabLeftOffset: memosOffset,
      ),
      tabHeight: tabHeight,
      content: widget.memosContent ?? const MemosSpread(),
    );

    return Stack(
      children: [
        // =========================================================
        // 1. Z-INDEX LAYERING (Active folder paints last on top)
        // =========================================================
        if (_activeTab == 0) ...[
          Positioned.fill(child: memosFolder),
          Positioned.fill(child: rhythmsFolder),
        ] else ...[
          Positioned.fill(child: rhythmsFolder),
          Positioned.fill(child: memosFolder),
        ],

        // =========================================================
        // 2. DIEGETIC TAB LABELS
        // =========================================================
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            height: tabHeight,
            width: tabWidth,
            child: Center(
              child: Text(
                "Rhythms",
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                  color: _activeTab == 0 ? kSumiInk : kSumiInk.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: memosOffset,
          child: SizedBox(
            height: tabHeight,
            width: tabWidth,
            child: Center(
              child: Text(
                "Memos",
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                  color: _activeTab == 1 ? kSumiInk : kSumiInk.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),

        // =========================================================
        // 3. TAB HIT-TEST TARGETS
        // =========================================================
        Positioned(
          top: 0,
          left: 0,
          height: tabHeight,
          width: tabWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _switchTab(0),
          ),
        ),

        Positioned(
          top: 0,
          left: memosOffset,
          height: tabHeight,
          width: tabWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _switchTab(1),
          ),
        ),
      ],
    );
  }
}