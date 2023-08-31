import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();

  // Default STATE
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setDefaultState() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }

  handleResetInput(String email) async {
    setLoadingState(true);

    if (validatedMailInput(email)) {
      // Only sends an email, if user is registered
      // -> throws an exception and catches it with onerror, if user not registered.
      // -> user does not see this via UI for security reasons.
      await resetPassword(email).onError((error, stackTrace) => null);
    }

    setLoadingState(false);
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      _successMessage = MyStrings.validationSuccessReset;
      _errorMessage = '';
      return true;
    } else {
      _errorMessage = MyStrings.validationInvalidEmail;
      return false;
    }
  }

  Future resetPassword(String email) async {
    return authService.sendPasswordResetEmail(email);
  }
}
