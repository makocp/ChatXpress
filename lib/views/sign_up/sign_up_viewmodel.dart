import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';

class SignUpViewmodel {
  final authService = serviceContainer<AuthService>();
  
  Future signUp(String email,String password){
    return authService.signUp(email, password);
  }
}
