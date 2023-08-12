import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/cupertino.dart';

class SignInViewmodel {
  final authService = serviceContainer<AuthService>();

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
