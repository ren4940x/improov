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
  static const kRhythmsFill = Color(0xFFFDEEEB);
  static const kRhythmsBorder = Color(0xFFD39A88);
  static const kMemosFill = Color(0xFFFFFBF0);
  static const kMemosBorder = Color(0xFFEADCC6);

  void _switchTab(int index) {
    if (_activeTab == index) return;
    HapticFeedback.lightImpact();
    setState(() => _activeTab = index);
  }

  @override
  Widget build(BuildContext context) {
    const tabHeight = 42.0;
    const tabWidth = 130.0;
    const memosOffset = 116.0;

    // 1. Physical Rhythms Folder Shell
    final rhythmsFolder = CustomPaint(
      painter: RhythmsBinderPainter(
        fillColor: kRhythmsFill,
        borderColor: kRhythmsBorder,
        hasShadow: _activeTab == 0,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: tabHeight + 14,
          left: 16,
          right: 16,
          bottom: 14,
        ),
        child: widget.rhythmsContent ?? const RhythmsSpread(),
      ),
    );

    // 2. Physical Memos Folder Shell
    final memosFolder = CustomPaint(
      painter: MemosBinderPainter(
        fillColor: kMemosFill,
        borderColor: kMemosBorder,
        hasShadow: _activeTab == 1,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
        tabLeftOffset: memosOffset,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: tabHeight + 14,
          left: 16,
          right: 16,
          bottom: 14,
        ),
        child: widget.memosContent ?? const MemosSpread(),
      ),
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
                "rhythms",
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
                "memos",
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
        // 3. TAB HIT-TEST TARGETS (Pinned over tab ear geometry)
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