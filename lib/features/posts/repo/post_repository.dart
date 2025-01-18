import 'package:dio/dio.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/utils/app_constants.dart';

class PostRepository {
  final DioClient dioClient;

  PostRepository({
    required this.dioClient,
  });

  Future<Response> getPosts({int? page}) async {
    return await dioClient.getData(
      "${AppConstants.posts}?page=$page",
    );
  }

  Future<Response> createPost({
    required Map<String, String> body,
    required List<MultipartBody> multipartBody,
    String? uploadId,
  }) async {
    return await dioClient.postMultipartData(
      uri: AppConstants.posts,
      fields: body,
      files: multipartBody,
      uploadId: uploadId,
    );
  }

  // Future<Response> updatePost(
  //     Map<String, String> body, List<MultipartBody> multipartBody) async {
  //   return await dioClient.putMultipartData(
  //     AppConstants.posts,
  //     body,
  //     [], // Empty list as per original implementation
  //   );
  // }

  Future<Response> deletePost(int id) async {
    return await dioClient.deleteData("${AppConstants.posts}/$id");
  }

  Future<Response> toggleReaction(int postId, String reactionType) async {
    return await dioClient.postData(
      "${AppConstants.reactions}/toggle",
      {
        'post_id': postId.toString(),
        'reaction': reactionType,
      },
    );
  }
}
