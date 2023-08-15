import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import '../../components/chat_components/chat_message.dart';

class ChatViewmodel {
  final List<MessageViewModel> messages = [];
  List<ChatMessage> uiMessages = [];
  bool requestWaiting = false;
  final gptService = serviceContainer<GptService>();

  void sendMessage(String prompt, Function function) async {
    requestWaiting = true;

      // add the message to the UI
    _addQuestionChat(prompt);

    // set the state
    function();

    // get the prompt response
    var response = await gptService.sendRequest(prompt);

    requestWaiting = false;

    // add the response to the UI
    _addResponseToChat(response);



    // set the state
    function();
  }

  void _addQuestionChat(String prompt) {
    messages.insert(0,MessageViewModel(content: prompt, date: DateTime.now(), sender: "user",messageType: MessageType.request));
  }

  void _addResponseToChat(String response) {
    var messageType = response[0] == "*" ? MessageType.error : MessageType.response;
    messages.insert(0,MessageViewModel(content: response, date: DateTime.now(), sender: "ChatGpt", messageType:messageType));
  }
}
