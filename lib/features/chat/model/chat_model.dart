import 'package:navy/features/posts/model/post_model.dart';

class Chat {
  final int id;
  final String type;
  final String? name;
  final String? avatar;
  final int unreadCount;
  final String updatedAt;
  final String createdAt;
  final String? lastMessage;
  final String? lastMessageAt;
  final int lastSenderId;

  final List<ChatParticipant> participants;

  Chat({
    this.name,
    this.avatar,
    this.lastMessage,
    required this.id,
    this.lastMessageAt,
    required this.type,
    this.unreadCount = 0,
    required this.updatedAt,
    required this.createdAt,
    required this.participants,
    required this.lastSenderId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      avatar: json['avatar'],
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'],
      lastSenderId: json['last_sender_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      unreadCount: json['unread_count'] ?? 0,
      participants: (json['participants'] as List)
          .map((p) => ChatParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Message {
  final int id;
  final int chatId;
  final String? content;
  final String type;
  final List<String>? media;
  final Map<String, dynamic> metadata;
  final String createdAt;
  final String updatedAt;
  final Owner? sender;
  final List<dynamic> reactions;
  final String? selfReaction;

  Message({
    required this.id,
    required this.chatId,
    this.content,
    required this.type,
    required this.media,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    required this.reactions,
    this.selfReaction,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> metadataMap = {};
    if (json['metadata'] != null) {
      if (json['metadata'] is Map) {
        metadataMap = json['metadata'] as Map<String, dynamic>;
      }
    }

    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      content: json['content'],
      type: json['type'],
      media: json['media'],
      metadata: metadataMap,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      sender: json['sender'] != null ? Owner.fromJson(json['sender']) : null,
      reactions: json['reactions'] ?? [],
      selfReaction: json['self_reaction'],
    );
  }
}

class ChatParticipant {
  final int id;
  final String name;
  final String avatar;
  final String role;
  final String? lastReadAt;

  ChatParticipant({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.lastReadAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'],
      lastReadAt: json['last_read_at'],
    );
  }
}
