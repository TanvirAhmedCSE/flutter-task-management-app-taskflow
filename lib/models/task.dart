import 'package:hive_flutter/hive_flutter.dart';
import 'enums.dart';

// typeId: 2
@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  bool isCompleted;
  @HiveField(4)
  Priority priority;
  @HiveField(5)
  TaskCategory category;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  DateTime? dueDate;
  @HiveField(8)
  bool isStarred;
  @HiveField(9)
  int sortOrder;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = Priority.medium,
    this.category = TaskCategory.personal,
    required this.createdAt,
    this.dueDate,
    this.isStarred = false,
    this.sortOrder = 0,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
    TaskCategory? category,
    DateTime? dueDate,
    bool? isStarred,
    int? sortOrder,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      isStarred: isStarred ?? this.isStarred,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
