import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:memento/features/auth/domain/entities/auth_user.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';
import 'package:memento/features/auth/data/models/user_profile_model.dart';
import 'package:memento/features/auth/utils/google_sign_in_helper.dart';
import 'package:memento/core/errors/app_exceptions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  String _mapFirebaseError(String code, String? defaultMessage) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'user-disabled':
        return 'No account was found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Your password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return defaultMessage ?? 'Authentication failed. Please try again.';
    }
  }

  AuthUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      authProvider: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'firebase',
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('AUTH: Login started');
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('AUTH: Login successful');
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException(
        'An unexpected error occurred during sign in.',
      );
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      debugPrint('AUTH: Registration started');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        debugPrint('AUTH: Registration successful');
        await user.updateDisplayName(displayName);

        final currentUser = _firebaseAuth.currentUser;
        if (currentUser == null) {
          debugPrint('AUTH: Verification email failed: no current user');
        } else {
          debugPrint('AUTH: Verification email send started');
          debugPrint('AUTH: Verification email target = ${currentUser.email}');
          try {
            await currentUser.sendEmailVerification();
            debugPrint('AUTH: Verification email send succeeded');
          } on FirebaseAuthException catch (e) {
            debugPrint('AUTH: Verification email send failed');
            debugPrint('AUTH: Firebase error code = ${e.code}');
            debugPrint('AUTH: Firebase error message = ${e.message}');
            rethrow;
          } catch (e) {
            debugPrint('AUTH: Verification email send failed');
            debugPrint('AUTH: Error = $e');
            rethrow;
          }
        }

        try {
          final profile = UserProfile(
            uid: user.uid,
            displayName: displayName,
            email: email,
            photoUrl: null,
            authProvider: 'password',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(UserProfileModel.toJson(profile));
        } catch (dbError) {
          debugPrint('Failed to save user profile to Firestore: $dbError');
          // We don't fail the authentication flow if the profile save fails,
          // as the user is already created in Firebase Auth and verification email is sent.
        }
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException(
        'An unexpected error occurred during sign up.',
      );
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      debugPrint('AUTH: Google sign-in started');
      UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await _firebaseAuth.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final credential = await signInWithGoogleMobile(_firebaseAuth);
        if (credential == null) return;
        userCredential = credential;
      }

      final user = userCredential.user;

      if (user != null) {
        debugPrint('AUTH: Google sign-in successful');
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          final profile = UserProfile(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoUrl: user.photoURL,
            authProvider: 'google.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(UserProfileModel.toJson(profile));
        }
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException(
        'An unexpected error occurred during Google Sign-In.',
      );
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          final displayName =
              appleCredential.givenName != null ||
                  appleCredential.familyName != null
              ? '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                    .trim()
              : user.displayName;

          final profile = UserProfile(
            uid: user.uid,
            displayName: displayName,
            email: user.email ?? appleCredential.email,
            photoUrl: user.photoURL,
            authProvider: 'apple.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(UserProfileModel.toJson(profile));
        }
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException(
        'An unexpected error occurred during Apple Sign-In.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      if (!kIsWeb) {
        await signOutGoogleMobile();
      }
    } catch (_) {
      // Ignore errors
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      debugPrint('AUTH: Verification email failed: no current user');
      return;
    }

    debugPrint('AUTH: Verification email send started');
    debugPrint('AUTH: Verification email target = ${user.email}');

    try {
      await user.sendEmailVerification();
      debugPrint('AUTH: Verification email send succeeded');
    } on FirebaseAuthException catch (e) {
      debugPrint('AUTH: Verification email send failed');
      debugPrint('AUTH: Firebase error code = ${e.code}');
      debugPrint('AUTH: Firebase error message = ${e.message}');
      throw AuthenticationException(
        _mapFirebaseError(e.code, e.message),
        code: e.code,
      );
    } catch (e) {
      debugPrint('AUTH: Verification email send failed');
      debugPrint('AUTH: Error = $e');
      throw AuthenticationException(
        'An unexpected error occurred during email verification.',
      );
    }
  }

  @override
  Future<void> reloadUser() async {
    debugPrint('AUTH: User reload started');
    await _firebaseAuth.currentUser?.reload();
    debugPrint(
      'AUTH: Email verified = ${_firebaseAuth.currentUser?.emailVerified}',
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get user profile', details: e);
    }
  }
}
