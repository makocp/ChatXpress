import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  handleResetInput(String email) async {
    isLoading = true;
    notifyListeners();

    if (validatedMailInput(email)) {
      // Only sends an email, if user is registered
      // -> throws an exception and catches it with onerror, if user not registered.
      // -> user does not see this via UI for security reasons.
      await resetPassword(email).onError((error, stackTrace) => null);
    }

    isLoading = false;
    notifyListeners();
  }

  bool validatedMailInput(String email) {
    if (EmailValidator.validate(email)) {
      successMessage = MyStrings.validationSuccessReset;
      errorMessage = '';
      return true;
    } else {
      errorMessage = MyStrings.validationInvalidEmail;
      return false;
    }
  }

  Future resetPassword(String email) async {
    return authService.sendPasswordResetEmail(email);
  }
}
