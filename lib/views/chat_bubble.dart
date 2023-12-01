import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({Key? key, required this.message, required this.isUser})
      : super(key: key);

  final Radius radius = const Radius.circular(20);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF000026) : Colors.grey,
          borderRadius: BorderRadius.only(
            topRight: isUser ? Radius.zero : radius,
            topLeft: isUser ? radius : Radius.zero,
            bottomLeft: radius,
            bottomRight: radius,
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}