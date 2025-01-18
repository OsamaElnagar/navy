import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/chat/controller/chat_controller.dart';
import 'package:navy/features/chat/repo/chat_repository.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../services/dio_client.dart';

class ChatRoomController extends GetxController {
  final ChatRepository repo;

  ChatRoomController({required this.repo});

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxMap<int, MessageStatus> messageStatuses = <int, MessageStatus>{}.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int currentPage = 1;
  bool hasMoreMessages = true;
  bool isLoading = false;
  late int chatId;

  // Add observable for selected media preview

  // Add selected media state
  Rx<XFile?> selectedMedia = Rx<XFile?>(null);
  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  Rx<String> selectedMediaType = Rx<String>('text');

  void initializeChat(int id) {
    chatId = id;
    Get.find<ChatController>().totalUnreadCount = 0;
    getChatMessages(chatId);
  }

  void handleNewMessage(Map<String, dynamic> messageData) {
    try {
      PLog.cyan("Handling new message in chat room");
      final newMessage = _convertToMessage(messageData);
      _audioPlayer.play(AssetSource('sound/chat-room-notification.wav'));
      _insertMessage(newMessage);
    } catch (e) {
      PLog.red("Error handling new message: $e");
    }
  }

  ChatMessage _convertToMessage(Map<String, dynamic> json) {
    final media = json['media'] as List?;

    return ChatMessage(
      user: ChatUser(
        id: json['sender']['id'].toString(),
        firstName: json['sender']['name'],
      ),
      text: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      medias: media
          ?.map<ChatMedia>((url) => ChatMedia(
                url: url,
                fileName: url.split('/').last,
                type: MediaType.parse(json['type']),
              ))
          .toList(),
      status: MessageStatus.received,
      customProperties: {
        'id': json['id'],
        'reactions': json['reactions'] ?? [],
        'self_reaction': json['self_reaction'],
      },
    );
  }

  void _insertMessage(ChatMessage message) {
    PLog.cyan("Inserting new message");
    messages.insert(0, message);
    update(['messages']);
  }

  Future<void> sendMessage(int chatId, String content) async {
    printLog('Sending message: $content');

    if (content.trim().isEmpty && selectedMedia.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;
    final tempMessage = ChatMessage(
      user: ChatUser(
        id: Get.find<UserHiveService>().getUser()!.user.id.toString(),
      ),
      text: content,
      createdAt: DateTime.now(),
      status: MessageStatus.pending,
      medias: selectedMedia.value != null
          ? [
              ChatMedia(
                url: selectedMedia.value!.path,
                type: _getMediaType(selectedMedia.value, selectedFile.value),
                fileName:
                    selectedMedia.value?.name ?? selectedFile.value?.name ?? '',
              ),
            ]
          : null,
      customProperties: {'id': tempId},
    );

    _insertMessage(tempMessage);

    try {
      // Prepare request data
      final fields = {
        'content': content,
        'type': selectedMedia.value != null
            ? _getMessageType(selectedMedia.value, selectedFile.value)
            : 'text',
      };

      // Prepare media file if exists
      List<MultipartBody>? files;
      if (selectedMedia.value != null) {
        files = [MultipartBody('media', selectedMedia.value!)];
      }

      final response = await repo.sendMessage(
        chatId: chatId,
        fields: fields,
        files: files,
      );

      PLog.cyan('Send message status code is: ${response.statusCode} ');
      if (response.statusCode == 200) {
        final newMessage = _convertToMessage(response.data['content']);
        final index =
            messages.indexWhere((m) => m.customProperties?['id'] == tempId);

        if (index != -1) {
          messages[index] = newMessage;
          update(['messages']);
        }
        _audioPlayer.play(AssetSource('sound/notification-1.mp3'));

        final messageData = response.data['content'];
        Get.find<ChatController>().handleSentMessage(
          chatId: chatId,
          content: content,
          messageData: messageData,
        );

        // Clear selected media after successful send
        selectedMedia.value = null;
        selectedFile.value = null;
        selectedMediaType.value = 'text';
      }
    } catch (e) {
      final index =
          messages.indexWhere((m) => m.customProperties?['id'] == tempId);

      if (index != -1) {
        messages[index] = ChatMessage(
          user: messages[index].user,
          text: messages[index].text,
          createdAt: messages[index].createdAt,
          status: MessageStatus.failed,
          customProperties: messages[index].customProperties,
          medias: messages[index].medias,
        );
        update(['messages']);
      }
      PLog.red("Error sending message: $e");
    }
  }

  Future<void> getChatMessages(int chatId, {bool loadMore = false}) async {
    if (!hasMoreMessages && loadMore) return;
    if (isLoading) return;

    isLoading = true;
    try {
      final page = loadMore ? currentPage + 1 : 1;
      final response = await repo.getChatMessages(chatId, page: page);

      if (response.statusCode == 200) {
        final List<ChatMessage> newMessages = (response.data['content'] as List)
            .map((json) => _convertToMessage(json))
            .toList();

        PLog.cyan('New messages length: ${newMessages.length}');

        if (loadMore) {
          messages.addAll(newMessages);
          currentPage = page;
        } else {
          messages.value = newMessages;
          currentPage = 1;
        }

        hasMoreMessages = newMessages.isNotEmpty;
        update(['messages']);
      }
    } catch (e) {
      printLog(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  void onClose() {
    messages.clear();
    messageStatuses.clear();
    super.onClose();
  }

  Future<void> updateLastReadAt(int chatId) async {
    try {
      await repo.updateLastReadAt(chatId);
      await Get.find<ChatController>().refreshUnreadCounts();
    } catch (e) {
      PLog.red("Error updating last read: $e");
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  final FilePicker _filePicker = FilePicker.platform;

  Future<void> sendMediaMessage(
    int chatId, {
    XFile? imageFile,
    PlatformFile? file,
    String? messageText,
  }) async {
    try {
      // Create temporary message
      final tempId = DateTime.now().millisecondsSinceEpoch;
      final tempMessage = ChatMessage(
        user: ChatUser(
          id: Get.find<UserHiveService>().getUser()!.user.id.toString(),
        ),
        text: messageText ?? '',
        createdAt: DateTime.now(),
        status: MessageStatus.pending,
        medias: file != null || imageFile != null
            ? [
                ChatMedia(
                  url: imageFile?.path ?? file?.path ?? '',
                  type: _getMediaType(imageFile, file),
                  fileName: imageFile?.name ?? file?.name ?? '',
                ),
              ]
            : null,
        customProperties: {'id': tempId},
      );

      _insertMessage(tempMessage);

      // Prepare request data
      final fields = {
        'content': messageText ?? '',
        'type': _getMessageType(imageFile, file),
      };

      List<MultipartBody>? files;
      List<PlatformFile>? otherFiles;

      if (imageFile != null) {
        files = [MultipartBody('media', imageFile)];
      } else if (file != null) {
        otherFiles = [file];
      }

      final response = await repo.sendMessage(
        chatId: chatId,
        fields: fields,
        files: files,
        otherFiles: otherFiles,
      );

      if (response.statusCode == 200) {
        final newMessage = _convertToMessage(response.data['content']);
        final index =
            messages.indexWhere((m) => m.customProperties?['id'] == tempId);

        if (index != -1) {
          messages[index] = newMessage;
          update(['messages']);
        }
        _audioPlayer.play(AssetSource('sound/notification-1.mp3'));
      }
    } catch (e) {
      PLog.red("Error sending media message: $e");
      // Handle error state for temp message
    }
  }

  MediaType _getMediaType(XFile? imageFile, PlatformFile? file) {
    if (imageFile != null) return MediaType.image;
    if (file != null) {
      final mimeType = file.name.split('.').last.toLowerCase();
      switch (mimeType) {
        case 'mp4':
        case 'mov':
          return MediaType.video;
        // case 'mp3':
        // case 'wav':
        //   return MediaType.image;
        default:
          return MediaType.file;
      }
    }
    return MediaType.image;
  }

  String _getMessageType(XFile? imageFile, PlatformFile? file) {
    if (imageFile != null) return 'image';
    if (file != null) {
      final mimeType = file.name.split('.').last.toLowerCase();
      switch (mimeType) {
        case 'mp4':
        case 'mov':
          return 'video';
        case 'mp3':
        case 'wav':
          return 'audio';
        default:
          return 'file';
      }
    }
    return 'text';
  }

  XFile? pickedImage;
  PlatformFile? pickedFile;

  Future<void> pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedMedia.value = image;
      selectedMediaType.value = 'image';
      // Create a temporary ChatMessage with the image preview
      final message = ChatMessage(
        medias: [
          ChatMedia(
            url: image.path,
            type: MediaType.image,
            fileName: image.name,
          ),
        ],
        text: '', // Empty text for preview
        user: ChatUser(id: '1'), // You'll need to pass this from your chat page
        createdAt: DateTime.now(),
        status: MessageStatus.pending,
      );
      messages.insert(0, message);
      update(['messages']); // Update the chat UI
    }
  }

  Future<void> pickFile() async {
    final result = await _filePicker.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = XFile(result.files.first.path!);
      selectedMedia.value = file;
      selectedMediaType.value = 'file';
      // Create a temporary ChatMessage with the file preview
      final message = ChatMessage(
        medias: [
          ChatMedia(
            url: file.path,
            type: MediaType.file,
            fileName: result.files.first.name,
          ),
        ],
        text: '', // Empty text for preview
        status: MessageStatus.pending,
        user: ChatUser(id: "id"),
        createdAt: DateTime.now(),
      );
      messages.insert(0, message);
      update(['messages']);
    }
  }

  void clearSelectedMedia() {
    selectedMedia.value = null;
    update();
  }

  void clearSelectedFile() {
    selectedFile.value = null;
    update();
  }

  void clearSelectedMediaType() {
    selectedMediaType.value = 'text';
    update();
  }
}
