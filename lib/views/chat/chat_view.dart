import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import '../../components/chat_components/chat_message_view.dart';
import 'package:chatXpress/components/chat_components/custom_text_input.dart';
import 'package:chatXpress/views/menu/menu_view.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:chatXpress/assets/colors/my_colors.dart';

// ignore: must_be_immutable
class ChatView extends StatelessWidget with GetItMixin {
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatViewmodel = serviceContainer<ChatViewmodel>();
  late List<ChatMessage> uiMessages;
  late double lastMessageOpacity;

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool requestWaiting =
        watchOnly((ChatViewmodel m) => m.requestWaiting);
    return Scaffold(
      backgroundColor: MyColors.greyChatBackground,
      appBar: AppBar(
        backgroundColor: MyColors.greenDefaultColor,
        title: const Text(MyStrings.appName),
      ),
      drawer: MenuView(),
      onDrawerChanged: (isOpened) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Expanded(child: _buildMessagesList(requestWaiting)),
              _buildInputRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(bool requestWaiting) {
    return StreamBuilder<List<MessageModel>>(
      stream: _chatViewmodel.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          uiMessages =
              snapshot.data!.map((e) => ChatMessage(message: e)).toList();
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            controller: _scrollController,
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: index > 0
                  ? index == 1
                      ? uiMessages[index - 1]
                      : uiMessages[index - 1]
                  : requestWaiting
                      ? _showProgressIndicator()
                      : const SizedBox(height: 0),
            ),
          );
        } else {
          return Center(child: _showProgressIndicator());
        }
      },
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextInput(hintText: MyStrings.inputSendMessage, controller: _controller),
          IconButton(
            onPressed: () => _handleSendMessage(),
            icon: const Icon(Icons.send),
            color: MyColors.greenDefaultColor,
          ),
        ],
      ),
    );
  }

  Widget _showProgressIndicator() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(),
        ),
      ],
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
      _scrollToBottom();
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
