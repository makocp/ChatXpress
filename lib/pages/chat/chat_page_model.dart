import 'package:chatXpress/pages/chat/chat_page.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatPageModel {
  final List<ChatMessage> uiMessages = [];

  void sendMessage(String prompt, Function function) async {
    _addQuestionToUi(prompt);

    function();

    var response = await ServiceLocator<Gpt>().sendRequest(prompt);

    _addResponseToUi(response);

    function();
  }

  void _addQuestionToUi(String prompt) {
    ChatMessage messageWidget = ChatMessage(text: prompt, sender: "user");
    uiMessages.add(messageWidget);
  }

  void _addResponseToUi(String response) {
    uiMessages.add(ChatMessage(
      text: response,
      sender: "ChatGpt",
    ));
  }
}
