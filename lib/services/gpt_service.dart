import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatXpress/secrets.dart';

class GptService {
  final openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
    enableLog: true,
  );

  // Generates a response in context based on whole chat history, including last prompt from user.
  Future<String> generateResponse(List<MessageModel> messages) async {
    // maps the given chat history to generate a request object.
    List<Messages> gptMessages = mapMessagesToGptMessages(messages);
    gptMessages.add(instructionMessage('response in maximum 100 words'));
    ChatCompleteText messagesAsRequest = ChatCompleteText(
      messages: gptMessages,
      maxToken: 600,
      model: GptTurboChatModel(),
    );
    return await _getResponse(messagesAsRequest);
  }

  // to generate a chat title
  Future<String> generateChatTitle(List<MessageModel> messages) async {
    List<Messages> gptMessages = mapMessagesToGptMessages(messages);
    gptMessages.add(
      instructionMessage('summerize the conversation in max. 3 words'),
    );
    ChatCompleteText messagesAsRequest = ChatCompleteText(
      messages: gptMessages,
      maxToken: 10,
      model: GptTurboChatModel(),
    );
    return await _getResponse(messagesAsRequest);
  }

  // maps the messages state list to gpt messages -> to be able to generate a request
  List<Messages> mapMessagesToGptMessages(List<MessageModel> messages) {
    return messages.map((message) {
      Role role = message.messageType == MessageType.request
          ? Role.user
          : Role.assistant;
      return Messages(
        role: role,
        content: message.content,
      );
    }).toList();
  }

  // adds an instruction message to influence the response based on it.
  Messages instructionMessage(String instruction) {
    return Messages(role: Role.system, content: instruction);
  }

  Future<String> _getResponse(ChatCompleteText request) async {
    String message = "";

    await openAI.onChatCompletion(request: request).then((response) {
      if (response!.choices.isNotEmpty) {
        message = response.choices.last.message!.content;
      }
    }).onError((error, stackTrace) {
      if (error.toString().contains('Incorrect API key provided')) {
        message =
            "* No API key set, please contact developers for more information.";
      } else {
        message = "* An error occurred: Please try again.";
      }
    });

    return message;
  }
}
