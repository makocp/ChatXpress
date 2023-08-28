import 'package:chatXpress/assets/strings/my_strings.dart';
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

  // Default STATE
  bool _isLoading = false;
  String _messageEmail = '';
  String _messagePassword = '';
  String _messageConfirmation = '';

  bool get isLoading => _isLoading;
  String get messageEmail => _messageEmail;
  String get messagePassword => _messagePassword;
  String get messageConfirmation => _messageConfirmation;

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setDefaultState() {
    _messageEmail = '';
    _messagePassword = '';
    _messageConfirmation = '';
    notifyListeners();
  }

// To validate the user input, clientside.
  handleInput(String email, String password, String confirmation,
      Function popView) async {
    setLoadingState(true);

    // to reset message strings => state for new validation.
    setDefaultState();

    // Clientside validation
    if (validatedEmail(email) && validatedPassword(password, confirmation)) {
      // Serverside validation.
      await validateAndCreateUser(email, password);
    }

    // only true, if everything successful (no error messages client+server) -> starts signIn.
    if (messageEmail.isEmpty &&
        messagePassword.isEmpty &&
        messageConfirmation.isEmpty) {
      await signInWithEmailAndPassword(email, password);
      // Pops the SignUp View to get to the Chat View (gets reloaded instead of SignIn by Streambuilder AuthChanges in StartView)
      popView();
    }

    setLoadingState(false);
  }

  // validates user input directly with Auth createuser method.
  // catches respective exception and sets error string for UI state.
  // if method successful -> user gets created in Auth and then in DB.
  validateAndCreateUser(String email, String password) async {
    try {
      await createUserWithEmailAndPassword(email, password).then((value) {
        setUserToDB(email);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          _messageEmail = MyStrings.validationInvalidEmail;
          break;
        case 'invalid-email':
          _messageEmail = MyStrings.validationInvalidEmail;
          break;
        case 'operation-not-allowed':
          _messageEmail = MyStrings.validationPermissionDenied;
          break;
        case 'weak-password':
          _messagePassword = MyStrings.validationPasswordWeak;
          break;
      }
    }
  }

// return true if email is valid.
// otherwise message string get set for UI state.
  bool validatedEmail(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      _messageEmail = MyStrings.validationInvalidEmail;
      return false;
    }
  }

// return true if password is valid.
// otherwise message string get set for UI state.
  bool validatedPassword(String password, String confirmPassword) {
    if (password.length < 8) {
      _messagePassword = MyStrings.validationPasswordLength;
      return false;
    }
    if (password.contains(' ')) {
      _messagePassword = MyStrings.validationPasswordSpaces;
      return false;
    }
    if (password != confirmPassword) {
      _messageConfirmation = MyStrings.validationPasswordMatch;
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
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> setUserToDB(String email) async {
    return await db.setUser(email);
  }
}
