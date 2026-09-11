// lib/src/presentation/home/widgets/folder_stack/spreads/memos_spread.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/widgets/svg_hard_shadow.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/tasks/widget/task_tile.dart';

class MemosSpread extends ConsumerWidget {
  const MemosSpread({super.key});

  // Tonal tokens matching the perforated memo sheet aesthetic
  static const Color _kMemoInk = Color(0xFF7C5B3F);
  static const Color _kProgressColor = Color(0xFFD6C19D);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // =========================================================
            // 1. TORN & PERFORATED MEMO SHEET (SVG Background)
            // IgnorePointer ensures drags fall right through to the ListView
            // =========================================================
            Positioned(
              top: -16.0,
              bottom: -6.0,
              left: -12.0,
              right: -8.0,
              child: IgnorePointer(
                child: const SvgHardShadow(
                  assetPath: 'assets/images/svg_assets/memo_card_stack.svg',
                  offset: Offset(0, 3.5),
                  shadowColor: Color(0x2E2E2B27),
                ),
              ),
            ),
            
            // =========================================================
            // 2. SCROLLABLE TASK LIST
            // Inset top clears the punch-holes; bottom clears the torn edge
            // =========================================================
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 66, 12, 32),
                child: tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return const Center(
                        child: Text(
                          "all tasks cleared~",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: _kMemoInk,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          isCompleted: task.isCompleted,
                          onChanged: (val) {
                            ref
                                .read(taskProvider.notifier)
                                .updateTaskCompletion(task.id, val ?? false);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _kProgressColor,
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      "failed to load memos: $err",
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