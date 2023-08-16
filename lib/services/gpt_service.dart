import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatXpress/secrets.dart';

class GptService {
  final List<Messages> messages = [];

  final openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 15)),
    enableLog: true,
  );

  Future<String> sendRequest(String prompt) async {
    _addPromptToChat(prompt);

    final request = ChatCompleteText(
      messages: messages,
      maxToken: 200,
      model: GptTurboChatModel(),
    );
    var message = await _handleRequest(request);

    _addResponseToChat(message);
    return message;
  }

  Future<String> _handleRequest(ChatCompleteText request) async {
    String message = "";

    await openAI.onChatCompletion(request: request).then((response) {
      if (response!.choices.isNotEmpty) {
        message = response.choices.last.message!.content;
      }
    }).onError((error, stackTrace) {
      message = "* An error occurred: $error *";
    });

    return message;
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
