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

  final StreamController<bool> _requestProgressingController =
      StreamController<bool>.broadcast();
  late Stream<bool> progressStream = _requestProgressingController.stream;

  String _changePasswordError = '';
  String get changePasswordError => _changePasswordError;
  String _changePasswordSuccess = '';
  String get changePasswordSuccess => _changePasswordSuccess;

  void setErrorMessage(String message) {
    _changePasswordError =  message;
    notifyListeners();
  }

  void setSuccessMessage(String message) {
    _changePasswordSuccess = message;
    notifyListeners();
  }

  void setDefaultState(){
    _changePasswordError = '';
    _changePasswordSuccess = '';
    notifyListeners();
  }

  void createNewChat() {
    chatViewModel.setDefaultChatState();
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
    setDefaultState();
    // Clientside validation
    if (validatedPassword(newPassword, newConfirmationPassword)) {
      try {
        await authService.updatePassword(newPassword)
        .then((value) {
          setSuccessMessage(MyStrings.validationSuccessChangePassword);
        });
        // Serverside Validation, catches error.
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'weak-password':
            setErrorMessage(MyStrings.validationPasswordWeak);
            break;
          case 'requires-recent-login':
            setErrorMessage(MyStrings.validationReauthentication);
            break;
        }
      }
    }
    _requestProgressingController.add(false);
  }

  bool validatedPassword(String newPassword, String newConfirmationPassword) {
    if (newPassword.length < 8) {
      setErrorMessage(MyStrings.validationPasswordLength);
      return false;
    }
    if (newPassword.contains(' ')) {
      setErrorMessage(MyStrings.validationPasswordSpaces);
      return false;
    }
    if (newPassword != newConfirmationPassword) {
      setErrorMessage(MyStrings.validationPasswordMatch);
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
