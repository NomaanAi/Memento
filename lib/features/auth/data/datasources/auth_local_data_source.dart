import 'package:memento/core/database/app_database.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';
import 'package:drift/drift.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserProfile(UserProfile profile);
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> clearUserProfile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase _db;

  AuthLocalDataSourceImpl(this._db);

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.into(_db.localUsers).insertOnConflictUpdate(
      LocalUsersCompanion(
        uid: Value(profile.uid),
        displayName: Value(profile.displayName),
        email: Value(profile.email),
        photoUrl: Value(profile.photoUrl),
        createdAt: Value(profile.createdAt),
        updatedAt: Value(profile.updatedAt),
        lastSyncedAt: Value(DateTime.now()),
      )
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final result = await (_db.select(_db.localUsers)..where((t) => t.uid.equals(uid))).getSingleOrNull();
    if (result == null) return null;
    
    return UserProfile(
      uid: result.uid,
      displayName: result.displayName,
      email: result.email,
      photoUrl: result.photoUrl,
      authProvider: 'unknown', // Not stored locally
      createdAt: result.createdAt ?? DateTime.now(),
      updatedAt: result.updatedAt ?? DateTime.now(),
    );
  }

  @override
  Future<void> clearUserProfile() async {
    await _db.delete(_db.localUsers).go();
  }
}
