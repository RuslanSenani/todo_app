import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String name;
  final DateTime created;
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
