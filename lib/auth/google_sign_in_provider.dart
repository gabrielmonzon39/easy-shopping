import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  static GoogleSignInProvider? provider;
  static FirebaseApp? firebaseApp;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUSer = await googleSignIn.signIn();
    if (googleUSer == null) return;
    _user = googleUSer;

    final googleAuth = await googleUSer.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future googleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {}
  }
}
