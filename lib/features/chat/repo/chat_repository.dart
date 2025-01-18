import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/utils/app_constants.dart';

class ChatRepository {
  final DioClient dioClient;

  ChatRepository({required this.dioClient});

  Future<Response> getChats({int? page}) async {
    return await dioClient.getData(
      "${AppConstants.chats}?page=$page",
    );
  }

  Future<Response> getChat(int chatId) async {
    return await dioClient.getData("${AppConstants.chats}/$chatId");
  }

  Future<Response> getChatMessages(int chatId, {int? page}) async {
    return await dioClient.getData(
      "${AppConstants.chats}/$chatId/messages?page=$page",
    );
  }

  Future<Response> createChat(Map<String, dynamic> body) async {
    return await dioClient.postData(AppConstants.chats, body);
  }

  Future<Response> sendMessage({
    required int chatId,
    required Map<String, String> fields,
    List<MultipartBody>? files,
    List<PlatformFile>? otherFiles,
  }) async {
    return await dioClient.postMultipartDataConversation(
      "${AppConstants.chats}/$chatId/messages",
      fields,
      files,
      otherFiles: otherFiles,
    );
  }

  Future<Response> deleteMessage(int chatId, int messageId) async {
    return await dioClient.deleteData(
      "${AppConstants.chats}/$chatId/messages/$messageId",
    );
  }

  Future<Response> toggleReaction(
    int chatId,
    int messageId,
    String reaction,
  ) async {
    return await dioClient.postData(
      "${AppConstants.chats}/$chatId/messages/$messageId/reactions",
      {'reaction': reaction},
    );
  }

  Future<Response> updateLastReadAt(int chatId) async {
    return await dioClient.postData(
      "${AppConstants.chats}/$chatId/read",
      {},
    );
  }

  Future<Response> getTotalUnreadCount() async {
    return await dioClient.getData("${AppConstants.chats}/unread-count");
  }
}
