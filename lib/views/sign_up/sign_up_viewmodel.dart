import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/models/user_viewmodel.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SignUpViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final db = serviceContainer<FirestoreService>();
  String messageEmail = '';
  String messagePassword = '';
  String messageConfirmation = '';
  bool isLoading = false;

// To validate the user input, clientside.
  bool handleInput(String email, String password, String confirmPassword) {
    setLoadingState();

// to reset message strings => state for new validation.
    resetValidation();

// Clientside validation
    if (validatedEmail(email) && validatedPassword(password, confirmPassword)) {
      unsetLoadingState();
      return true;
      // await validateAndCreateUser(email, password);
    } else {
      unsetLoadingState();
      return false;
    }
  }

// validates user input directly with Auth createuser method.
// catches respective exception and sets error string for UI state.
// if method successful -> user gets created in Auth and then in DB.
  Future<void> validateAndCreateUser(UserViewmodel userViewmodel) async {
    try {
      setLoadingState();

      await createUserWithEmailAndPassword(
              userViewmodel.email, userViewmodel.password)
          .then((value) {
        setUserToDB(userViewmodel.email, userViewmodel.username);
        unsetLoadingState();
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          messageEmail = MyStrings.validationInvalidEmail;
          break;
        case 'invalid-email':
          messageEmail = MyStrings.validationInvalidEmail;
          break;
        case 'operation-not-allowed':
          messageEmail = MyStrings.validationPermissionDenied;
          break;
        case 'weak-password':
          messagePassword = MyStrings.validationPasswordWeak;
          break;
      }
      unsetLoadingState();
    }
  }

// return true if email is valid.
// otherwise message string get set for UI state.
  bool validatedEmail(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      messageEmail = MyStrings.validationInvalidEmail;
      return false;
    }
  }

// return true if password is valid.
// otherwise message string get set for UI state.
  bool validatedPassword(String password, String confirmPassword) {
    if (password.length < 8) {
      messagePassword = MyStrings.validationPasswordLength;
      return false;
    }
    if (password.contains(' ')) {
      messagePassword = MyStrings.validationPasswordSpaces;
      return false;
    }
    if (password != confirmPassword) {
      messagePassword = MyStrings.validationPasswordMatch;
      return false;
    }
    return true;
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await authService.createUserWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    setLoadingState();
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> setUserToDB(String email, String username) async {
    return await db.setUser(email, username);
  }

  void setLoadingState() {
    isLoading = true;
    notifyListeners();
  }

  void unsetLoadingState() {
    isLoading = false;
    notifyListeners();
  }

  void resetValidation() {
    messageEmail = '';
    messagePassword = '';
    messageConfirmation = '';
  }
}
