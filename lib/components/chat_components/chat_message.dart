import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';

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
