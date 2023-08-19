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
  bool isLoading = false;
  String messageEmail = '';
  String messagePassword = '';

  // To sign the user in, checks before client and server side validation of email and password.
  // -> sets errormessages as state to UI for the user.
  handleSignInInput(String email, String password) async {
    setLoadingState();

    // to reset message strings => state for new validation.
    messageEmail = '';
    messagePassword = '';

    // Clientside validation.
    if (validatedMailInput(email) && validatedPasswordInput(password)) {
      // Serverside validation.
      await validateAndSignIn(email, password);
    }

    unsetLoadingState();
  }

  // serverside validation, if successful -> sign user in.
  // otherwise set string messages for UI state.
  validateAndSignIn(String email, String password) async{
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
            messageEmail = MyStrings.validationInvalidEmail;
            break;
          case 'user-disabled':
            messageEmail = MyStrings.validationUserDisabled;
            break;
          case 'user-not-found':
            messageEmail = MyStrings.validationWrongEmailPassword;
            messagePassword = MyStrings.validationWrongEmailPassword;
            break;
          case 'wrong-password':
            messageEmail = MyStrings.validationWrongEmailPassword;
            messagePassword = MyStrings.validationWrongEmailPassword;
            break;
        }
      }
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      messageEmail = MyStrings.validationInvalidEmail;
      return false;
    }
  }

  bool validatedPasswordInput(String password) {
    if (password.contains(' ')) {
      messageEmail = MyStrings.validationWrongEmailPassword;
      messagePassword = MyStrings.validationWrongEmailPassword;
      return false;
    }
    if (password.length < 8) {
      messageEmail = MyStrings.validationWrongEmailPassword;
      messagePassword = MyStrings.validationWrongEmailPassword;
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
    setLoadingState();
    return await authService.signInWithGoogle().whenComplete(() => unsetLoadingState());
  }

  Future<UserCredential> signInWithApple() async {
    setLoadingState();
    return await authService.signInWithApple().whenComplete(() => unsetLoadingState());
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }

  void setLoadingState(){
    isLoading = true;
    notifyListeners();
  }

  void unsetLoadingState(){
    isLoading = false;
    notifyListeners();
  }
}
