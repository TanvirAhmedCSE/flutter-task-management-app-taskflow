import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../models/enums.dart';
import '../../theme/app_colors.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final int index;
  final int totalCount;
  final bool isDragEnabled;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final VoidCallback onStar;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.totalCount,
    required this.isDragEnabled,
    required this.onComplete,
    required this.onDelete,
    required this.onStar,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onTap,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-0.28, 0)).animate(
      CurvedAnimation(
          parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Color get _priorityColor {
    switch (widget.task.priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMed;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  Color get _priorityBg {
    switch (widget.task.priority) {
      case Priority.high:
        return AppColors.priorityHighBg;
      case Priority.medium:
        return AppColors.priorityMedBg;
      case Priority.low:
        return AppColors.priorityLowBg;
    }
  }

  String get _priorityLabel {
    switch (widget.task.priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Med';
      case Priority.low:
        return 'Low';
    }
  }

  Color get _categoryColor {
    switch (widget.task.category) {
      case TaskCategory.work:
        return AppColors.catWork;
      case TaskCategory.personal:
        return AppColors.catPersonal;
      case TaskCategory.shopping:
        return AppColors.catShopping;
      case TaskCategory.health:
        return AppColors.catHealth;
      case TaskCategory.study:
        return AppColors.catStudy;
      case TaskCategory.other:
        return AppColors.catOther;
    }
  }

  bool get _isOverdue {
    if (widget.task.dueDate == null || widget.task.isCompleted) return false;
    return widget.task.dueDate!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final canMoveUp = widget.isDragEnabled && widget.index > 0;
    final canMoveDown =
        widget.isDragEnabled && widget.index < widget.totalCount - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onHorizontalDragUpdate: (d) {
          setState(() => _dragOffset += d.delta.dx);
          if (_dragOffset < -50) {
            _slideController.forward();
          } else if (_dragOffset > 0) {
            _slideController.reverse();
            setState(() => _dragOffset = 0);
          }
        },
        onHorizontalDragEnd: (_) => setState(() => _dragOffset = 0),
        child: Stack(
          children: [
            // Delete background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.2),
                  ),
                ),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: Container(
                    width: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            // Card
            SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.task.isCompleted
                        ? AppColors.surfaceElevated
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Priority stripe
                        Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: widget.task.isCompleted
                                ? AppColors.border
                                : _priorityColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12, 12, 10, 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Complete checkbox
                                GestureDetector(
                                  onTap: widget.onComplete,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(
                                      top: 1,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.task.isCompleted
                                          ? AppColors.success
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: widget.task.isCompleted
                                            ? AppColors.success
                                            : AppColors.borderStrong,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: widget.task.isCompleted
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 13,
                                          )
                                        : null,
                                  ),
                                ),
                                // Title + tags
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.task.title,
                                        style: TextStyle(
                                          color: widget.task.isCompleted
                                              ? AppColors.textTertiary
                                              : AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          decoration: widget.task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              AppColors.textTertiary,
                                          height: 1.35,
                                        ),
                                      ),
                                      if (widget.task.description != null &&
                                          widget.task.description!
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 3),
                                        Text(
                                          widget.task.description!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textTertiary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          _buildTag(
                                            _priorityLabel,
                                            _priorityColor,
                                            _priorityBg,
                                          ),
                                          const SizedBox(width: 5),
                                          _buildCategoryTag(),
                                          if (widget.task.dueDate !=
                                              null) ...[
                                            const SizedBox(width: 5),
                                            _buildDueTag(),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Right actions
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: widget.onStar,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Icon(
                                          widget.task.isStarred
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          color: widget.task.isStarred
                                              ? AppColors.warn
                                              : AppColors.textTertiary,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    if (widget.isDragEnabled) ...[
                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap:
                                            canMoveUp ? widget.onMoveUp : null,
                                        child: Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          color: canMoveUp
                                              ? AppColors.textTertiary
                                              : AppColors.border,
                                          size: 18,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: canMoveDown
                                            ? widget.onMoveDown
                                            : null,
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: canMoveDown
                                              ? AppColors.textTertiary
                                              : AppColors.border,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryTag() {
    final color = _categoryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        widget.task.category.name[0].toUpperCase() +
            widget.task.category.name.substring(1),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDueTag() {
    final due = widget.task.dueDate!;
    final now = DateTime.now();
    final isToday =
        due.year == now.year && due.month == now.month && due.day == now.day;
    final color = _isOverdue
        ? AppColors.danger
        : isToday
            ? AppColors.warn
            : AppColors.textTertiary;
    final label = _isOverdue
        ? 'Overdue'
        : isToday
            ? 'Today'
            : DateFormat('MMM d').format(due);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, color: color, size: 12),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
