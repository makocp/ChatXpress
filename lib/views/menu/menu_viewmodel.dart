import 'dart:async';
import 'dart:developer';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../services_provider/service_container.dart';

class MenuViewmodel extends ChangeNotifier {
  final authService = serviceContainer<AuthService>();
  final firestoreService = serviceContainer<FirestoreService>();
  final chatViewModel = serviceContainer<ChatViewmodel>();

  final StreamController<bool> _requestProgressingController =
      StreamController<bool>.broadcast();
  late Stream<bool> progressStream = _requestProgressingController.stream;

  String _changePasswordMessage = '';

  String get changePasswordMessage => _changePasswordMessage;

  void setPasswordMessage(String message) {
    _changePasswordMessage =  message;
    notifyListeners();
  }

  void createNewChat() {
    chatViewModel.setDefaultChatState();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCurrentUserChats() async {
    QuerySnapshot<Map<String, dynamic>> test =
        await firestoreService.getCurrentUserChats();
    log('is from cache: ${test.metadata.isFromCache.toString()}');
    return test;
  }

  void openChat(String chatId) {
    // set UI state ChatViewmodel
    chatViewModel.setChatState(chatId);
  }

  void deleteHistory() {
    firestoreService.deleteChats();
  }

  updatePassword(String newPassword, String newConfirmationPassword) async {
    _requestProgressingController.add(true);
    // Clientside validation
    if (validatedPassword(newPassword, newConfirmationPassword)) {
      try {
        await authService.updatePassword(newPassword);
        // Serverside Validation, catches error.
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'weak-password':
            setPasswordMessage(MyStrings.validationPasswordWeak);
            break;
          case 'requires-recent-login':
            setPasswordMessage(MyStrings.validationReauthentication);
            break;
        }
      }
    }
    _requestProgressingController.add(false);
  }

  bool validatedPassword(String newPassword, String newConfirmationPassword) {
    if (newPassword.length < 8) {
      setPasswordMessage(MyStrings.validationPasswordLength);
      return false;
    }
    if (newPassword.contains(' ')) {
      setPasswordMessage(MyStrings.validationPasswordSpaces);
      return false;
    }
    if (newPassword != newConfirmationPassword) {
      setPasswordMessage(MyStrings.validationPasswordMatch);
      return false;
    }
    return true;
  }

  Future<void> logOut() async {
    return authService
        .logOut()
        // to set the chat state to default, if user log outs and opens new chat -> new state, new chat ID, new chat view.
        .then((value) => chatViewModel.setDefaultChatState());
  }
}
