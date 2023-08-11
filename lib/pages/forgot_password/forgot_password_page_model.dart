import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/injection_container.dart';

class ForgotPasswordPageModel {
  final authService = ServiceLocator<AuthService>();

  Future<void> resetPassword(String email) async {
    return authService.resetPassword(email);
  }
}
