import 'package:chatXpress/models/message.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import '../../components/chat_components/chat_message_view.dart';
import 'package:chatXpress/components/chat_components/text_field.dart';
import 'package:chatXpress/views/menu/menu_view.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:chatXpress/assets/colors/my_colors.dart';

class ChatView extends StatelessWidget with GetItMixin {
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatViewmodel = serviceContainer<ChatViewmodel>();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MessageViewModel> messages =
        watchOnly((ChatViewmodel m) => m.messages);
    final bool requestWaiting =
        watchOnly((ChatViewmodel m) => m.requestWaiting);

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
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: index > 0
                          ? ChatMessageView(
                              message: messages[index - 1],
                            )
                          : requestWaiting
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
    _chatViewmodel.sendMessage(prompt);
  }

  void _handleSendMessage() async {
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
