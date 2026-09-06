import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class AppTask with _$AppTask {
  const factory AppTask({
    required String id,
    String? projectId,
    required String title,
    String? description,
    String? priority,
    String? status,
    DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) = _AppTask;

  factory AppTask.fromJson(Map<String, dynamic> json) => _$AppTaskFromJson(json);
}
