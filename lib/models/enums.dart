import 'package:hive_flutter/hive_flutter.dart';

// typeId: 0
@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

// typeId: 1
@HiveType(typeId: 1)
enum TaskCategory {
  @HiveField(0)
  personal,
  @HiveField(1)
  work,
  @HiveField(2)
  shopping,
  @HiveField(3)
  health,
  @HiveField(4)
  study,
  @HiveField(5)
  other,
}
