import 'dart:convert';
import 'package:get/get.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/chat/controller/chat_room_controller.dart';
import 'package:navy/features/notifications/handlers/notification_handler.dart';
import 'package:pretty_logger/pretty_logger.dart';

import '../../chat/controller/chat_controller.dart';

class ChatNotificationHandler implements NotificationHandler {
  static const _messageType = 'new_message';

  @override
  bool canHandle(String type) => type == _messageType;

  int _getChatId(Map<String, dynamic> payload) {
    final messageData = jsonDecode(payload['message'] as String);
    return messageData['chat_id'] as int;
  }

  @override
  String getRelevantRoute(Map<String, dynamic> payload) {
    final chatId = _getChatId(payload);
    return RouteHelper.getChatRoomRoute(chatId: chatId, fromNotification: true);
  }

  @override
  void handleNotification(Map<String, dynamic> payload,
      {bool requireNavigation = true}) {
    try {
      final messageData = jsonDecode(payload['message'] as String);
      final chatId = messageData['chat_id'] as int;

      // Check if user is in chat room
      final currentRoute = Get.currentRoute;
      final bool isInChatRoom = currentRoute.startsWith(RouteHelper.chatRoom);

      if (isInChatRoom && Get.isRegistered<ChatRoomController>()) {
        final controller = Get.find<ChatRoomController>();

        // If in the same chat room, just add message
        if (controller.chatId == chatId) {
          controller.handleNewMessage(messageData);
          return;
        }
      }

      // Update chat list if not in the same chat
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().handleNewMessage(messageData);
      }

      // Handle navigation if required
      if (requireNavigation) {
        Get.toNamed(
          RouteHelper.getChatRoomRoute(chatId: chatId, fromNotification: true),
          arguments: {
            'chatId': chatId,
            'name': messageData['sender']['name'],
            'avatar': messageData['sender']['avatar'],
          },
        );
      }
    } catch (e) {
      PLog.red("Error handling chat notification: $e");
    }
  }
}
