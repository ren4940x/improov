// lib/src/presentation/home/screens/rough_wireframe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/presentation/home/widgets/folder_stack/stationery_folder_stack.dart';

class RoughWireframeScreen extends ConsumerWidget {
  const RoughWireframeScreen({super.key});

  static const kBgColor = Color(0xFFFAF5E8);
  static const kBorderColor = Color(0xFF2E2B27);
  static const kHabitPill = Color(0xFFFDECEB);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 4.0),
          child: Column(
            children: [
              // ==========================================
              // 1. TOP DIORAMA FRAME (50% split)
              // ==========================================
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kBorderColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColor,
                        offset: Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center Isometric Room Asset
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/room_preview.jpg',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      ),

                      // Top-Left: Statistics Trigger (Dossier Sheet)
                      Positioned(
                        top: 14,
                        left: 14,
                        child: GestureDetector(
                          onTap: () => _openStatsModal(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: kHabitPill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kBorderColor, width: 2),
                            ),
                            child: const Icon(Icons.bar_chart_rounded, size: 22, color: kBorderColor),
                          ),
                        ),
                      ),

                      // Top-Right: Sparks Currency Badge (Live Riverpod State)
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: kHabitPill,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kBorderColor, width: 2),
                          ),
                        ),
                      ),

                      // Bottom-Right: Desk / Focus Mode Launcher
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: GestureDetector(
                          onTap: () => context.push('/desk-mode'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4A8A6),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kBorderColor, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: kBorderColor,
                                  offset: Offset(0, 2),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.hourglass_bottom_rounded, size: 20, color: kBorderColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==========================================
              // 2. BOTTOM FOLDER & HABIT LIST (50% split)
              // ==========================================
              const Expanded(
                child: StationeryFolderStack(
                  rhythmsContent: Center(child: Text("Rhythms content mounting...")),
                  memosContent: Center(child: Text("Memos content mounting...")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStatsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 380,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF5E8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorderColor, width: 2),
        ),
        child: const Center(
          child: Text(
            "📊 RESIDENT STATS & STREAK DOSSIER",
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}