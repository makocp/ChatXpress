import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/components/chat_components/text_field.dart';
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
  final _chatViewmodel = ChatViewmodel();

  @override
  Widget build(BuildContext context) {
    // to unfocus the ChatView, to dismiss the keyboard, after opening the drawer.
    // See readme reference for more details.
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff40414f),
        appBar: AppBar(
          backgroundColor: MyColors.greenDefaultColor,
          title: const Text("ChatXpress"),
        ),
        drawer: const MyDrawer(),
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
                            ? ChatMessage(
                                text: _chatViewmodel.messages[index - 1].text,
                                sender:
                                    _chatViewmodel.messages[index - 1].sender,
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
                            hintText: "Send a message",
                            controller: _controller),
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
