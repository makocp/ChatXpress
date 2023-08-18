import 'package:chatXpress/enum/message_type.dart';
import 'package:chatXpress/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chatXpress/assets/colors/my_colors.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({Key? key, required this.message}) : super(key: key);
  final MessageViewModel message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: message.sender == "ChatGpt"
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        ..._buildMessageWidgets(message),
      ],
    );
  }

  List<Widget> _buildMessageWidgets(MessageViewModel message) {
    final isChatGpt = message.sender == "ChatGpt";

    return [
      if (isChatGpt) _buildAvatar(message.sender),
      const SizedBox(
        width: 5,
      ),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isChatGpt ? MyColors.greenDefaultColor : Colors.white,
            borderRadius: message.sender == "ChatGpt"
                ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12))
                : const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
          ),
          child: Text(
            message.content,
            style: TextStyle(
                color: getTextColor(message.messageType)),
          ),
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      if (!isChatGpt) _buildAvatar(message.sender),
    ];
  }

  Widget _buildAvatar(String sender) {
    if (sender == "ChatGpt") {
      return const CircleAvatar(
        backgroundImage: ExactAssetImage('assets/images/chatXpress.png'),
        radius: 15,
        backgroundColor: MyColors.greenDefaultColorDark,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 15,
        child: Text(
          sender[0],
          style: const TextStyle(color: Colors.black),
        ),
      );
    }
  }

  Color getTextColor(MessageType messageType) {
    switch (messageType) {
      case MessageType.error:
        return MyColors.redForDeleteButton;
      case MessageType.request:
        return Colors.black;
      case MessageType.response:
        return Colors.white;
      default:
        return Colors.red;
    }
  }
}