import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatXpress/secrets.dart';

class GptService{
  final List<Messages> messages = [];

  final openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
    enableLog: true,
  );

  Future<String> sendRequest(String prompt) async{
    _addPromptToChat(prompt);

    final request = ChatCompleteText(
      messages: messages,
      maxToken: 200,
      model: GptTurboChatModel(),
    );

    final response =
        await openAI.onChatCompletion(request: request);

    var message = response?.choices.isNotEmpty == true
        ? response!.choices.last.message
        : null;

    _addResponseToChat(message!.content);
    return message.content;
  }

  void _addResponseToChat(String response) {
    messages.add(Messages(
      role: Role.assistant,
      content: response,
    ));
  }

  void _addPromptToChat(String prompt) {
    messages.add(Messages(
      role: Role.user,
      content: prompt,
    ));
  }
}