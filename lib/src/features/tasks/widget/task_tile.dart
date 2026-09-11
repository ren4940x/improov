// lib/src/features/tasks/widget/task_tile.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/core/widgets/custom_checkbox.dart';
import 'package:improov/src/core/widgets/focused_menu_wrapper.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:improov/src/features/tasks/provider/task_notifier.dart';
import 'package:improov/src/features/tasks/widget/task_popup.dart';
import 'package:improov/src/presentation/home/widgets/modals/screen/modal.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TaskTile extends ConsumerStatefulWidget {
  final Task task;
  final bool isCompleted;
  final Function(bool?)? onChanged;

  const TaskTile({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  bool _isExpanded = false;

  // Memo stationery color tokens matching the warm kraft memo pad
  static const Color _kMemoInk = Color(0xFF7C5B3F);
  static const Color _kMemoMuted = Color(0xFFA68D75);
  static const Color _kCaretColor = Color(0xFF9E8569);
  static const Color _kSubtaskBranchColor = Color(0xFFD6C19D);

  void onEditPressed(BuildContext context) {
    showModalBottomSheet(
      context: Navigator.of(context, rootNavigator: true).context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Modal(taskToEdit: widget.task, isUpdating: true),
    );
  }

  void onDeletePressed() {
    ref.read(taskProvider.notifier).deleteTask(widget.task.id);
  }

  @override
  Widget build(BuildContext context) {
    final hasSubtasks = widget.task.subtasks.isNotEmpty;

    return FocusedMenuWrapper(
      onEdit: () => onEditPressed(context),
      onDelete: onDeletePressed,
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
                  TaskPopup(task: widget.task),
                ],
              );
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- MAIN TASK ROW ---
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              HapticFeedback.lightImpact();
              ref
                  .read(taskProvider.notifier)
                  .updateTaskCompletion(widget.task.id, !widget.task.isCompleted);
              widget.onChanged?.call(!widget.task.isCompleted);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    // Checkbox
                    Transform.scale(
                      scale: 1.15,
                      child: CustomCheckbox(
                        value: widget.isCompleted,
                        onChanged: widget.onChanged,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Task Name (Warm Sepia / Monospace Type)
                    Expanded(
                      child: Text(
                        widget.task.title.toLowerCase(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: widget.isCompleted
                              ? _kMemoMuted
                              : _kMemoInk,
                          decoration: widget.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: _kMemoMuted,
                          fontStyle: widget.isCompleted
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),

                    // Subtask Caret
                    if (hasSubtasks)
                      IconButton(
                        onPressed: () {
                          setState(() => _isExpanded = !_isExpanded);
                        },
                        icon: Icon(
                          _isExpanded
                              ? PhosphorIconsRegular.caretUp
                              : PhosphorIconsRegular.caretDown,
                          color: _kCaretColor,
                          size: 18,
                        ),
                        padding: const EdgeInsets.all(6.0),
                        splashRadius: 18,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // --- SUBTASKS TREE ---
          if (hasSubtasks)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: double.infinity,
                height: _isExpanded ? null : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    top: 2,
                    bottom: 4,
                    right: 12,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: _kSubtaskBranchColor,
                          width: 1.8,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Column(
                      children: widget.task.subtasks.map((subtask) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: FocusedMenuWrapper(
                            onEdit: () {
                              showModalBottomSheet(
                                context: Navigator.of(context, rootNavigator: true).context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (context) => Modal(
                                  taskToEdit: widget.task,
                                  isUpdating: true,
                                  autoFocusSubtaskUuid: subtask.uuid,
                                ),
                              );
                            },
                            onDelete: () {
                              ref.read(taskProvider.notifier).deleteSubtask(
                                    widget.task.id,
                                    subtask.uuid,
                                  );
                            },
                            onDetails: () {},
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(taskProvider.notifier).toggleSubtaskCompletion(
                                      widget.task.id,
                                      subtask.uuid,
                                      !subtask.isCompleted,
                                    );
                              },
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.95,
                                    child: CustomCheckbox(
                                      value: subtask.isCompleted,
                                      onChanged: (val) {
                                        ref.read(taskProvider.notifier).toggleSubtaskCompletion(
                                              widget.task.id,
                                              subtask.uuid,
                                              val ?? false,
                                            );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      (subtask.title ?? '').toLowerCase(),
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: subtask.isCompleted
                                            ? _kMemoMuted
                                            : _kMemoInk,
                                        decoration: subtask.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: _kMemoMuted,
                                        fontStyle: subtask.isCompleted
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}