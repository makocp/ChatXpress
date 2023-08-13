import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/toast_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInViewmodel {
  final authService = serviceContainer<AuthService>();
  final toastService = serviceContainer<ToastService>();

  Future<UserCredential> singInWithEmailAndPassword(String email, String password) {
    return authService.singInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithGoogle() {
    return authService.signInWithGoogle();

  }

  Future<UserCredential> signInWithApple() {
    return authService.signInWithApple();
  }

  showSuccessToast(String message) {
    toastService.showSuccessToast(message);
  }

  showErrorToast(String message) {
    toastService.showErrorToast(message);
  }

  
}
