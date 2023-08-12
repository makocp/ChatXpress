import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/cupertino.dart';

class SignUpViewmodel {
  final authService = serviceContainer<AuthService>();
  signUp(BuildContext context,String email,String password){
    authService.signUp(context, email, password);
  }
}
