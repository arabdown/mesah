abstract class MessageState {}

class MessageInit extends MessageState {}

class MessageShow extends MessageState {
  final String text;
  MessageShow({required this.text});
}
