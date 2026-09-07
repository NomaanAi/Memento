import 'package:memento/core/database/database_helper.dart';
import 'package:memento/features/notes/domain/entities/note.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper;
  NoteRepository(this._dbHelper);

  Future<List<Note>> getNotes(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query('notes', where: 'userId = ?', whereArgs: [userId], orderBy: 'updatedAt DESC');
    return List.generate(maps.length, (i) => Note(
      id: maps[i]['id'] as String,
      projectId: maps[i]['projectId'] as String?,
      title: maps[i]['title'] as String,
      content: maps[i]['content'] as String,
      category: maps[i]['category'] as String?,
      tags: maps[i]['tags'] as String?,
      pinned: (maps[i]['pinned'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updatedAt'] as int),
      userId: maps[i]['userId'] as String,
    ));
  }

  Future<void> createNote(Note note) async {
    final db = await _dbHelper.database;
    await db.insert('notes', {
      'id': note.id,
      'projectId': note.projectId,
      'title': note.title,
      'content': note.content,
      'category': note.category,
      'tags': note.tags,
      'pinned': note.pinned ? 1 : 0,
      'createdAt': note.createdAt.millisecondsSinceEpoch,
      'updatedAt': note.updatedAt.millisecondsSinceEpoch,
      'userId': note.userId,
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await _dbHelper.database;
    await db.update('notes', {
      'title': note.title,
      'content': note.content,
      'pinned': note.pinned ? 1 : 0,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(String id) async {
    final db = await _dbHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
