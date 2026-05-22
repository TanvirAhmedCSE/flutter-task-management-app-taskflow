import 'package:hive_flutter/hive_flutter.dart';
import '../models/enums.dart';

class TaskCategoryAdapter extends TypeAdapter<TaskCategory> {
  @override
  final int typeId = 1;

  @override
  TaskCategory read(BinaryReader reader) {
    return TaskCategory.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, TaskCategory obj) {
    writer.writeByte(obj.index);
  }
}
