// lib/src/presentation/home/screens/diary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/presentation/diary/widgets/binders/calendar_binder.dart';
import 'package:improov/src/presentation/diary/widgets/binders/card_binder.dart';
import 'package:improov/src/presentation/diary/widgets/binders/profile_binder.dart';
import 'package:improov/src/presentation/diary/widgets/binders/record_binder.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _activeTabIndex = 1;

  static const kBgCanvas = Color(0xFFFAF5E8);
  static const double _kTabHeight = 120.0;
  static const double _kTabExtension = 40.0;

  void _switchTab(int index) {
    if (_activeTabIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() => _activeTabIndex = index);
  }

  Widget _buildBinder({required int index, required bool isActive}) {
    switch (index) {
      case 0:
        return CalendarBinder(
          hasShadow: isActive,
          tabBottomOffset: _kTabHeight * 3,
          tabHeight: _kTabHeight,
          tabExtension: _kTabExtension,
        );
      case 1:
        return RecordBinder(
          hasShadow: isActive,
          tabBottomOffset: _kTabHeight * 2,
          tabHeight: _kTabHeight,
          tabExtension: _kTabExtension,
        );
      case 2:
        return CardBinder(
          hasShadow: isActive,
          tabBottomOffset: _kTabHeight * 1,
          tabHeight: _kTabHeight,
          tabExtension: _kTabExtension,
        );
      case 3:
        return ProfileBinder(
          hasShadow: isActive,
          tabHeight: _kTabHeight,
          tabExtension: _kTabExtension,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inactives painted bottom-to-top (3 -> 2 -> 1 -> 0) so upper tabs overlap lower ones
    final inactiveIndices = [3, 2, 1, 0].where((i) => i != _activeTabIndex);

    return Scaffold(
      backgroundColor: kBgCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // 1. DYNAMIC Z-INDEX BINDER STACK
              // ==========================================================
              Expanded(
                child: Stack(
                  children: [
                    // A. INACTIVE BINDERS (Underneath)
                    for (final index in inactiveIndices)
                      Positioned.fill(
                        child: _buildBinder(index: index, isActive: false),
                      ),

                    // B. ACTIVE BINDER (Painted last = Front of Z-Index)
                    Positioned.fill(
                      child: _buildBinder(index: _activeTabIndex, isActive: true),
                    ),

                    // C. INVISIBLE HIT TARGETS (Bottom-anchored)
                    ...List.generate(4, (index) {
                      final bottomOffset = (3 - index) * _kTabHeight;

                      return Positioned(
                        bottom: bottomOffset,
                        right: 0,
                        width: _kTabExtension + 24.0,
                        height: _kTabHeight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _switchTab(index),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}