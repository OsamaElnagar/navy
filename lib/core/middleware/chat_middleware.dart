import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/chat/controller/chat_room_controller.dart';

class ChatMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Add any authentication or other checks if needed
    return null;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    // Initialize any required controllers or services
    return page;
  }

  @override
  void onPageDispose() {
    // Clean up when leaving chat room
    if (Get.isRegistered<ChatRoomController>()) {
      Get.delete<ChatRoomController>();
    }
  }
}
