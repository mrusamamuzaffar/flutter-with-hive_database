import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime inputDate;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? completedDate; 

  Task({
    required this.title,
    required this.description,
    required this.inputDate,
    this.isCompleted = false,
  });
}