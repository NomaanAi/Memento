import 'package:memento/features/auth/domain/entities/auth_user.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  Future<UserProfile?> getUserProfile(String uid);
}
