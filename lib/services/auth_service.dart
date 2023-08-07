import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // Starts the interactive sign-in process.
    // null if sign in failed.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // get auth details for request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create credidential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => {log('User: ${value.user!.email.toString()}')})
        .then((value) => {log(FirebaseAuth.instance.currentUser.toString())});
  }

  signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  resetPassword(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
