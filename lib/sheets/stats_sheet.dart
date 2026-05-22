import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/enums.dart';
import '../theme/app_colors.dart';

class StatsSheet extends StatelessWidget {
  final List<Task> tasks;
  const StatsSheet({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final active = total - completed;
    final starred = tasks.where((t) => t.isStarred).length;
    final overdue = tasks
        .where(
          (t) =>
              t.dueDate != null &&
              !t.isCompleted &&
              t.dueDate!.isBefore(DateTime.now()),
        )
        .length;
    final catCounts = {
      for (final c in TaskCategory.values)
        c: tasks.where((t) => t.category == c).length,
    };

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          const Text(
            'Stats',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard(
                'Total',
                total.toString(),
                Icons.list_rounded,
                AppColors.accent,
              ),
              const SizedBox(width: 10),
              _statCard(
                'Done',
                completed.toString(),
                Icons.check_circle_outline_rounded,
                AppColors.success,
              ),
              const SizedBox(width: 10),
              _statCard(
                'Active',
                active.toString(),
                Icons.radio_button_unchecked_rounded,
                AppColors.warn,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statCard(
                'Starred',
                starred.toString(),
                Icons.star_rounded,
                AppColors.warn,
              ),
              const SizedBox(width: 10),
              _statCard(
                'Overdue',
                overdue.toString(),
                Icons.warning_amber_rounded,
                AppColors.danger,
              ),
              const SizedBox(width: 10),
              _statCard(
                'Rate',
                total > 0 ? '${((completed / total) * 100).toInt()}%' : '0%',
                Icons.trending_up_rounded,
                AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'By category',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...TaskCategory.values.map((cat) {
            final count = catCounts[cat] ?? 0;
            if (count == 0) return const SizedBox.shrink();
            final pct = total > 0 ? count / total : 0.0;
            final completedInCat =
                tasks.where((t) => t.category == cat && t.isCompleted).length;
            final activeInCat = count - completedInCat;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(_catIcon(cat), size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat.name[0].toUpperCase() + cat.name.substring(1),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$count',
                              style: const TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 4,
                            backgroundColor: AppColors.surfaceDim,
                            valueColor: AlwaysStoppedAnimation(
                              activeInCat > 0
                                  ? AppColors.danger
                                  : AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: catCounts.values.any((c) => c > 0) ? 15 : 0),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _catIcon(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.personal:
        return Icons.person_outline_rounded;
      case TaskCategory.work:
        return Icons.work_outline_rounded;
      case TaskCategory.shopping:
        return Icons.shopping_cart_outlined;
      case TaskCategory.health:
        return Icons.fitness_center_rounded;
      case TaskCategory.study:
        return Icons.menu_book_rounded;
      case TaskCategory.other:
        return Icons.push_pin_outlined;
    }
  }
}
