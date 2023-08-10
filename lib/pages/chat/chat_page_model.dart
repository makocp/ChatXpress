import 'package:chatXpress/pages/chat/chat_page.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import '../../models/Message.dart';

class ChatPageModel {
  final List<ChatMessage> uiMessages = [];
  final List<Messages> messages = [];

  void sendMessage(String prompt, Function function) async {
    _addPromptToChat(prompt);
    _addQuestionToUi(prompt);

    function();

    final request = ChatCompleteText(
      messages: messages,
      maxToken: 200,
      model: GptTurboChatModel(),
    );

    final response =
        await ServiceLocator<Gpt>().openAI.onChatCompletion(request: request);

    var message = response?.choices.isNotEmpty == true
        ? response!.choices.last.message
        : null;

    if(message!.content != null){

    }
    _addResponseToUi(message.content);
    function();
  }

  void _addPromptToChat(String prompt) {
    messages.add(Messages(
      role: Role.user,
      content: prompt,
    ));
  }

  void _addResponseToChat(String response) {
    messages.add(Messages(
      role: Role.assistant,
      content: response,
    ));
  }

  void _addQuestionToUi(String prompt) {
    ChatMessage messageWidget = ChatMessage(text: prompt, sender: "user");
    uiMessages.add(messageWidget);
  }

  void _addResponseToUi(String response) {
    uiMessages.add(ChatMessage(
      text: response ?? "Something went wrong, please try again later",
      sender: "ChatGpt",
    ));
    _addResponseToChat(response);
  }
}
