import 'package:chatXpress/enum/message_type.dart';

class MessageViewModel{
  final String content;
  final DateTime date;
  final String sender;
  final MessageType messageType;

  const MessageViewModel({
    required this.content,
    required this.date,
    required this.sender,
    required this.messageType
  });
}

