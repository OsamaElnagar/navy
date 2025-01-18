import 'package:dio/dio.dart';
import '../model/friendship_response.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/core/helpers/log_helper.dart';

abstract class IFriendshipService {
  Future<FriendshipResponse> sendRequest(int friendId);
  Future<FriendshipResponse> cancelRequest(int friendId);
  Future<FriendshipResponse> acceptRequest(int friendId);
  Future<FriendshipResponse> rejectRequest(int friendId);
  Future<FriendshipResponse> unfriend(int friendId);
  Future<FriendshipResponse> getFriendshipStatus(int userId);

  /// pas the id of the user to load his friends.
  Future<Response> getFriendsList(int userId);
}

class FriendshipService implements IFriendshipService {
  final DioClient _dioClient;

  FriendshipService(this._dioClient);

  @override
  Future<FriendshipResponse> sendRequest(int friendId) async {
    final response = await _dioClient.postData('friendships/send', {
      'friend_id': friendId,
    });
    return FriendshipResponse.fromJson(response.data);
  }

  @override
  Future<FriendshipResponse> cancelRequest(int friendId) async {
    final response = await _dioClient.postData('friendships/cancel', {
      'friend_id': friendId,
    });
    return FriendshipResponse.fromJson(response.data);
  }

  @override
  Future<FriendshipResponse> acceptRequest(int friendId) async {
    final response = await _dioClient.postData('friendships/accept', {
      'friend_id': friendId,
    });
    return FriendshipResponse.fromJson(response.data);
  }

  @override
  Future<FriendshipResponse> rejectRequest(int friendId) async {
    final response = await _dioClient.postData('friendships/reject', {
      'friend_id': friendId,
    });
    return FriendshipResponse.fromJson(response.data);
  }

  @override
  Future<FriendshipResponse> unfriend(int friendId) async {
    final response = await _dioClient.deleteData(
      'friendships/unfriend',
      data: {'friend_id': friendId},
    );
    return FriendshipResponse.fromJson(response.data);
  }

  @override
  Future<FriendshipResponse> getFriendshipStatus(int userId) async {
    try {
      final response = await _dioClient.getData('friendships/status/$userId');
      // The response.data is already the content we need
      return FriendshipResponse.fromJson(response.data);
    } catch (e) {
      printLog('Error in getFriendshipStatus: $e');
      rethrow;
    }
  }

  @override
  Future<Response> getFriendsList(int userId) async {
    return await _dioClient.getData('friendships/$userId');
  }
}
