import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  singInWithCredentials(BuildContext context, String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password:password)
        .whenComplete(() {
      Navigator.pop(context);
    });
  }

  signUp(BuildContext context,String email, String password){
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      // If account creation was successfull, then the User gets Signed in.
      // -> This invokes the listener on the StartPage, which switches from LogInPage to HomePage.
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // This pop method is necessary to pop the SignUpPage and get to the HomePage.
      // Otherwise the SignUpPage would "overwrite" the HomePage.
      // -> See Widget Tree in Widget inspector for details and better understanding.
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      log('Error ${error.toString()}');
    });
  }

}
