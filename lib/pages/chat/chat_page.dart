import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/my_drawer.dart';
import 'package:chatXpress/pages/chat/chat_page_model.dart';
import 'package:chatXpress/services_provider/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final chatPageModel = ServiceLocator<ChatPageModel>();
  List<ChatMessage> _messages = [];
  List<Messages> messages = [];

  final openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
    enableLog: true,
  );

  void _sendMessage(String prompt) async {
    _messages = chatPageModel.uiMessages;
    messages = chatPageModel.messages;
    chatPageModel.sendMessage(prompt, () => setState(() {}));
  }

  void _handleSendMessage() {
    String prompt = _controller.text.trim();
    if (prompt.isNotEmpty) {
      _sendMessage(prompt);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChatMessage(
                        text: _messages[index].text,
                        sender: _messages[index].sender,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, -2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Send a message",
              border: InputBorder.none,
            ),
            onSubmitted: (value) => _handleSendMessage(),
          ),
        ),
        IconButton(
          onPressed: () => _handleSendMessage(),
          icon: const Icon(Icons.send),
          color: MyColors.greenDefaultColor,
        )
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sender == "ChatGpt" ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        CircleAvatar(child: Text(sender[0])),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: sender == "ChatGpt"
                  ? MyColors.greenDefaultColor
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}
