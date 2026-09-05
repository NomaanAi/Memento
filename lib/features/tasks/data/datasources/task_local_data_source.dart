import 'package:memento/core/database/database_helper.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';

abstract class TaskLocalDataSource {
  Future<List<AppTask>> getTasks(String userId);
  Future<List<AppTask>> getTasksByProject(String projectId);
  Future<AppTask?> getTaskById(String id);
  Future<void> createTask(AppTask task);
  Future<void> updateTask(AppTask task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _dbHelper;

  TaskLocalDataSourceImpl(this._dbHelper);

  @override
  Future<List<AppTask>> getTasks(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dueDate ASC',
    );

    return List.generate(maps.length, (i) {
      return AppTask(
        id: maps[i]['id'] as String,
        projectId: maps[i]['projectId'] as String?,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String?,
        priority: maps[i]['priority'] as String?,
        status: maps[i]['status'] as String?,
        dueDate: maps[i]['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(maps[i]['dueDate'] as int) : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updatedAt'] as int),
        userId: maps[i]['userId'] as String,
      );
    });
  }

  @override
  Future<List<AppTask>> getTasksByProject(String projectId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'projectId = ?',
      whereArgs: [projectId],
      orderBy: 'dueDate ASC',
    );

    return List.generate(maps.length, (i) {
      return AppTask(
        id: maps[i]['id'] as String,
        projectId: maps[i]['projectId'] as String?,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String?,
        priority: maps[i]['priority'] as String?,
        status: maps[i]['status'] as String?,
        dueDate: maps[i]['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(maps[i]['dueDate'] as int) : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updatedAt'] as int),
        userId: maps[i]['userId'] as String,
      );
    });
  }

  @override
  Future<AppTask?> getTaskById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return AppTask(
      id: map['id'] as String,
      projectId: map['projectId'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      priority: map['priority'] as String?,
      status: map['status'] as String?,
      dueDate: map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      userId: map['userId'] as String,
    );
  }

  @override
  Future<void> createTask(AppTask task) async {
    final db = await _dbHelper.database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'projectId': task.projectId,
        'title': task.title,
        'description': task.description,
        'priority': task.priority,
        'status': task.status,
        'dueDate': task.dueDate?.millisecondsSinceEpoch,
        'createdAt': task.createdAt.millisecondsSinceEpoch,
        'updatedAt': task.updatedAt.millisecondsSinceEpoch,
        'userId': task.userId,
      },
    );
  }

  @override
  Future<void> updateTask(AppTask task) async {
    final db = await _dbHelper.database;
    await db.update(
      'tasks',
      {
        'projectId': task.projectId,
        'title': task.title,
        'description': task.description,
        'priority': task.priority,
        'status': task.status,
        'dueDate': task.dueDate?.millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
