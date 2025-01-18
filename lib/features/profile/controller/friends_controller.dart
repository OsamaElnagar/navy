import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';

import '../model/friend_model.dart';
import '../repo/profile_repo.dart';
import '../service/friendship_service.dart';

class FriendsController extends GetxController {
  final ProfileRepository repo;
  final IFriendshipService friendshipService;

  FriendsController({
    required this.repo,
    required this.friendshipService,
  });

  final PagingController<int, Friend> friendsPagingController =
      PagingController(firstPageKey: 1);

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    friendsPagingController.addPageRequestListener((pageKey) {
      getFriends(pageKey);
    });
  }

  Future<void> getFriends(int page) async {
    try {
      final response = await friendshipService.getFriendsList(
        Get.find<UserHiveService>().getUser()!.user.id,
      );

      if (response.statusCode == 200) {
        final content = response.data['content'] as List;
        final pagination = response.data['pagination'];
        final currentPage = pagination['current_page'];
        final lastPage = pagination['last_page'];

        final isLastPage = currentPage >= lastPage;
        final List<Friend> newFriends =
            content.map((json) => Friend.fromJson(json)).toList();

        if (isLastPage) {
          friendsPagingController.appendLastPage(newFriends);
        } else {
          friendsPagingController.appendPage(newFriends, page + 1);
        }
      } else {
        friendsPagingController.error = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      friendsPagingController.error = e;
      printLog('Error fetching friends: $e');
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  @override
  void onClose() {
    friendsPagingController.dispose();
    super.onClose();
  }
}
