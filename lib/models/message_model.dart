import 'package:chatXpress/enum/message_type.dart';

class MessageModel{
  final String content;
  final DateTime date;
  final String sender;
  final MessageType messageType;

  const MessageModel({
    required this.content,
    required this.date,
    required this.sender,
    required this.messageType
  });
}

