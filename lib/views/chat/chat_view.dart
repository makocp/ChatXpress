import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/chat_components/text_field.dart';
import 'package:chatXpress/views/menu/menu_view.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../components/chat_components/chat_message_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatViewmodel = ChatViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff40414f),
      appBar: AppBar(
        backgroundColor: MyColors.greenDefaultColor,
        title: const Text("ChatXpress"),
      ),
      drawer: MenuView(),
      // to unfocus the ChatView, to dismiss the keyboard, after opening the drawer.
      onDrawerChanged: (isOpened) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  reverse: true,
                  controller: _scrollController,
                  itemCount: _chatViewmodel.messages.length + 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: index > 0
                          ? ChatMessageView(
                            message: _chatViewmodel.messages[index - 1],
                            )
                          : _chatViewmodel.requestWaiting
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                    );
                  },
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextInput(
                          hintText: "Send a message", controller: _controller),
                      IconButton(
                        onPressed: () => _handleSendMessage(),
                        icon: const Icon(Icons.send),
                        color: MyColors.greenDefaultColor,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(String prompt) async {
    _chatViewmodel.sendMessage(
        prompt,
        () => setState(() {
              _scrollToBottom();
            }));
  }

  Future<void> _handleSendMessage() async {
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
