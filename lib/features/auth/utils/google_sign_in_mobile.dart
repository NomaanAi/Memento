import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogleMobile(FirebaseAuth auth) async {
  final googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) return null; // User canceled the sign-in

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await auth.signInWithCredential(credential);
}

Future<void> signOutGoogleMobile() async {
  await GoogleSignIn().signOut();
}
