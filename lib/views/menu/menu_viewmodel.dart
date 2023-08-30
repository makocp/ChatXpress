import 'dart:async';

import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final firestoreService = serviceContainer<FirestoreService>();
  final chatViewModel = serviceContainer<ChatViewmodel>();

  bool _isLoadingChangePassword = false;
  bool get isLoadingChangePassword => _isLoadingChangePassword;

  String _changePasswordMessage = '';
  String get changePasswordMessage => _changePasswordMessage;

  setLoadingChangePasswordState(bool isLoadingChangePassword) {
    _isLoadingChangePassword = isLoadingChangePassword;
    notifyListeners();
  }

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

  updatePassword(String newPassword, String newConfirmationPassword) async {
    setLoadingChangePasswordState(true);
    // Clientside validation
    if (validatedPassword(newPassword, newConfirmationPassword)) {
      try {
        await authService.updatePassword(newPassword);
        // Serverside Validation, catches error.
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'weak-password':
            _changePasswordMessage = MyStrings.validationPasswordWeak;
            break;
          case 'requires-recent-login':
            _changePasswordMessage = MyStrings.validationReauthentication;
            break;
        }
      }
    }
    setLoadingChangePasswordState(false);
  }

  // return true if password is valid.
  // otherwise message string get set for UI state.
  bool validatedPassword(String newPassword, String newConfirmationPassword) {
    if (newPassword.length < 8) {
      _changePasswordMessage = MyStrings.validationPasswordLength;
      return false;
    }
    if (newPassword.contains(' ')) {
      _changePasswordMessage = MyStrings.validationPasswordSpaces;
      return false;
    }
    if (newPassword != newConfirmationPassword) {
      _changePasswordMessage = MyStrings.validationPasswordMatch;
      return false;
    }
    return true;
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
