import 'package:memento/features/auth/domain/entities/auth_user.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';
import 'package:memento/features/auth/domain/repositories/auth_repository.dart';
import 'package:memento/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:memento/features/auth/data/datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Stream<AuthUser?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  AuthUser? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    await _remoteDataSource.signInWithEmail(email: email, password: password);
    final user = _remoteDataSource.currentUser;
    if (user != null) {
      await _syncProfile(user.uid);
    }
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password, required String displayName}) async {
    await _remoteDataSource.signUpWithEmail(email: email, password: password, displayName: displayName);
    final user = _remoteDataSource.currentUser;
    if (user != null) {
      await _syncProfile(user.uid);
      await sendEmailVerification();
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await _remoteDataSource.signInWithGoogle();
    final user = _remoteDataSource.currentUser;
    if (user != null) {
      await _syncProfile(user.uid);
    }
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
    await _localDataSource.clearUserProfile();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() async {
    await _remoteDataSource.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() async {
    await _remoteDataSource.reloadUser();
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final remoteProfile = await _remoteDataSource.getUserProfile(uid);
      if (remoteProfile != null) {
        await _localDataSource.saveUserProfile(remoteProfile);
        return remoteProfile;
      }
    } catch (_) {
      // If network fails, try local
    }
    return _localDataSource.getUserProfile(uid);
  }

  Future<void> _syncProfile(String uid) async {
    final profile = await _remoteDataSource.getUserProfile(uid);
    if (profile != null) {
      await _localDataSource.saveUserProfile(profile);
    }
  }
}
