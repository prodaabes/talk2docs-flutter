class Message {
  final String id;
  final String chatId;
  final bool isQuestion;
  final String content;

  const Message({required this.id, required this.chatId, required this.isQuestion, required this.content});
}
