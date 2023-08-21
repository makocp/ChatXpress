import 'dart:async';
import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/foundation.dart';

class ChatViewmodel extends ChangeNotifier {
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  // werden wir brauchen wenn wir außerhalb des Viewmodels den Chat zuweisen
  // Wenn wir beispielweise bei Menu den CurrentChat setzen
  set messages(List<MessageModel> value) {
    _messages = value;
    notifyListeners();
  }

  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();
  late Stream<List<MessageModel>> messageStream = _messageController.stream;

  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  bool get requestWaiting => _requestWaiting;
  bool _requestWaiting = false;

  final gptService = serviceContainer<GptService>();

  void sendMessage(String prompt) async {
    _requestWaiting = true;

    _addQuestionChat(prompt);
    _messageController.add(messages);

    var response = await gptService.sendRequest(prompt);

    _requestWaiting = false;

    _addResponseToChat(response);
    _messageController.add(messages);
  }

  void _addQuestionChat(String prompt) {
    var message = MessageModel(
        content: prompt,
        date: DateTime.now(),
        sender: "user",
        messageType: MessageType.request);
    _messages.insert(0, message);
    notifyListeners();
  }

  void _addResponseToChat(String response) {
    var messageType =
        response[0] == "*" ? MessageType.error : MessageType.response;
    var message = MessageModel(
        content: response,
        date: DateTime.now(),
        sender: "ChatGpt",
        messageType: messageType);
    _messages.insert(0, message);
    notifyListeners();
  }
}
