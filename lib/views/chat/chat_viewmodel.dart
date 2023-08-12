import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import '../../components/chat_components/chat_message.dart';

class ChatViewmodel {
  final List<ChatMessage> uiMessages = [];
  final gptService = serviceContainer<GptService>();

  void sendMessage(String prompt, Function function) async {
      // add the message to the UI
    _addQuestionToUi(prompt);

    // set the state
    function();

    // get the prompt response
    var response = await gptService.sendRequest(prompt);

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
