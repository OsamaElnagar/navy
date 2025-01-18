import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/chat/controller/chat_controller.dart';
import 'package:navy/features/chat/model/chat_model.dart';
import 'package:navy/features/chat/repo/chat_repository.dart';
import 'package:navy/features/profile/repo/profile_repo.dart';
import 'package:navy/features/profile/service/friendship_service.dart';
import 'package:navy/services/dio_client.dart';

import '../widgets/friends_list_sheet.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key}) {
    // Initialize required controllers and services
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController(
        chatRepository: ChatRepository(dioClient: Get.find()),
      ));
    }

    // Initialize FriendshipService if not already registered
    if (!Get.isRegistered<FriendshipService>()) {
      Get.put<FriendshipService>(
        FriendshipService(Get.find<DioClient>()),
        permanent: true,
      );
    }

    // Initialize ProfileRepository if not already registered
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.put(ProfileRepository(
        dioClient: Get.find(),
        userHiveService: Get.find(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            Get.find<ChatController>().chatsPagingController.refresh(),
        child: GetBuilder<ChatController>(
          builder: (controller) {
            return PagedListView<int, Chat>(
              pagingController: controller.chatsPagingController,
              builderDelegate: PagedChildBuilderDelegate<Chat>(
                itemBuilder: (context, chat, index) => ListTile(
                  selected: true,
                  leading: CustomAvatar(path: chat.avatar),
                  title: Text(
                    chat.type == 'private'
                        ? chat.name ?? 'Private Chat'
                        : chat.name ?? 'Group Chat',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        if (chat.lastSenderId ==
                            Get.find<UserHiveService>().getUser()!.user.id)
                          const TextSpan(
                            text: 'You: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        TextSpan(
                          text: chat.lastMessage ?? 'No messages yet',
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: chat.unreadCount > 0
                      ? Badge.count(
                          count: chat.unreadCount,
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              chat.lastMessageAt ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            chat.lastMessageAt ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.getChatRoomRoute(
                          chatId: chat.id, fromNotification: false),
                      arguments: {
                        'chatId': chat.id,
                        "name": chat.name,
                        "avatar": chat.avatar,
                      },
                    );
                  },
                ),
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text('No chats found')),
                firstPageProgressIndicatorBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FriendsListSheet.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
