import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../models/enums.dart';
import '../theme/app_colors.dart';

class TaskFormSheet extends StatefulWidget {
  final Task? task;

  const TaskFormSheet({super.key, this.task});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  // Controller is fetched from GetX dependency injection
  final TaskController _controller = Get.find<TaskController>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late Priority _priority;
  late TaskCategory _category;
  DateTime? _dueDate;
  late bool _isStarred;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _descCtrl = TextEditingController(text: t?.description ?? '');
    _priority = t?.priority ?? Priority.medium;
    _category = t?.category ?? TaskCategory.personal;
    _dueDate = t?.dueDate;
    _isStarred = t?.isStarred ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description:
          _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      priority: _priority,
      category: _category,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      dueDate: _dueDate,
      isStarred: _isStarred,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    if (widget.task != null) {
      _controller.updateTask(task);
    } else {
      _controller.addTask(task);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit task' : 'New task',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isStarred = !_isStarred),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isStarred
                          ? AppColors.warnLight
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isStarred
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color:
                          _isStarred ? AppColors.warn : AppColors.textTertiary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildInput(
              controller: _titleCtrl,
              hint: 'What needs to be done?',
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            _buildInput(
              controller: _descCtrl,
              hint: 'Add a note (optional)',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _sectionLabel('Priority'),
            const SizedBox(height: 8),
            Row(
              children: Priority.values.map((p) {
                final isSelected = _priority == p;
                final data = {
                  Priority.low: (
                    'Low',
                    AppColors.priorityLow,
                    AppColors.priorityLowBg,
                  ),
                  Priority.medium: (
                    'Med',
                    AppColors.priorityMed,
                    AppColors.priorityMedBg,
                  ),
                  Priority.high: (
                    'High',
                    AppColors.priorityHigh,
                    AppColors.priorityHighBg,
                  ),
                };
                final (label, color, bg) = data[p]!;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: EdgeInsets.only(
                        right: p != Priority.high ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: isSelected ? bg : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? color.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color:
                                isSelected ? color : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _sectionLabel('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: TaskCategory.values.map((c) {
                final isSelected = _category == c;
                const icons = {
                  TaskCategory.personal: Icons.person_outline_rounded,
                  TaskCategory.work: Icons.work_outline_rounded,
                  TaskCategory.shopping: Icons.shopping_cart_outlined,
                  TaskCategory.health: Icons.fitness_center_rounded,
                  TaskCategory.study: Icons.menu_book_rounded,
                  TaskCategory.other: Icons.push_pin_outlined,
                };
                return GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentLight
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentMid
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[c],
                          size: 14,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${c.name[0].toUpperCase()}${c.name.substring(1)}',
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _sectionLabel('Due date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365)),
                  lastDate:
                      DateTime.now().add(const Duration(days: 365 * 2)),
                  builder: (ctx, child) => Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.accent,
                        surface: AppColors.surface,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (date != null) setState(() => _dueDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _dueDate != null
                        ? AppColors.accentMid
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: _dueDate != null
                          ? AppColors.accent
                          : AppColors.textTertiary,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _dueDate != null
                            ? DateFormat('EEEE, MMM d yyyy').format(_dueDate!)
                            : 'Set a due date',
                        style: TextStyle(
                          color: _dueDate != null
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textTertiary,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    isEdit ? 'Save changes' : 'Add task',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      );

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 14,
          ),
        ),
      ),
    );
  }
}
