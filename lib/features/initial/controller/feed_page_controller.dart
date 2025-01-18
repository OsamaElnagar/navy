import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';

// import '../../authentication/service/user_hive_service.dart';
// import '../../notifications/repo/pusher_friendship_notification_service.dart';

class FeedPageController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var isVisible = true.obs;
  var currentIndex = 0.obs;
  var isReelsMode = false.obs;

  void changeIndex(int index) {
    currentIndex(index);
  }

  void toggleReelsMode() {
    isReelsMode.value = !isReelsMode.value;
    if (isReelsMode.value) {
      isVisible.value = false;
    } else {
      isVisible.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Get.put<PusherFriendshipNotificationService>(
    //   PusherFriendshipNotificationService(
    //     dioClient: Get.find(),
    //     userHiveService: Get.find(),
    //   )..initPusher(Get.find<UserHiveService>().getUser()!.user.id,
    //       Get.find<UserHiveService>().getUser()!.token),
    // );

    scrollController.addListener(_onScroll);
    ever(currentIndex, (index) {
      if (index == 1) {
        // Videos tab
        isVisible.value = false;
      } else {
        isVisible.value = true;
      }
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (isVisible.value) {
        isVisible(false);
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isVisible.value) {
        isVisible(true);
      }
    }
  }
}
