import 'dart:async';
import 'dart:developer';
import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/models/userchat_model.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatViewmodel extends ChangeNotifier {
  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  // Services
  final gptService = serviceContainer<GptService>();
  final firestoreService = serviceContainer<FirestoreService>();

  // Streams for UI
  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();
  late Stream<List<MessageModel>> messageStream = _messageController.stream;

  final StreamController<List<UserchatModel>> _userchatController =
      StreamController<List<UserchatModel>>.broadcast();
  late Stream<List<UserchatModel>> userchatStream = _userchatController.stream;

  // STATE of current Chat
  String _chatId = const Uuid().v1();
  List<MessageModel> _messages = [];

  // STATE of Userchats
  bool _isLoadingChats = false;
  bool _initializedUserchats = false;
  String _currentUserInitialized = '';
  List<UserchatModel> currentUserchats = [];

  // Getters for UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isLoadingChats => _isLoadingChats;
  List<MessageModel> get messages => _messages;

  // sets a new chatId and messages to empty -> for state, new chat.
  setDefaultChatState() {
    _chatId = const Uuid().v1();
    _messages = [];
    // to reset the stream -> triggers streambuilder in UI, which resets the listView.
    _messageController.add([]);
  }

  // sets userchats to default
  // -> after Logout.
  setDefaultUserchatsState() {
    _isLoadingChats = false;
    _initializedUserchats = false;
    _currentUserInitialized = '';
    currentUserchats = [];
    _userchatController.add([]);
  }

  deleteUserchatsState() {
    currentUserchats = [];
    _userchatController.add([]);
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

  // to indicate the loading of Userchats from db
  setLoadingUserchatState(bool isLoadingChats) {
    _isLoadingChats = isLoadingChats;
    notifyListeners();
  }

  // to initially load userchats from db and add them to internal state as list
  // get loaded, when opening menu drawer.
  loadCurrentUserchatsFromDB() async {
    // to set the userId for which the list is initialized.
    // -> if another user logs in, the list gets reloaded again for the new user.
    String currentUserLoggedIn = firestoreService.currentUserID();
    // initialized bool to load the chat only once from db
    if (!_initializedUserchats ||
        _currentUserInitialized != currentUserLoggedIn) {
      setLoadingUserchatState(true);
      _currentUserInitialized = currentUserLoggedIn;
      await firestoreService.getCurrentUserchats().then((chatsSnapshot) {
        // to map userchats.
        for (var doc in chatsSnapshot.docs) {
          currentUserchats.add(createUserchatModel(doc.id, doc.data()));
        }
        _initializedUserchats = true;
      }).onError((error, stackTrace) {
        log(error.toString());
      }).whenComplete(() {
        setLoadingUserchatState(false);
        // Adds loaded list to stream, which gets shown in UI via StreamBuilder.
        _userchatController.add(currentUserchats);
      });
    }
  }

  sendMessage(String prompt) async {
    setLoadingState(true);

    // in case of empty messages -> new chat, needs to be created in DB.
    if (_messages.isEmpty) {
      createNewChat(_chatId, 'New Chat');
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

  createNewChat(String chatId, String title) {
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

  UserchatModel createUserchatModel(
      String chatId, Map<String, dynamic> chatData) {
    return UserchatModel(
        chatId: chatId,
        date: (chatData['date'] as Timestamp).toDate(),
        title: chatData['title'],
        userId: chatData['userId']);
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
