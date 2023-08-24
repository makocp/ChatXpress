import 'dart:async';
import 'dart:developer';

import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final firestoreService = serviceContainer<FirestoreService>();
  final chatViewModel = serviceContainer<ChatViewmodel>();

  final StreamController<bool> _requestProgressingController =
      StreamController<bool>.broadcast();
  late Stream<bool> progressStream = _requestProgressingController.stream;

  void createNewChat() {
    chatViewModel.setDefaultChatState();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCurrentUserChats() async {
    QuerySnapshot<Map<String, dynamic>> test = await firestoreService.getCurrentUserChats();
    log('is from cache: ${test.metadata.isFromCache.toString()}');
    return test;
  }

  void openChat() {}

  void deleteHistory() {
    firestoreService.deleteChats();
  }

  Future<String> updatePassword(String newPassword) async {
    _requestProgressingController.add(true);
    var message = "";
    var response = await authService.updatePassword(newPassword);
    await Future.delayed(const Duration(seconds: 3));
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
    return authService
        .logOut()
        // to set the chat state to default, if user log outs and opens new chat -> new state, new chat ID, new chat view.
        .then((value) => chatViewModel.setDefaultChatState());
  }
}
