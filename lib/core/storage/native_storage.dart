import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'storage_adapter.dart';

class NativeStorageAdapter implements StorageAdapter {
  Database? _db;
  final int _version = 1;

  @override
  Future<void> initialize() async {
    if (_db != null) return;
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, 'memento.db');

    _db = await openDatabase(
      path,
      version: _version,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Shared table creation logic (could be extracted if needed, but doing it here for simplicity)
    await db.execute('''
      CREATE TABLE projects (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        priority TEXT,
        startDate INTEGER,
        deadline INTEGER,
        progress REAL DEFAULT 0.0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        projectId TEXT,
        title TEXT NOT NULL,
        description TEXT,
        priority TEXT,
        status TEXT,
        dueDate INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        projectId TEXT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        tags TEXT,
        pinned INTEGER DEFAULT 0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE SET NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE local_users (
        uid TEXT PRIMARY KEY,
        displayName TEXT,
        email TEXT,
        photoUrl TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        lastSyncedAt INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    await _db!.execute(sql, arguments);
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    return await _db!.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    return await _db!.insert(table, values);
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _db!.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _db!.delete(table, where: where, whereArgs: whereArgs);
  }
}

StorageAdapter getStorageAdapter() => NativeStorageAdapter();
