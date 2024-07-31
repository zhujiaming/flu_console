class Message {
  String content;
  MessageType messageType;
  DateTime? time;

  Message(
      {required this.content,
      this.messageType = MessageType.normal,
      this.time});
}

enum MessageType {
  normal,
  warn,
  error,
}
