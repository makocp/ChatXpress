import 'dart:async';
import 'dart:developer';
import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatViewmodel extends ChangeNotifier {
  final gptService = serviceContainer<GptService>();
  final firestoreService = serviceContainer<FirestoreService>();

  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();
  late Stream<List<MessageModel>> messageStream = _messageController.stream;

  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // to generate a random id for chat to set in db.
  // STATE of current Chat
  String _chatId = const Uuid().v1();
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  // sets a new chatId and messages to empty -> for state, new chat.
  setDefaultChatState() {
    _chatId = const Uuid().v1();
    _messages = [];
    // to reset the stream -> triggers streambuilder in UI, which resets the listView.
    _messageController.add([]);
  }

  // to set the loading state for response, for the UI to show the progress indicator.
  setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // to set the state for UI with the data of the loaded chat.
  setChatState(String chatId) async {
    // to show progress indicator in chatview.
    setLoadingState(true);
    _chatId = chatId;
    _messages = [];

    // get chatMessages from db.
    await firestoreService.getChatMessages(chatId).then((data) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> chatMessagesAsList =
          data.docs;
      // to iterate through every message and map it back to MessageModel (for the UI)
      for (var chatMessageEntry in chatMessagesAsList) {
        Map<String, dynamic> chatMessageData = chatMessageEntry.data();
        String messageText = chatMessageData['content'];
        DateTime date = (chatMessageData['date'] as Timestamp).toDate();
        String sender = chatMessageData['sender'];
        MessageType messageType =
            MessageType.values.byName(chatMessageData['type']);

        MessageModel messageModel =
            mapMessageModel(chatId, messageText, date, sender, messageType);

        // to insert the messages in the list for the messageController.
        _messages.insert(0, messageModel);
      }
    }).onError((error, stackTrace) {
      log(error.toString());
    }).whenComplete(() {
      // to add the finished message list to the stream (to display in UI / ChatView)
      _messageController.add(_messages);
      setLoadingState(false);
    });
  }

  sendMessage(String prompt) async {
    setLoadingState(true);

    // in case of empty messages -> new chat, needs to be created in DB.
    if (_messages.isEmpty) {
      setChatToDB(_chatId, 'New Chat');
    }

    MessageModel messageRequest = createNewMessageModel(prompt, true);
    _addMessageToChat(messageRequest);
    _addMessageToDB(messageRequest);

    var response = await gptService.sendRequest(prompt);

    MessageModel messageResponse = createNewMessageModel(response, false);
    _addMessageToChat(messageResponse);
    _addMessageToDB(messageResponse);

    if (messages.length == 2 || messages.length == 4) {
      generateChatTitle();
    }

    setLoadingState(false);
  }

  //
  setChatToDB(String chatId, String title) {
    firestoreService.setChat(chatId, title);
  }

  // to convert the request/response string to a MessageModel object for further use (set to Chat UI, insert into DB)
  // isRequest parameter gets passed, to define sender and messagetype.
  MessageModel createNewMessageModel(String messageText, bool isRequest) {
    return MessageModel(
        chatId: _chatId,
        content: messageText,
        date: DateTime.now(),
        sender: isRequest ? "user" : "ChatGpt",
        messageType: isRequest
            ? MessageType.request
            : messageText[0] == "*"
                ? MessageType.error
                : MessageType.response);
  }

  MessageModel mapMessageModel(String chatId, String messageText, DateTime date,
      String sender, MessageType messageType) {
    return MessageModel(
        chatId: chatId,
        content: messageText,
        date: date,
        sender: sender,
        messageType: messageType);
  }

  // to add message to list and controller, which notifies the stream (for UI display)
  _addMessageToChat(MessageModel message) {
    _messages.insert(0, message);
    _messageController.add(messages);
  }

  // to add message to DB
  _addMessageToDB(MessageModel message) {
    firestoreService.addMessage(message);
  }

  void generateChatTitle() async {
    var title = await gptService.generateChatTitle();
    firestoreService.updateChatTitle(_chatId, title);
  }
}
