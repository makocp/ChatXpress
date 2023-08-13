import 'package:flutter/material.dart';
import 'package:chatXpress/assets/colors/my_colors.dart';

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
        ..._buildMessageWidgets(sender, text),
      ],
    );
  }

  List<Widget> _buildMessageWidgets(String sender, String text) {
    final isChatGpt = sender == "ChatGpt";

    return [
      if (isChatGpt) _buildAvatar(sender),
      const SizedBox(
        width: 5,
      ),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isChatGpt ? MyColors.greenDefaultColor : Colors.white,
            borderRadius: sender == "ChatGpt"
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
            text,
            style: TextStyle(
                color: sender == "ChatGpt" ? Colors.white : Colors.black),
          ),
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      if (!isChatGpt) _buildAvatar(sender),
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
}
