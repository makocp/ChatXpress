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
  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  signInAndSetToDb(String email, String password) async {
    isLoading = true;
    emailErrorMessage = '';
    passwordErrorMessage = '';
    notifyListeners();

    if (validatedMailInput(email) && validatedPasswordInput(password)) {
      await signInWithEmailAndPassword(email, password).then((value) {
        // To create the user, if it does not exist, but a Auth Acc exists.
        // Just in case, if there was an error in SignUp with account creation in Db.
        // Does NOT overwrite current user -> see origin db method (merge true).
        setUserToDB(email);
      })
      .onError((error, stackTrace) => null);
    }

    isLoading = false;
    notifyListeners();
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      emailErrorMessage = 'Invalid Email. Please try another one.';
      return false;
    }
  }

  bool validatedPasswordInput(String password) {
    if (password.contains(' ')) {
      passwordErrorMessage = 'Password must be without spaces.';
      return false;
    }
    if (password.length < 8) {
      passwordErrorMessage = 'Password must have at least 8 characters.';
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
