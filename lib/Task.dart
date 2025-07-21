import 'package:hive/hive.dart';

part 'Task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String date;

  @HiveField(2)
  int priority;

  @HiveField(3)
  bool isDone;

  Task({
    required this.title,
    required this.date,
    required this.priority,
    this.isDone = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      date: map['date'],
      priority: map['priority'],
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'priority': priority,
      'isDone': isDone,
    };
  }
}
