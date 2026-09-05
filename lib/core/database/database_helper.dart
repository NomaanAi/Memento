import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static const _databaseName = 'memento.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('Sqflite is not supported on Web. Use in-memory or alternative storage.');
    }
    
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE local_users (
        uid TEXT PRIMARY KEY,
        displayName TEXT,
        email TEXT,
        photoUrl TEXT,
        createdAt INTEGER,
        updatedAt INTEGER,
        lastSyncedAt INTEGER
      )
    ''');

    // Projects Table
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

    // Tasks Table
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

    // Notes Table
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

    // Goals Table
    await db.execute('''
      CREATE TABLE goals (
        id TEXT PRIMARY KEY,
        projectId TEXT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT,
        targetDate INTEGER,
        progress REAL DEFAULT 0.0,
        status TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE SET NULL
      )
    ''');
    
    // Documents Metadata Table
    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        projectId TEXT,
        filename TEXT NOT NULL,
        fileType TEXT,
        size INTEGER,
        storageUrl TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE SET NULL
      )
    ''');
  }
}
