// lib/src/presentation/home/widgets/folder_stack/spreads/rhythms_spread.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/widgets/svg_hard_shadow.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/features/habits/widgets/habit_tile.dart';

class RhythmsSpread extends ConsumerWidget {
  const RhythmsSpread({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // =========================================================
            // 1. TILTED PAPER SHEETS (SVG Background)
            // IgnorePointer ensures touches pass straight to the list
            // =========================================================
            Positioned.fill(
              child: IgnorePointer(
                child: const SvgHardShadow(
                  assetPath: 'assets/images/svg_assets/rhythm_card_stack.svg',
                  offset: Offset(0, 3.5),
                  shadowColor: Color(0x2E2E2B27),
                ),
              ),
            ),

            // =========================================================
            // 2. SCROLLABLE HABIT TILES (Unwrapped from AsyncValue)
            // =========================================================
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 22.0, 16.0, 16.0),
                child: habitsAsync.when(
                  data: (habits) {
                    if (habits.isEmpty) {
                      return const Center(
                        child: Text(
                          "No rhythms, yet~",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF5A443B),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      itemCount: habits.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return HabitTile(
                          habit: habit,
                          onChanged: (val) {
                            ref
                              .read(habitProvider.notifier)
                              .updateHabitCompletion(habit.id, val ?? false);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFE2A8B0),
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      "failed to load rhythms: $err",
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}