import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';

class SignInViewmodel {
  final authService = serviceContainer<AuthService>();

  Future signInWithCredentials(String email, String password) {
    return authService.singInWithCredentials(email, password);
  }

  Future signInWithGoogle() {
    return authService.signInWithGoogle();

  }

  Future signInWithApple() {
    return authService.signInWithApple();
  }
}
