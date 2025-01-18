import 'package:dio/dio.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/utils/app_constants.dart';

class CommentRepository {
  final DioClient dioClient;

  CommentRepository({required this.dioClient});

  Future<Response> getComments(int postId, {int? page}) async {
    return await dioClient
        .getData("${AppConstants.comments}/$postId/all?page=$page");
  }

  Future<Response> getReplies(int commentId, {int? page}) async {
    return await dioClient
        .getData("${AppConstants.comments}/$commentId/replies?page=$page");
  }

  Future<Response> createCommentOrReply(
      Map<String, String> body, List<MultipartBody> multipartBody) async {
    return await dioClient.postMultipartData(
      uri: "comments/",
      fields: body,
      files: multipartBody,
    );
  }

  Future<Response> deleteComment(int commentId) async {
    return await dioClient.deleteData("${AppConstants.comments}/$commentId");
  }
}
