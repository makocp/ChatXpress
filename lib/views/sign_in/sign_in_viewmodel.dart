import 'dart:developer';

import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../../services/firestore_service.dart';

class SignInViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final db = serviceContainer<FirestoreService>();
  bool isLoading = false;
  String errorMessage = '';

  // To sign the user in, checks before client and server side validation of email and password.
  // -> sets errormessages as state to UI for the user.
  signInAndSetToDb(String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // Clientside validation.
    if (validatedMailInput(email)) {
      try {
        await signInWithEmailAndPassword(email, password).then((value) {
          // To create the user, if it does not exist, but a Auth Acc exists.
          // Just in case, if there was an error in SignUp with account creation in Db.
          // Does NOT overwrite current user -> see origin db method (merge true).
          // - onError is necassery, so the method continues, otherwise it would stop at an Exception.
          setUserToDB(email).onError((error, stackTrace) => null);
        });
        // Serverside validation already there by Firebase.
        // Catches the error messages and sets it as state for UI to show it to the user.
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Invalid Email. Please try another one.';
            break;
          case 'user-disabled':
            errorMessage =
                'This user is disabled. Please contact support.';
            break;
          case 'user-not-found':
            errorMessage = 'Wrong email or password. Please try again.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong email or password. Please try again.';
            break;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      errorMessage = 'Invalid Email. Please try another one.';
      return false;
    }
  }

  bool validatedPasswordInput(String password) {
    if (password.contains(' ')) {
      errorMessage = 'Wrong email or password. Please try again.';
      return false;
    }
    if (password.length < 8) {
      errorMessage = 'Wrong email or password. Please try again.';
      return false;
    }
    return true;
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithGoogle() async {
    return await authService.signInWithGoogle();
  }

  Future<UserCredential> signInWithApple() async {
    return await authService.signInWithApple();
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }
}
