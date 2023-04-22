import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime created;

  @HiveField(3)
  bool isComplated;

  Task({
    required this.id,
    required this.name,
    required this.created,
    required this.isComplated,
  });
  factory Task.create({required String name, required DateTime created}) {
    return Task(id: const Uuid().v1(), name: name, created: created, isComplated: false);
  }
}
