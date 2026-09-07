import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/projects/data/datasources/project_local_data_source.dart';
import 'package:memento/features/projects/data/repositories/project_repository_impl.dart';
import 'package:memento/features/projects/domain/entities/project.dart';
import 'package:memento/features/projects/domain/repositories/project_repository.dart';
import 'package:memento/core/database/database_helper.dart';

final projectLocalDataSourceProvider = Provider<ProjectLocalDataSource>((ref) {
  return ProjectLocalDataSourceImpl(DatabaseHelper.instance);
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final localDataSource = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(localDataSource);
});

final projectsProvider = AsyncNotifierProvider<ProjectsNotifier, List<Project>>(ProjectsNotifier.new);

class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  ProjectRepository get _repository => ref.read(projectRepositoryProvider);
  String get _userId => ref.read(authStateProvider.notifier).currentUser?.uid ?? '';

  @override
  FutureOr<List<Project>> build() async {
    if (_userId.isEmpty) return [];
    return _repository.getProjects(_userId);
  }

  Future<void> loadProjects() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getProjects(_userId));
  }

  Future<void> addProject(Project project) async {
    await _repository.createProject(project);
    await loadProjects();
  }

  Future<void> updateProject(Project project) async {
    await _repository.updateProject(project);
    await loadProjects();
  }

  Future<void> deleteProject(String id) async {
    await _repository.deleteProject(id);
    await loadProjects();
  }
}

