import 'package:chatXpress/assets/snackbars/snackbars.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/models/message_model.dart';
import 'package:chatXpress/components/chat_components/prompt_list.dart';
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
    final bool isLoading = watchOnly((ChatViewmodel vm) => vm.isLoading);
    return Scaffold(
      backgroundColor: MyColors.greyChatBackground,
      appBar: AppBar(
        backgroundColor: MyColors.greenDefaultColor,
        title: const Text(MyStrings.appName),
      ),
      drawer: MenuView(),
      onDrawerChanged: (isOpened) {
        FocusManager.instance.primaryFocus?.unfocus();
        _chatViewmodel.loadCurrentUserchatsFromDB();
      },
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: _buildMessagesList(isLoading),
              ),
              _buildInputRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(bool isLoading) {
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
                  : isLoading
                      ? _showProgressIndicator()
                      : const SizedBox(height: 0),
            ),
          );
        } else {
          return const PromptsList();
        }
      },
    );
  }

  Widget _buildInputRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextInput(
              hintText: MyStrings.inputSendMessage, controller: _controller),
          IconButton(
            onPressed: () => _chatViewmodel.isLoading
                ? MySnackBars.showSnackBar(context, MySnackBars.ongoingRequest)
                : _handleSendMessage(),
            icon: _chatViewmodel.isLoading
                ? Icon(
                    Icons.send,
                    color: Colors.grey[600],
                  )
                : const Icon(Icons.send),
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
