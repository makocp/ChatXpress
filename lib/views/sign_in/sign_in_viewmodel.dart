import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../services/firestore_service.dart';

class SignInViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final db = serviceContainer<FirestoreService>();

  // Default STATE
  bool _isLoading = false;
  String _messageEmail = '';
  String _messagePassword = '';

  bool get isLoading => _isLoading;
  String get messageEmail => _messageEmail;
  String get messagePassword => _messagePassword;

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setDefaultState() {
    _messageEmail = '';
    _messagePassword = '';
    notifyListeners();
  }

  // To sign the user in, checks before client and server side validation of email and password.
  // -> sets errormessages as state to UI for the user.
  handleSignInInput(String email, String password) async {
    setLoadingState(true);

    // to reset message strings => state for new validation.
    _messageEmail = '';
    _messagePassword = '';

    // Clientside validation.
    if (validatedMailInput(email) && validatedPasswordInput(password)) {
      // Serverside validation.
      await validateAndSignIn(email, password);
    }

    setLoadingState(false);
  }

  // serverside validation, if successful -> sign user in.
  // otherwise set string messages for UI state.
  validateAndSignIn(String email, String password) async {
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
          _messageEmail = MyStrings.validationInvalidEmail;
          break;
        case 'user-disabled':
          _messageEmail = MyStrings.validationUserDisabled;
          break;
        case 'user-not-found':
          _messageEmail = MyStrings.validationWrongEmailPassword;
          _messagePassword = MyStrings.validationWrongEmailPassword;
          break;
        case 'wrong-password':
          _messageEmail = MyStrings.validationWrongEmailPassword;
          _messagePassword = MyStrings.validationWrongEmailPassword;
          break;
      }
    }
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      _messageEmail = MyStrings.validationInvalidEmail;
      return false;
    }
  }

  bool validatedPasswordInput(String password) {
    if (password.contains(' ')) {
      _messageEmail = MyStrings.validationWrongEmailPassword;
      _messagePassword = MyStrings.validationWrongEmailPassword;
      return false;
    }
    if (password.length < 8) {
      _messageEmail = MyStrings.validationWrongEmailPassword;
      _messagePassword = MyStrings.validationWrongEmailPassword;
      return false;
    }
    return true;
  }

// here no set and unloading state implemented, because signin gets only called in handle input method, where this action is already performed.
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await authService.signInWithEmailAndPassword(email, password);
  }

// Sets loading state for apple and google sign in to block user interactions while performing.
  Future<UserCredential> signInWithGoogle() async {
    setLoadingState(true);
    return await authService
        .signInWithGoogle();
  }

  Future<UserCredential> signInWithApple() async {
    setLoadingState(true);
    return await authService
        .signInWithApple();
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }
}
