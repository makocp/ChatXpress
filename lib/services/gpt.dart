import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class Gpt{
  final openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
    enableLog: true,
  );
}