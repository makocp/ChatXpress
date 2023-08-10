import 'package:chatXpress/pages/chat/chat_page.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'chat_components/chat_message.dart';

class ChatPageModel {
  final List<ChatMessage> uiMessages = [];

  void sendMessage(String prompt, Function function) async {
      // add the message to the UI
    _addQuestionToUi(prompt);

    // set the state
    function();

    // get the prompt response
    var response = await ServiceLocator<Gpt>().sendRequest(prompt);

    // add the response to the UI
    _addResponseToUi(response);

    // set the state
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
