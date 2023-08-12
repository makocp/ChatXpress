import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/drawer_components/my_drawer.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../components/chat_components/chat_message.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final chatViewmodel = ChatViewmodel();


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
                  reverse: true,
                  controller: _scrollController,
                  itemCount: chatViewmodel.messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChatMessage(
                        text: chatViewmodel.messages[index].text,
                        sender: chatViewmodel.messages[index].sender,
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

  void _sendMessage(String prompt) async {
    chatViewmodel.sendMessage(prompt, () => setState(() {
      _scrollToBottom();
    }));
  }

  void _handleSendMessage() {
    String prompt = _controller.text.trim();
    if (prompt.isNotEmpty) {
      _sendMessage(prompt);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.initialScrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
