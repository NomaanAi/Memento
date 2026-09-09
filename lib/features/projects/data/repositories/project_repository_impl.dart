import 'package:memento/features/projects/domain/entities/project.dart';
import 'package:memento/features/projects/domain/repositories/project_repository.dart';
import 'package:memento/features/projects/data/datasources/project_local_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource _localDataSource;

  ProjectRepositoryImpl(this._localDataSource);

  @override
  Future<List<Project>> getProjects(String userId) async {
    return _localDataSource.getProjects(userId);
  }

  @override
  Future<Project?> getProjectById(String id) async {
    return _localDataSource.getProjectById(id);
  }

  @override
  Future<void> createProject(Project project) async {
    return _localDataSource.createProject(project);
  }

  @override
  Future<void> updateProject(Project project) async {
    return _localDataSource.updateProject(project);
  }

  @override
  Future<void> deleteProject(String id) async {
    return _localDataSource.deleteProject(id);
  }
}
