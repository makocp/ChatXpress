import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpViewmodel {
  final authService = serviceContainer<AuthService>();
  
  Future<UserCredential> createUserWithEmailAndPassword(String email,String password){
    return authService.createUserWithEmailAndPassword(email, password);
  }
}
