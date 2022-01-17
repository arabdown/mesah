abstract class MessageEvent {}

class OnMessage extends MessageEvent {
  final String message;
  OnMessage({required this.message});
}
