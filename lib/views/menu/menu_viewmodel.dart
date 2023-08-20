import 'dart:async';

import 'package:chatXpress/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();

  final StreamController<bool> _requestProgressingController =
      StreamController<bool>.broadcast();
  late Stream<bool> progressStream = _requestProgressingController.stream;

  void createNewChat() {}

  void openChat() {}

  void cleanHistory() {}

  Future<String> updatePassword(String newPassword) async {
    _requestProgressingController.add(true);
    var message = "";
    var response = await authService.updatePassword(newPassword);
    await Future.delayed(Duration(seconds: 3));
    _requestProgressingController.add(false);

    switch (response) {
      case "An error occurred":
        message = "An error occurred";
        break;
      case "weak-password":
        message = "The password provided is too weak.";
        break;
      case "requires-recent-login":
        message =
            "This operation requires recent authentication. Log in again before retrying this request.";
        break;
      case "user-not-found":
        message = "User not found. Please check your authentication.";
        break;
      case "user-disabled":
        message = "The user account has been disabled by an administrator.";
        break;
      case "wrong-password":
        message = "The old password is incorrect.";
        break;
      default:
        message = "Successfully changed password";
    }
    return message;
  }

  Future<void> logOut() async {
    return authService.logOut();
  }
}
