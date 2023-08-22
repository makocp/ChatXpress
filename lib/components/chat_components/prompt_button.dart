import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PromptButton extends StatelessWidget {
  const PromptButton(
      {super.key, required this.sendMessage, required this.messageSuggestion});

  final void Function(String) sendMessage;
  final String messageSuggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: OutlinedButton(
        onPressed: () => sendMessage(messageSuggestion),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(300, 50)),
          maximumSize: MaterialStateProperty.all(const Size(300, 50)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(const BorderSide(
              color: MyColors.greenDefaultColorDark,
              width: 1.0,
              style: BorderStyle.solid)),
        ),
        child: Text(
          messageSuggestion,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ); // runs after the above w/new duration
  }
}
