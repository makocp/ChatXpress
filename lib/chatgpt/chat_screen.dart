import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  List<Messages> messages = [];

  final openAI = OpenAI.instance.build(token: "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",baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),enableLog: true);
  StreamSubscription? _subscription;

  void completeWithSSE(String prompt) async {
      messages.add(Messages(
        role: Role.user, // Replace with the appropriate role value from the enum
        content: prompt,
      ));

      final request = ChatCompleteText(messages: messages, maxToken: 200, model: GptTurboChatModel());
      final response = await openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        _messages.add(ChatMessage(text:element.message!.content.toString(), sender: "ChatGpt"));
        print("data -> ${element.message?.content}");
      }
      setState(() {});
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: controller.text, sender: "user");
    setState(() {
       completeWithSSE(controller.text);
      _messages.add(message);
      controller.clear();

    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TestScreen"),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: ChatMessage(text: _messages[index].text, sender: _messages[index].sender),
                      ),
                    );
                  })),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: _buildTextComposer(_sendMessage,controller),
          )
        ],
      ),
    );
  }
}


Widget _buildTextComposer(Function sendMessage,TextEditingController textEditingController) {

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            decoration:
                InputDecoration(isCollapsed: true, hintText: "Send a message"),
          ),
        ),
        IconButton(onPressed: () {
          sendMessage();
        }, icon: Icon(Icons.send))
      ],
    ),
  );
}



class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(child: Text(sender[0])),
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: Theme.of(context).textTheme.subtitle1),
                Container(margin: const EdgeInsets.only(top: 5.0))
              ],
            ))
      ],
    );
  }
}