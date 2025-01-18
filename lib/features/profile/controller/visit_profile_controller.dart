import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/posts/model/post_model.dart' hide Pagination;
import 'package:navy/features/profile/repo/profile_repo.dart';
import 'package:navy/models/pagination.dart';
import 'package:navy/features/profile/model/friendship_state.dart';
import 'package:navy/features/profile/model/friendship_response.dart';
import 'package:navy/features/profile/service/friendship_service.dart';
import 'package:navy/features/profile/model/friendship_action.dart';

class VisitProfileController extends GetxController {
  final ProfileRepository repository;
  final IFriendshipService friendshipService;
  final RxBool isLoading = false.obs;

  VisitProfileController({
    required this.repository,
    required this.friendshipService,
  });

  User? profile;

  Pagination _pagination = Pagination(
    currentPage: 1,
    lastPage: 1,
    perPage: 10,
    total: 10,
  );
  var currentIndex = 0.obs;

  final Rx<FriendshipState> friendshipState = FriendshipState.notFriend.obs;

  void onTabChange(int index) {
    currentIndex(index);
  }

  Pagination? get pagination => _pagination;

  final PagingController<int, Post> postsPagingController =
      PagingController(firstPageKey: 1);

  Future<void> visitProfile({
    required int id,
    required int page,
    required bool reload,
  }) async {
    try {
      dio.Response response = await repository.visitProfile(id: id);
      if (response.statusCode == 200) {
        List posts = response.data['content']['posts'];
        final user = response.data['content']['user'];
        profile = User.fromJson(user);
        _pagination = Pagination.fromJson(response.data['pagination']);

        final isLastPage = _pagination.currentPage >= _pagination.lastPage;

        List<Post> newPosts = posts.map((e) => Post.fromJson(e)).toList();

        if (newPosts.isEmpty) {
          postsPagingController.error = 'USER HAS NO POSTS';
        } else if (isLastPage) {
          postsPagingController.appendLastPage(newPosts);
        } else {
          final nextPageKey = _pagination.currentPage + 1;
          postsPagingController.appendPage(newPosts, nextPageKey);
        }
      } else {
        postsPagingController.error =
            'Something went wrong while fetching data';
      }
    } catch (error) {
      postsPagingController.error = 'Error fetching data\n$error';
    }
    update();
  }

  Future<void> refreshProfile() async {
    return postsPagingController.refresh();
  }

  Future<void> initProfile(int id) async {
    postsPagingController.addPageRequestListener((pageKey) async {
      await visitProfile(id: id, page: pageKey, reload: true);
    });
    await checkFriendshipStatus(id);
  }

  Future<void> handleFriendship({FriendshipAction? action}) async {
    try {
      isLoading(true);
      FriendshipResponse response;

      // If action is provided, use it directly
      if (action != null) {
        switch (action) {
          case FriendshipAction.accept:
            response = await friendshipService.acceptRequest(profile!.id);
            if (!response.hasErrors) {
              friendshipState(FriendshipState.accepted);
            }
            break;
          case FriendshipAction.reject:
            response = await friendshipService.rejectRequest(profile!.id);
            if (!response.hasErrors) {
              friendshipState(FriendshipState.notFriend);
            }
            break;
          default:
            throw Exception('Invalid action');
        }
      } else {
        // Handle based on current state
        switch (friendshipState.value) {
          case FriendshipState.notFriend:
            response = await friendshipService.sendRequest(profile!.id);
            if (!response.hasErrors) {
              friendshipState(FriendshipState.pendingSent);
            }
            break;
          case FriendshipState.pendingSent:
            response = await friendshipService.cancelRequest(profile!.id);
            if (!response.hasErrors) {
              friendshipState(FriendshipState.notFriend);
            }
            break;
          case FriendshipState.accepted:
            response = await friendshipService.unfriend(profile!.id);
            if (!response.hasErrors) {
              friendshipState(FriendshipState.notFriend);
            }
            break;
          default:
            throw Exception('Invalid state for default action');
        }
      }

      if (response.hasErrors) {
        Get.snackbar('Error', response.firstError);
      } else {
        customSnackBar(
          response.message,
          isError: false,
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      customSnackBar(
        'An unexpected error occurred',
        icon: Icons.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkFriendshipStatus(int userId) async {
    try {
      isLoading(true);
      final response = await friendshipService.getFriendshipStatus(userId);
      printLog('Friendship Status: ${response.status}, Type: ${response.type}');
      friendshipState(_mapStatusToState(response.status, response.type));
      printLog('Mapped State: ${friendshipState.value}');
    } catch (e) {
      printLog('Error checking friendship status: $e');
    } finally {
      isLoading(false);
    }
  }

  FriendshipState _mapStatusToState(String status, String type) {
    printLog('Mapping status: $status, type: $type');
    if (status == 'pending') {
      return type == 'sender'
          ? FriendshipState.pendingSent
          : FriendshipState.pendingReceived;
    } else if (status == 'accepted') {
      return FriendshipState.accepted;
    }
    return FriendshipState.notFriend;
  }

  @override
  void onClose() {
    profile = null;
    super.onClose();
  }
}
