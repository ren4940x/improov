import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/presentation/home/widgets/folder_stack/binders/memos_binder_painter.dart';
import 'package:improov/src/presentation/home/widgets/folder_stack/binders/rhythms_binder_painter.dart';

class StationeryFolderStack extends StatefulWidget {
  final Widget rhythmsContent;
  final Widget memosContent;

  const StationeryFolderStack({
    super.key,
    required this.rhythmsContent,
    required this.memosContent,
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

    // Build the two discrete physical folders
    final rhythmsFolder = CustomPaint(
      painter: RhythmsBinderPainter(
        fillColor: kRhythmsFill,
        borderColor: kRhythmsBorder,
        hasShadow: _activeTab == 0,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: tabHeight + 14, left: 16, right: 16, bottom: 14),
        child: widget.rhythmsContent,
      ),
    );

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
        padding: const EdgeInsets.only(top: tabHeight + 14, left: 16, right: 16, bottom: 14),
        child: widget.memosContent,
      ),
    );

    return Stack(
      children: [
        // 1. Z-INDEX LAYERING: Last item in the list renders in front
        if (_activeTab == 0) ...[
          Positioned.fill(child: memosFolder),
          Positioned.fill(child: rhythmsFolder),
        ] else ...[
          Positioned.fill(child: rhythmsFolder),
          Positioned.fill(child: memosFolder),
        ],

        // 2. TAB LABELS (Anchored to their physical tab positions)
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

        // 3. HIT-TEST GESTURE TARGETS (Floating above everything)
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