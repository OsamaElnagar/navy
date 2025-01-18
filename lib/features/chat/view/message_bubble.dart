import 'package:flutter/material.dart';
import 'package:navy/features/chat/model/chat_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isSender;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender) ...[
          CircleAvatar(
            backgroundImage: NetworkImage(message.sender?.avatar ?? ''),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content ?? '',
                style: TextStyle(color: isSender ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                message
                    .createdAt, // Assuming createdAt is a string with the time
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
