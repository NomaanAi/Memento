import 'package:memento/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<AppTask>> getTasks(String userId);
  Future<List<AppTask>> getTasksByProject(String projectId);
  Future<AppTask?> getTaskById(String id);
  Future<void> createTask(AppTask task);
  Future<void> updateTask(AppTask task);
  Future<void> deleteTask(String id);
}
