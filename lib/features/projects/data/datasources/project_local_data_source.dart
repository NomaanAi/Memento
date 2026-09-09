import 'package:memento/core/database/database_helper.dart';
import 'package:memento/features/projects/domain/entities/project.dart';

abstract class ProjectLocalDataSource {
  Future<List<Project>> getProjects(String userId);
  Future<Project?> getProjectById(String id);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProjectLocalDataSourceImpl(this._dbHelper);

  @override
  Future<List<Project>> getProjects(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'projects',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Project(
        id: maps[i]['id'] as String,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String?,
        category: maps[i]['category'] as String?,
        priority: maps[i]['priority'] as String?,
        startDate: maps[i]['startDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['startDate'] as int)
            : null,
        deadline: maps[i]['deadline'] != null
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['deadline'] as int)
            : null,
        progress: (maps[i]['progress'] as num?)?.toDouble() ?? 0.0,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          maps[i]['createdAt'] as int,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          maps[i]['updatedAt'] as int,
        ),
        userId: maps[i]['userId'] as String,
      );
    });
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      category: map['category'] as String?,
      priority: map['priority'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int)
          : null,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      userId: map['userId'] as String,
    );
  }

  @override
  Future<void> createProject(Project project) async {
    final db = await _dbHelper.database;
    await db.insert('projects', {
      'id': project.id,
      'name': project.name,
      'description': project.description,
      'category': project.category,
      'priority': project.priority,
      'startDate': project.startDate?.millisecondsSinceEpoch,
      'deadline': project.deadline?.millisecondsSinceEpoch,
      'progress': project.progress,
      'createdAt': project.createdAt.millisecondsSinceEpoch,
      'updatedAt': project.updatedAt.millisecondsSinceEpoch,
      'userId': project.userId,
    });
  }

  @override
  Future<void> updateProject(Project project) async {
    final db = await _dbHelper.database;
    await db.update(
      'projects',
      {
        'name': project.name,
        'description': project.description,
        'category': project.category,
        'priority': project.priority,
        'startDate': project.startDate?.millisecondsSinceEpoch,
        'deadline': project.deadline?.millisecondsSinceEpoch,
        'progress': project.progress,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  @override
  Future<void> deleteProject(String id) async {
    final db = await _dbHelper.database;
    await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }
}
