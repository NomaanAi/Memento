import 'package:memento/features/projects/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects(String userId);
  Future<Project?> getProjectById(String id);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}
