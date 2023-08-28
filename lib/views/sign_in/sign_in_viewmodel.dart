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
      await signInWithEmailAndPassword(email, password);
    }

    setLoadingState(false);
  }

  // serverside validation, if successful -> sign user in.
  // otherwise set string messages for UI state.
  signInWithEmailAndPassword(String email, String password) async {
    try {
      await authService
          .signInWithEmailAndPassword(email, password)
          .then((value) {
        // To create the user, if it does not exist, but a Auth Acc exists.
        // Just in case, if there was an error in SignUp with account creation in Db.
        // Does NOT overwrite current user -> see origin db method (merge true).
        // - onError is necassery, so the method continues, otherwise it would stop at an Exception.
        setUserToDB(email);
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

  signInWithGoogle() async {
    setLoadingState(true);
    await authService
        .signInWithGoogle()
        .then((value) {
          setUserToDB(value.user!.email.toString());
        })
        .onError((error, stackTrace) => null)
        .whenComplete(() => setLoadingState(false));
  }

  signInWithApple() async {
    setLoadingState(true);
    await authService
        .signInWithApple()
        .then((value) {
          // To check, if email is anonymous, to avoid "null" in database.
          String email = value.user?.email == null
              ? "Apple Anonymous"
              : value.user!.email.toString();
          setUserToDB(email);
        })
        .onError((error, stackTrace) => null)
        .whenComplete(() => setLoadingState(false));
  }

  // Gets called after EACH SignIn !
  // -> Create, if NOT exist! (set method with merge:true)
  // Otherwise you would need to check, if the user exist and then create it.
  setUserToDB(String email) async {
    await db.setUser(email).onError((error, stackTrace) => null);
  }
}
