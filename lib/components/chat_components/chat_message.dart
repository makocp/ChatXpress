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
      mainAxisAlignment: sender == "ChatGpt"
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        ..._buildMessageWidgets(sender, text),
      ],
    );
  }

  List<Widget> _buildMessageWidgets(String sender, String text) {
    final isChatGpt = sender == "ChatGpt";

    return [
      if (isChatGpt) _buildAvatar(sender),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isChatGpt
                ? MyColors.greenDefaultColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text),
        ),
      ),
      if (!isChatGpt) _buildAvatar(sender),
    ];
  }

  Widget _buildAvatar(String sender) {
    return CircleAvatar(child: Text(sender[0]));
  }
}
