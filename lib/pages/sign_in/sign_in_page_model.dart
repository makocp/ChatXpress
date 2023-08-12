import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:flutter/cupertino.dart';

class SignInPageModel {
  final authService = ServiceLocator<AuthService>();

  signInWithCredentials(BuildContext context, String email, String password) {
    authService.singInWithCredentials(context, email, password);
  }

  signInWithGoogle() {
    authService.signInWithGoogle();

  }

  signInWithApple() {
    authService.signInWithApple();
  }
}
