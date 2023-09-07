import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/snackbars/snackbars.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:flutter/material.dart';

class PromptButton extends StatelessWidget {
  PromptButton({super.key, required this.messageSuggestion});

  final String messageSuggestion;
  final chatViewModel = serviceContainer<ChatViewmodel>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 17, right: 17),
      child: OutlinedButton(
        onPressed: () => chatViewModel.isLoading
            ? MySnackBars.showSnackBar(context, MySnackBars.ongoingRequest)
            : chatViewModel.sendMessage(messageSuggestion),
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
          textAlign: TextAlign.center,
        ),
      ),
    ); // runs after the above w/new duration
  }
}
