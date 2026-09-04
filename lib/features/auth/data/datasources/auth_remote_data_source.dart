import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memento/features/auth/domain/entities/auth_user.dart';
import 'package:memento/features/auth/domain/entities/user_profile.dart';
import 'package:memento/features/auth/data/models/user_profile_model.dart';
import 'package:memento/core/errors/app_exceptions.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;
  Future<void> signInWithEmail({required String email, required String password});
  Future<void> signUpWithEmail({required String email, required String password, required String displayName});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  Future<UserProfile?> getUserProfile(String uid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn, this._firestore);

  AuthUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      authProvider: user.providerData.isNotEmpty ? user.providerData.first.providerId : 'firebase',
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges => _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(e.message ?? 'Authentication failed', code: e.code);
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password, required String displayName}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        final profile = UserProfile(
          uid: user.uid,
          displayName: displayName,
          email: email,
          photoUrl: null,
          authProvider: 'password',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(UserProfileModel.toJson(profile));
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(e.message ?? 'Signup failed', code: e.code);
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
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
            await _firestore.collection('users').doc(user.uid).set(UserProfileModel.toJson(profile));
        }
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(e.message ?? 'Google Sign-In failed', code: e.code);
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(e.message ?? 'Failed to send reset email', code: e.code);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(e.message ?? 'Failed to send verification email', code: e.code);
    }
  }

  @override
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
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
