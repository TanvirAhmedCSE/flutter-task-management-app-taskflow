import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/enums.dart';

class TaskController extends GetxController {
  late Box<Task> _taskBox;

  //  Observable state
  final RxInt selectedFilter = 0.obs;
  final Rxn<TaskCategory> selectedCategory = Rxn<TaskCategory>();
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  // 0=All, 1=Active, 2=Done, 3=Starred, 4=Higher Priority, 5=Closer Due Date
  final List<String> filters = const [
    'All',
    'Active',
    'Done',
    'Starred',
    'Higher Priority',
    'Closer Due Date',
  ];

  //  Lifecycle
  @override
  void onInit() {
    super.onInit();
    _taskBox = Hive.box<Task>('tasks');
  }

  //  Derived getters
  bool get isDragEnabled =>
      selectedFilter.value == 0 && selectedCategory.value == null;

  List<Task> get allTasks {
    final list = _taskBox.values.toList();
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  List<Task> get filteredTasks {
    List<Task> result = allTasks;

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                (t.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }

    // Category filter
    if (selectedCategory.value != null) {
      result = result
          .where((t) => t.category == selectedCategory.value)
          .toList();
    }

    // Tab filter
    switch (selectedFilter.value) {
      case 1:
        result = result.where((t) => !t.isCompleted).toList();
        break;
      case 2:
        result = result.where((t) => t.isCompleted).toList();
        break;
      case 3:
        result = result.where((t) => t.isStarred).toList();
        break;
      case 4:
        result = _sortByPriority(result);
        break;
      case 5:
        result = _sortByDueDate(result);
        break;
    }

    return result;
  }

  int get completedCount => allTasks.where((t) => t.isCompleted).length;
  int get totalCount => allTasks.length;

  double get progress => totalCount == 0 ? 0.0 : completedCount / totalCount;

  //  Sorting helpers

  /// Higher Priority sort: High -> Med -> Low, starred first, then closer due
  /// date, then title A -> Z.
  List<Task> _sortByPriority(List<Task> tasks) {
    final list = List<Task>.from(tasks);
    list.sort((a, b) {
      final pCmp = b.priority.index.compareTo(a.priority.index);
      if (pCmp != 0) return pCmp;
      if (a.isStarred != b.isStarred) return a.isStarred ? -1 : 1;
      final dueCmp = _compareDueDate(a.dueDate, b.dueDate);
      if (dueCmp != 0) return dueCmp;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return list;
  }

  /// Closer Due Date sort: null dates go last, then starred first, title A -> Z.
  List<Task> _sortByDueDate(List<Task> tasks) {
    final list = List<Task>.from(tasks);
    list.sort((a, b) {
      final dueCmp = _compareDueDate(a.dueDate, b.dueDate);
      if (dueCmp != 0) return dueCmp;
      if (a.isStarred != b.isStarred) return a.isStarred ? -1 : 1;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return list;
  }

  int _compareDueDate(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  //  CRUD operations

  Future<void> addTask(Task task) async {
    final newTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      category: task.category,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      isStarred: task.isStarred,
      isCompleted: task.isCompleted,
      sortOrder: _taskBox.length,
    );
    await _taskBox.put(newTask.id, newTask);
    update();
    HapticFeedback.mediumImpact();
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
    update();
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    update();
    HapticFeedback.heavyImpact();
  }

  Future<void> toggleComplete(String id) async {
    final task = _taskBox.get(id);
    if (task == null) return;
    await _taskBox.put(id, task.copyWith(isCompleted: !task.isCompleted));
    update();
    HapticFeedback.selectionClick();
  }

  Future<void> toggleStar(String id) async {
    final task = _taskBox.get(id);
    if (task == null) return;
    await _taskBox.put(id, task.copyWith(isStarred: !task.isStarred));
    update();
  }

  //  Reorder / move

  void moveTask(int oldIndex, int newIndex, List<Task> filtered) {
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex >= filtered.length || newIndex >= filtered.length) return;

    final all = allTasks;
    final moved = filtered[oldIndex];
    final target = filtered[newIndex];

    final allOldIndex = all.indexWhere((t) => t.id == moved.id);
    final allNewIndex = all.indexWhere((t) => t.id == target.id);
    if (allOldIndex == -1 || allNewIndex == -1) return;

    all.removeAt(allOldIndex);
    all.insert(allNewIndex, moved);

    for (int i = 0; i < all.length; i++) {
      all[i].sortOrder = i;
      _taskBox.put(all[i].id, all[i]);
    }

    update();
    HapticFeedback.selectionClick();
  }

  void moveTaskUp(String id) {
    if (!isDragEnabled) return;
    final f = filteredTasks;
    final idx = f.indexWhere((t) => t.id == id);
    if (idx > 0) moveTask(idx, idx - 1, f);
  }

  void moveTaskDown(String id) {
    if (!isDragEnabled) return;
    final f = filteredTasks;
    final idx = f.indexWhere((t) => t.id == id);
    if (idx < f.length - 1) moveTask(idx, idx + 2, f);
  }

  //  UI state helpers

  void setFilter(int index) {
    selectedFilter.value = index;
    update();
  }

  void setCategory(TaskCategory? cat) {
    selectedCategory.value = cat;
    update();
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
    update();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
    update();
  }

  //  Greeting
  String get greeting {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Good morning';
    if (h >= 12 && h < 14) return 'Good noon';
    if (h >= 14 && h < 18) return 'Good afternoon';
    if (h >= 18 && h < 21) return 'Good evening';
    return 'Good night';
  }
}
