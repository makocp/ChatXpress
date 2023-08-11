import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:flutter/cupertino.dart';

class SignUpPageModel {
  final authService = ServiceLocator<AuthService>();
  signUp(BuildContext context,String email,String password){
    authService.signUp(context, email, password);
    unregisterSignUpService();
  }
}
