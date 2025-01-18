import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/chat/model/chat_model.dart';
import 'package:navy/features/chat/repo/chat_repository.dart';
import 'package:pretty_logger/pretty_logger.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;
  int totalUnreadCount = 0;

  ChatController({required this.chatRepository});

  final PagingController<int, Chat> chatsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, Message> messagesPagingController =
      PagingController(firstPageKey: 1);

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    chatsPagingController.addPageRequestListener((pageKey) {
      getChats(pageKey, false);
    });
  }

  Future<void> getChats(int page, bool reload) async {
    try {
      final response = await chatRepository.getChats(page: page);
      if (response.statusCode == 200) {
        final content = response.data['content'] as List;
        final pagination = response.data['pagination'];
        final currentPage = pagination['current_page'];
        final lastPage = pagination['last_page'];

        final isLastPage = currentPage >= lastPage;
        final List<Chat> newChats =
            content.map((json) => Chat.fromJson(json)).toList();

        if (isLastPage) {
          chatsPagingController.appendLastPage(newChats);
        } else {
          chatsPagingController.appendPage(newChats, page + 1);
        }
      } else {
        chatsPagingController.error = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      chatsPagingController.error = e;
      printLog('Error fetching chats: $e');
    }
  }

  /// pass [private] as type with [id] as one participant
  /// to create a one-to-one chat.
  /// Or a [group] with [id1,id2,...] for a group chat with a name to it.
  Future<void> createChat({
    required String type,
    required List<int> participants,
    String? groupname,
    required Map<String, String> args,
  }) async {
    try {
      setLoading(true);
      Map<String, dynamic> body = {
        "type": type,
        "participants": participants,
        if (groupname != null) "name": groupname,
      };

      Response response = await chatRepository.createChat(body);

      if (response.statusCode == 200) {
        // Extract the chat ID from the response
        final chatId = response.data['content']['id'];

        // Close the friends list sheet
        Get.back();

        // Refresh the chats list
        chatsPagingController.refresh();

        // Navigate to the chat room
        Get.toNamed(
            RouteHelper.getChatRoomRoute(
              chatId: chatId,
              fromNotification: false,
            ),
            arguments: {
              'chatId': chatId,
              "name": args['name'],
              "avatar": args['avatar']
            });
      } else {
        customSnackBar(
          'Failed to create chat',
          position: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      printLog('Error creating chat: $e');
      customSnackBar(
        'Something went wrong',
        position: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  @override
  void onClose() {
    chatsPagingController.dispose();
    messagesPagingController.dispose();
    super.onClose();
  }

  void updateUnreadCount(int count) {
    totalUnreadCount = count;
    update();
  }

  Future<void> refreshUnreadCounts() async {
    try {
      final response = await chatRepository.getTotalUnreadCount();
      if (response.statusCode == 200) {
        final count = response.data['content']['count'] as int;
        updateUnreadCount(count);
      }
    } catch (e) {
      printLog('Error refreshing unread counts: $e');
    }
  }

  void handleNewMessage(Map<String, dynamic> messageData) {
    PLog.green('handleNewMessage Called');
    try {
      final chatId = messageData['chat_id'] as int;
      final index = chatsPagingController.itemList?.indexWhere(
        (chat) => chat.id == chatId,
      );

      if (index != null && index != -1) {
        final chat = chatsPagingController.itemList![index];
        final updatedChat = Chat(
          id: chat.id,
          type: chat.type,
          name: chat.name,
          avatar: chat.avatar,
          participants: chat.participants,
          createdAt: chat.createdAt,
          updatedAt: DateTime.now().toString(),
          unreadCount: chat.unreadCount + 1,
          lastMessage: messageData['content'],
          lastMessageAt: DateTime.now().toString(),
          lastSenderId: chat.lastSenderId,
        );

        // Remove and reinsert at top
        chatsPagingController.itemList!
          ..removeAt(index)
          ..insert(0, updatedChat);

        totalUnreadCount++;
        update();
      }
    } catch (e) {
      printLog('Error handling new message: $e');
    }
  }

  void handleSentMessage({
    required int chatId,
    required String content,
    required Map<String, dynamic> messageData,
  }) {
    PLog.green('handleSentMessage Called.');
    updateUnreadCount(0);
    try {
      final index = chatsPagingController.itemList?.indexWhere(
        (chat) => chat.id == chatId,
      );

      if (index != null && index != -1) {
        final chat = chatsPagingController.itemList![index];
        final updatedChat = Chat(
          id: chat.id,
          type: chat.type,
          name: chat.name,
          avatar: chat.avatar,
          participants: chat.participants,
          createdAt: chat.createdAt,
          updatedAt: DateTime.now().toString(),
          unreadCount: chat.unreadCount,
          lastMessage: "You: $content",
          lastMessageAt: DateTime.now().toString(),
          lastSenderId: chat.lastSenderId,
        );

        // Remove and reinsert at top
        chatsPagingController.itemList!
          ..removeAt(index)
          ..insert(0, updatedChat);

        update();
        return;
      }
    } catch (e) {
      printLog('Error handling sent message: $e');
    }
  }
}
