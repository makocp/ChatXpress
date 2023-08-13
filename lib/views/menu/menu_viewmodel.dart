import 'package:chatXpress/services/auth_service.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel {
  final authService = serviceContainer<AuthService>();

  void createNewChat() {}

  void openChat() {}

  void cleanHistory() {}

  Future<void> resetPassword() async {
    return authService.sendPasswordReset();
  }

  Future<void> logOut() async {
    return authService.logOut();
  }
}
