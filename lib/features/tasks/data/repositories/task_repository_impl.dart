import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/tasks/domain/repositories/task_repository.dart';
import 'package:memento/features/tasks/data/datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<List<AppTask>> getTasks(String userId) async {
    return _localDataSource.getTasks(userId);
  }

  @override
  Future<List<AppTask>> getTasksByProject(String projectId) async {
    return _localDataSource.getTasksByProject(projectId);
  }

  @override
  Future<AppTask?> getTaskById(String id) async {
    return _localDataSource.getTaskById(id);
  }

  @override
  Future<void> createTask(AppTask task) async {
    return _localDataSource.createTask(task);
  }

  @override
  Future<void> updateTask(AppTask task) async {
    return _localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    return _localDataSource.deleteTask(id);
  }
}
