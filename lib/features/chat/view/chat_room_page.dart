import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/chat/controller/chat_room_controller.dart';

import '../../authentication/model/user_response.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late ChatRoomController roomController;
  final int chatId = Get.arguments['chatId'];
  final String name = Get.arguments['name'];
  final String avatar = Get.arguments['avatar'];

  @override
  void initState() {
    super.initState();
    roomController = Get.find()
      ..initializeChat(chatId)
      ..updateLastReadAt(chatId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatRoomController>(
      id: 'messages',
      builder: (controller) {
        final User currentUser = Get.find<UserHiveService>().getUser()!.user;
        final ChatUser chatUser = ChatUser(
          id: currentUser.id.toString(),
          firstName: currentUser.name,
          profileImage: currentUser.avatar,
          customProperties: {
            'phone': currentUser.phone,
            'bio': currentUser.bio,
            'website': currentUser.website,
          },
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(name),
            leadingWidth: 110,
            leading: Row(
              spacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                CustomAvatar(path: avatar),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
              ),
            ],
          ),
          body: DashChat(
            currentUser: chatUser,
            messages: controller.messages,
            onSend: (ChatMessage message) {
              controller.sendMessage(chatId, message.text);
            },
            messageOptions: const MessageOptions(
              showTime: true,
              showCurrentUserAvatar: false,
              showOtherUsersAvatar: false,
              containerColor: Colors.blue,
              textColor: Colors.white,
              showOtherUsersName: true,
            ),
            messageListOptions: MessageListOptions(
              onLoadEarlier: () async {
                // Load more messages if needed
                await controller.getChatMessages(chatId, loadMore: true);
              },
            ),
            inputOptions: InputOptions(
              sendOnEnter: false,
              alwaysShowSend: true,
              leading: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _showAttachmentOptions(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Image'),
            onTap: () {
              Get.back();
              Get.find<ChatRoomController>().pickImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text('File'),
            onTap: () {
              Get.back();
              Get.find<ChatRoomController>().pickFile();
            },
          ),
        ],
      ),
    );
  }

  // BoxDecoration _messageDecorationBuilder(Color color, bool isUser) {
  //   return BoxDecoration(
  //     color: color,
  //     borderRadius: BorderRadius.circular(8),
  //   );
  // }
}
