import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';
import '../../models/enums.dart';
import '../../theme/app_colors.dart';
import 'widgets/task_card.dart';
import '../../sheets/task_form_sheet.dart';
import '../../sheets/stats_sheet.dart';
import '../../models/task.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  //  Sheet helpers
  void _showTaskFormSheet([Task? editTask]) {
    Get.bottomSheet(
      TaskFormSheet(task: editTask),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showStatsSheet(TaskController c) {
    Get.bottomSheet(
      StatsSheet(tasks: c.allTasks),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  //  Build
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (c) => Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(c),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: c.isSearching.value
                    ? _buildSearchBar(c)
                    : const SizedBox.shrink(),
              ),
              _buildProgressSection(c),
              _buildCategoryChips(c),
              _buildFilterTabs(c),
              Expanded(child: _buildTaskList(c)),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  //  Header
  Widget _buildHeader(TaskController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.greeting,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${c.totalCount} tasks · ${c.completedCount} done',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _headerButton(
            icon: c.isSearching.value
                ? Icons.close_rounded
                : Icons.search_rounded,
            onTap: c.toggleSearch,
          ),
          const SizedBox(width: 8),
          _headerButton(
            icon: Icons.bar_chart_rounded,
            onTap: () => _showStatsSheet(c),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _headerButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  //  Search bar
  Widget _buildSearchBar(TaskController c) {
    // Use a local controller for the TextField but sync to GetX controller
    final textCtrl = TextEditingController(text: c.searchQuery.value);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: textCtrl,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textTertiary,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13),
          ),
          onChanged: c.setSearchQuery,
        ),
      ),
    );
  }

  //  Progress
  Widget _buildProgressSection(TaskController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                '${(c.progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: c.progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (ctx, val, _) => LinearProgressIndicator(
                value: val,
                minHeight: 5,
                backgroundColor: AppColors.surfaceDim,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Category chips
  Widget _buildCategoryChips(TaskController c) {
    final categories = [null, ...TaskCategory.values];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          final isSelected = c.selectedCategory.value == cat;
          final label = cat == null ? 'All' : _categoryLabel(cat);
          final icon = cat == null ? null : _categoryIcon(cat);
          return GestureDetector(
            onTap: () => c.setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 13,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //  Filter tabs
  Widget _buildFilterTabs(TaskController c) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        scrollDirection: Axis.horizontal,
        itemCount: c.filters.length,
        itemBuilder: (ctx, i) {
          final isSelected = c.selectedFilter.value == i;
          return GestureDetector(
            onTap: () => c.setFilter(i),
            child: AnimatedContainer(
              duration: Duration.zero,
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentLight : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                c.filters[i],
                style: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.textTertiary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //  Task list
  Widget _buildTaskList(TaskController c) {
    final filtered = c.filteredTasks;

    if (filtered.isEmpty) return _buildEmptyState(c);

    if (c.isDragEnabled) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: filtered.length,
        onReorder: (oldIndex, newIndex) =>
            c.moveTask(oldIndex, newIndex, filtered),
        proxyDecorator: (child, index, animation) =>
            Material(color: Colors.transparent, elevation: 0, child: child),
        itemBuilder: (ctx, i) {
          final task = filtered[i];
          return TaskCard(
            key: ValueKey(task.id),
            task: task,
            index: i,
            totalCount: filtered.length,
            isDragEnabled: true,
            onComplete: () => c.toggleComplete(task.id),
            onDelete: () => c.deleteTask(task.id),
            onStar: () => c.toggleStar(task.id),
            onMoveUp: () => c.moveTaskUp(task.id),
            onMoveDown: () => c.moveTaskDown(task.id),
            onTap: () => _showTaskFormSheet(task),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) {
        final task = filtered[i];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          index: i,
          totalCount: filtered.length,
          isDragEnabled: false,
          onComplete: () => c.toggleComplete(task.id),
          onDelete: () => c.deleteTask(task.id),
          onStar: () => c.toggleStar(task.id),
          onMoveUp: () => c.moveTaskUp(task.id),
          onMoveDown: () => c.moveTaskDown(task.id),
          onTap: () => _showTaskFormSheet(task),
        );
      },
    );
  }

  //  Empty state
  Widget _buildEmptyState(TaskController c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 28,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            c.searchQuery.value.isNotEmpty
                ? 'No results found'
                : 'No tasks yet',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            c.searchQuery.value.isNotEmpty
                ? 'Try different keywords'
                : 'Tap + to add your first task',
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //  FAB
  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => _showTaskFormSheet(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }

  //  Label/icon helpers
  String _categoryLabel(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.other:
        return 'Other';
    }
  }

  IconData _categoryIcon(TaskCategory cat) {
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
