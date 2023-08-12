import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';

class ForgotPasswordViewmodel {
  final authService = serviceContainer<AuthService>();

  Future<void> resetPassword(String email) async {
    return authService.resetPassword(email);
  }
}
