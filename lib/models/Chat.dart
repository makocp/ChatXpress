import 'Message.dart';

class Chat {
  List<Message> messages;
  DateTime lastModification;
  String ChatTitle;

  Chat({this.messages = const [], required this.ChatTitle})
      : lastModification =
            (messages.isNotEmpty) ? messages.last.timestamp : DateTime.now();

  void addMessage(Message message) {
    messages.add(message);
    lastModification = DateTime.now();
  }

  void sortMessagesByTimestamp() {
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}
