import 'package:chatXpress/components/ChatCard.dart';
import 'package:flutter/material.dart';
import 'package:chatXpress/models/Chat.dart';
import 'package:chatXpress/models/Message.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Chat> chats;
  var m1 = Message(
      content: "Message 1", timestamp: DateTime.now(), isUserMessage: true);
  var m2 = Message(
      content: "Message 1", timestamp: DateTime.now(), isUserMessage: true);
  var m3 = Message(
      content: "Message 1", timestamp: DateTime.now(), isUserMessage: true);

  void fillChat() {
    chats.add(Chat(ChatTitle: "first chat", messages: [m1, m2, m3]));
    chats.add(Chat(ChatTitle: "second chat", messages: [m3, m1, m2]));
    chats.add(Chat(ChatTitle: "third chat", messages: [m2, m3, m1]));
  }

  @override
  void initState() {
    chats = [];
    fillChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
          child: Text(
            "ChatExpress",
            style: TextStyle(fontFamily: "Mulish", fontSize: 20.0),
          ),
        ),
        Expanded(
          child: ListView(
            children: chats
                .map((c) => ChatCard(
                      chat: c,
                      onPressed: () {
                        setState(() {
                          chats.remove(c);
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    ));
  }
}
