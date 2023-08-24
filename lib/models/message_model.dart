import 'package:chatXpress/enum/message_type.dart';

class MessageModel {
  final String chatId;
  final String content;
  final DateTime date;
  final String sender;
  final MessageType messageType;

  MessageModel({
    required this.chatId,
    required this.content,
    required this.date,
    required this.sender,
    required this.messageType,
  });

  Map<String, dynamic> mapToDB() {
    return {
      'chatId' : chatId,
      'content': content,
      'date': date,
      'sender': sender,
      'type': messageType.name
    };
  }
}
