import 'dart:async';

import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final firestoreService = serviceContainer<FirestoreService>();
  final chatViewModel = serviceContainer<ChatViewmodel>();

  void openNewChat() {
    chatViewModel.setDefaultChatState();
  }

  void openChat(String chatId) {
    // set UI state ChatViewmodel
    chatViewModel.setChatState(chatId);
  }

  void deleteHistory() {
    firestoreService.deleteChats();
    chatViewModel.deleteUserchatsState();
    chatViewModel.setDefaultChatState();
  }

  Future<void> logOut() async {
    return authService
        .logOut()
        // to set the chat state to default, if user log outs and opens new chat -> new state, new chat ID, new chat view.
        .then((value) {
      chatViewModel.setDefaultChatState();
      chatViewModel.setDefaultUserchatsState();
    });
  }
}
