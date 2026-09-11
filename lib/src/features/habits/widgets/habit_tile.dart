// lib/src/features/habits/widgets/habit_tile.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:improov/src/features/habits/provider/habit_notifier.dart';
import 'package:improov/src/features/habits/widgets/habit_popup.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';

class HabitTile extends ConsumerWidget {
  final Habit habit;
  final Function(bool?)? onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    this.onChanged,
  });

  // Color tokens matching the stationery pill aesthetic
  static const Color _kPillBg = Color(0xFFFDF0F0);
  static const Color _kPillBorder = Color(0xFFE2A8B0);
  static const Color _kTextColor = Color(0xFF5A443B);
  static const Color _kPawWatermark = Color(0xFFE5D5D5);

  void _onEditPressed(BuildContext context) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(
        habitToEdit: habit,
        isUpdating: true,
      ),
    );
  }

  void _onDeletePressed(WidgetRef ref, int id) {
    ref.read(habitProvider.notifier).deleteHabit(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime today = DateTime.now();
    final bool isCompletedToday = habit.completedDays.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);

    return FocusedMenuWrapper(
      onEdit: () => _onEditPressed(context),
      onDelete: () => _onDeletePressed(ref, habit.id),
      onDetails: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context, rootNavigator: true).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Stack(
                children: [
                  FadeTransition(
                    opacity: animation,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  HabitPopup(habit: habit),
                ],
              );
            },
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(habitProvider.notifier).updateHabitCompletion(
                habit.id,
                !isCompletedToday,
              );
          onChanged?.call(!isCompletedToday);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 12, top: 16, left:20),
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _kPillBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _kPillBorder,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // 1. Skeuomorphic Circular Stamp / Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompletedToday ? _kPillBorder : Colors.transparent,
                    border: Border.all(
                      color: _kPillBorder,
                      width: 2.4,
                    ),
                  ),
                  child: isCompletedToday
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 14),

                // 2. Habit Title (Monospace type)
                Expanded(
                  child: Text(
                    habit.name.toLowerCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCompletedToday
                          ? _kTextColor.withOpacity(0.45)
                          : _kTextColor,
                      decoration:
                          isCompletedToday ? TextDecoration.lineThrough : null,
                      decorationColor: _kTextColor.withOpacity(0.45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 3. Paw Stamp Watermark
                const Icon(
                  Icons.pets_rounded,
                  size: 20,
                  color: _kPawWatermark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}