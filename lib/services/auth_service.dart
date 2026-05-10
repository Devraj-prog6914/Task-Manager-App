import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This MUST be your "Web Client ID" from Firebase Console -> Auth -> Google -> Web SDK Config
  static const String _webClientId =
      '448857182774-5aurnptbf5ivetndse1po5oms5v7s9bi.apps.googleusercontent.com';

  User? get user => _auth.currentUser;
  Stream<User?> get authState => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // FIX: Use 'serverClientId' for Android. This is the fix for Error 10.
        final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: _webClientId,
        );

        // Clear previous session to force account picker
        await googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          debugPrint("Sign-in canceled by user.");
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint("CRITICAL AUTH ERROR: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (!kIsWeb) {
        // Use default constructor for sign out
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      debugPrint("Sign out error: $e");
    }
  }
}
