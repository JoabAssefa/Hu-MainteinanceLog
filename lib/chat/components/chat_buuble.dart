import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color bubbleColor;
  final bool isSender;
  const ChatBubble({super.key, required this.message,required this.bubbleColor,required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: isSender
            ? BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
        color: bubbleColor,
        
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
