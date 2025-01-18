import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:navy/features/chat/controller/chat_controller.dart';
import 'package:navy/features/profile/widgets/friends_paged_list.dart';
import 'package:navy/features/profile/controller/friends_controller.dart';
import 'package:navy/features/profile/service/friendship_service.dart';
import 'package:navy/features/profile/repo/profile_repo.dart';

class FriendsListSheet {
  static Future<void> show(BuildContext context) {
    // Initialize FriendsController if not already initialized
    if (!Get.isRegistered<FriendsController>()) {
      Get.put(FriendsController(
        friendshipService: Get.find<FriendshipService>(),
        repo: Get.find<ProfileRepository>(),
      ));
    }

    return WoltModalSheet.show<void>(
      context: context,
      showDragHandle: true,
      pageListBuilder: (modalContext) => [
        WoltModalSheetPage(
          hasSabGradient: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          topBarTitle: const Text('Select Friend'),
          trailingNavBarWidget: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          child: FriendsPagedList(
            padding: const EdgeInsets.symmetric(vertical: 8),
            onFriendTap: (friend) async {
              final chatController = Get.find<ChatController>();
              await chatController.createChat(type: 'private', participants: [
                friend.id
              ], args: {
                'name': friend.name,
                'avatar': friend.avatar ?? "",
              });
            },
          ),
        ),
      ],
      modalTypeBuilder: (context) {
        final width = MediaQuery.of(context).size.width;
        if (width < 600) {
          return WoltModalType.bottomSheet();
        } else {
          return WoltModalType.sideSheet();
        }
      },
    );
  }
}
