import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> signInWithGoogleMobile(FirebaseAuth auth) async {
  // Not used on web, web uses signInWithPopup directly in the data source.
  throw UnsupportedError('Use signInWithPopup on web');
}

Future<void> signOutGoogleMobile() async {
  // Do nothing on web for GoogleSignIn
}
