// ignore_for_file: use_build_context_synchronously

import 'package:easy_shopping/screens/on_board/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future googleSignOut(BuildContext context) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Onboard()));
      });
      await googleSignIn.signOut();
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Onboard()),
      );
    }
  }
}
