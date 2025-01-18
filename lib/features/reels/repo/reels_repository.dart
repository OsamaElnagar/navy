import 'package:dio/dio.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/utils/app_constants.dart';

class ReelsRepository {
  final DioClient dioClient;

  ReelsRepository({required this.dioClient});

  Future<Response> getReels({int? page}) async {
    return await dioClient.getData(
      "${AppConstants.reels}?page=$page",
    );
  }
}
