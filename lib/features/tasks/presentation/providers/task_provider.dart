import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:memento/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/tasks/domain/repositories/task_repository.dart';
import 'package:memento/core/database/database_helper.dart';

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSourceImpl(DatabaseHelper.instance);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource);
});

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<AppTask>>(
  TasksNotifier.new,
);

class TasksNotifier extends AsyncNotifier<List<AppTask>> {
  TaskRepository get _repository => ref.read(taskRepositoryProvider);
  String get _userId =>
      ref.read(authStateProvider.notifier).currentUser?.uid ?? '';

  @override
  FutureOr<List<AppTask>> build() async {
    if (_userId.isEmpty) return [];
    return _repository.getTasks(_userId);
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTasks(_userId));
  }

  Future<void> addTask(AppTask task) async {
    await _repository.createTask(task);
    await loadTasks();
  }

  Future<void> updateTask(AppTask task) async {
    await _repository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }
}
