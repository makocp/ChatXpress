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
    chats.add(Chat(messages: [m1, m2, m3]));
    chats.add(Chat(messages: [m3, m1, m2]));
    chats.add(Chat(messages: [m2, m3, m1]));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Text("Home"),
    );
  }
}
