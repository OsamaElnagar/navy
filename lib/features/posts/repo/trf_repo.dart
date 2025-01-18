import 'package:dio/dio.dart';
import 'package:navy/services/dio_client.dart';

class TrfRepo {
  final DioClient dioClient;

  TrfRepo({required this.dioClient});

  Future<Response> getTrashed() async {
    return await dioClient.getData(
      '/posts/trashed',
    );
  }

  Future<Response> restorePost(int postId) async {
    return await dioClient.postData(
      '/posts/restore/$postId',
      {},
    );
  }

  Future<Response> forceDeletePost(int postId) async {
    return await dioClient.postData(
      '/posts/force-delete/$postId',
      {},
    );
  }
}
