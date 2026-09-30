import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/domain/repositories/auth_repository.dart';
import 'package:memento/features/auth/presentation/providers/auth_provider.dart';
import 'package:memento/features/auth/domain/entities/auth_user.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailVerificationRequired,
  error,
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  AuthUser? get currentUser => _repository.currentUser;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _init();
    return AuthState.initial;
  }

  void _init() {
    _repository.authStateChanges.listen(
      (user) {
        if (user == null) {
          state = AuthState.unauthenticated;
        } else if (!user.emailVerified && user.authProvider == 'password') {
          state = AuthState.emailVerificationRequired;
        } else {
          state = AuthState.authenticated;
        }
      },
      onError: (error) {
        state = AuthState.error;
      },
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      state = AuthState.loading;
      await _repository.signInWithEmail(email: email, password: password);
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      state = AuthState.loading;
      await _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = AuthState.loading;
      await _repository.signInWithGoogle();
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      state = AuthState.loading;
      await _repository.signOut();
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> updateProfile(String displayName) async {
    try {
      state = AuthState.loading;
      await _repository.updateProfile(displayName);
      await reloadUser();
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    try {
      state = AuthState.loading;
      await _repository.reloadUser();
      final user = _repository.currentUser;
      if (user != null) {
        if (!user.emailVerified && user.authProvider == 'password') {
          state = AuthState.emailVerificationRequired;
        } else {
          state = AuthState.authenticated;
        }
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
