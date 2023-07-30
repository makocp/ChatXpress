import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/models/Chat.dart';

class ChatCard extends StatelessWidget {
   ChatCard({
    Key? key,
    required this.chat,
    required this.onPressed,
  }) : super(key: key);

   Function onPressed;
   Chat chat;

  @override
  Widget build(BuildContext context) {
    final String lastModificationDate =
    DateFormat('dd.MM.yyyy').format(chat.lastModification);

    return InkWell(
      splashColor: MyColors.greenForNavigationBar,
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.ChatTitle,
                      style: const TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      lastModificationDate,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: const Icon(Icons.delete),
                color: MyColors.greenForNavigationBar,
              )
            ],
          ),
        ),
      ),
    );
  }
}
