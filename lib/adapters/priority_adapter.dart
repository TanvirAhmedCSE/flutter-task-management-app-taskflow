import 'package:hive_flutter/hive_flutter.dart';
import '../models/enums.dart';

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 0;

  @override
  Priority read(BinaryReader reader) {
    return Priority.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    writer.writeByte(obj.index);
  }
}
