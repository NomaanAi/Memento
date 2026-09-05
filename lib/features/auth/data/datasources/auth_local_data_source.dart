import 'package:memento/core/database/database_helper.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserProfile(UserProfile profile);
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> clearUserProfile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper _dbHelper;

  AuthLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await _dbHelper.database;
    await db.insert(
      'local_users',
      {
        'uid': profile.uid,
        'displayName': profile.displayName,
        'email': profile.email,
        'photoUrl': profile.photoUrl,
        'createdAt': profile.createdAt.millisecondsSinceEpoch,
        'updatedAt': profile.updatedAt.millisecondsSinceEpoch,
        'lastSyncedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'local_users',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isEmpty) return null;

    final result = maps.first;
    
    return UserProfile(
      uid: result['uid'] as String,
      displayName: result['displayName'] as String?,
      email: result['email'] as String?,
      photoUrl: result['photoUrl'] as String?,
      authProvider: 'unknown', // Not stored locally
      createdAt: result['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(result['createdAt'] as int) : DateTime.now(),
      updatedAt: result['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(result['updatedAt'] as int) : DateTime.now(),
    );
  }

  @override
  Future<void> clearUserProfile() async {
    final db = await _dbHelper.database;
    await db.delete('local_users');
  }
}
