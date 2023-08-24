import 'dart:async';
import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatViewmodel extends ChangeNotifier {
  final gptService = serviceContainer<GptService>();
  final firestoreService = serviceContainer<FirestoreService>();

  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();
  late Stream<List<MessageModel>> messageStream = _messageController.stream;

  bool get requestWaiting => _requestWaiting;
  bool _requestWaiting = false;

  // to generate a random id for chat to set in db.
  // TODO: changes according to chat. -> if new chat, random it, if existing chat -> get id.
  String chatId = const Uuid().v1();
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  // sets a new chatId and messages to empty -> for state, new chat.
  setDefaultChatState() {
    chatId = const Uuid().v1();
    _messages = [];
    // to reset the stream -> triggers streambuilder in UI, which resets the listView.
    _messageController.add([]);
    notifyListeners();
  }

  // TODO: call bei click von Chat (MenuVm)
  loadChatState() {}

  // werden wir brauchen wenn wir außerhalb des Viewmodels den Chat zuweisen
  // Wenn wir beispielweise bei Menu den CurrentChat setzen
  set messages(List<MessageModel> value) {
    _messages = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  void sendMessage(String prompt) async {
    _requestWaiting = true;

    // in case of empty messages -> new chat, needs to be created in DB.
    if (_messages.isEmpty) {
      setChatToDB(chatId, 'New Chat');
    }

    MessageModel messageRequest = getMessageModel(prompt, true);
    _addMessageToChat(messageRequest);
    _addMessageToDB(messageRequest);

    var response = await gptService.sendRequest(prompt);

    _requestWaiting = false;

    MessageModel messageResponse = getMessageModel(response, false);
    _addMessageToChat(messageResponse);
    _addMessageToDB(messageResponse);
  }

  //
  setChatToDB(String chatId, String title) {
    firestoreService.setChat(chatId, title);
  }

  // to convert the request/response string to a MessageModel object for further use (set to Chat UI, insert into DB)
  // isRequest parameter gets passed, to define sender and messagetype.
  MessageModel getMessageModel(String message, bool isRequest) {
    return MessageModel(
        chatId: chatId,
        content: message,
        date: DateTime.now(),
        sender: isRequest ? "user" : "ChatGpt",
        messageType: isRequest
            ? MessageType.request
            : message[0] == "*"
                ? MessageType.error
                : MessageType.response);
  }

  // to add message to list and controller, which notifies the stream (for UI display)
  _addMessageToChat(MessageModel message) {
    _messages.insert(0, message);
    notifyListeners();
    _messageController.add(messages);
  }

  // to add message to DB
  _addMessageToDB(MessageModel message) {
    firestoreService.addMessage(message);
  }
}
