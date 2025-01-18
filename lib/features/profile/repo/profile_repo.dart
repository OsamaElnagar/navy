import 'package:dio/dio.dart';
import 'package:navy/services/dio_client.dart';

import '../../authentication/service/user_hive_service.dart';

class ProfileRepository {
  final DioClient dioClient;

  final UserHiveService userHiveService;

  ProfileRepository({
    required this.dioClient,
    required this.userHiveService,
  });

  Future<Response> getProfile({int? page}) async {
    return await dioClient.getData(
      "user?page=$page",
    );
  }

  Future<Response> visitProfile({required int id, int? page}) async {
    return await dioClient.getData(
      "visit/$id?page=$page",
    );
  }

  Future<Response> updateProfile({
    required Map<String, String> fields,
    List<MultipartBody>? files,
  }) async {
    return await dioClient.putMultipartData(
      uri: "user",
      fields: fields,
      files: files,
    );
  }

  Future<Response> getTrashedPosts(int? page) async {
    return await dioClient.getData('posts/trashed?page=$page');
  }

  Future<Response> restorePost(int postId) async {
    return await dioClient.putData(
      'posts/restore/$postId',
      {}, // Empty data object for PUT request
    );
  }

  Future<Response> forceDeletePost(int postId) async {
    return await dioClient.deleteData(
      'posts/force-delete/$postId',
    );
  }
}
