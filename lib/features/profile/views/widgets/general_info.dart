import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/common_container.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/profile/views/widgets/user_details_expansion.dart';
import 'package:navy/utils/dimensions.dart';
import 'package:navy/utils/gaps.dart';
import 'package:navy/features/profile/controller/visit_profile_controller.dart';
import 'package:navy/features/profile/model/friendship_state.dart';
import 'package:navy/features/profile/model/friendship_action.dart';

import '../../../chat/controller/chat_controller.dart';

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({super.key, required this.user});

  final User user;

  bool isMe() {
    return Get.find<UserHiveService>().getUser()!.user.id == user.id;
  }

  Widget _buildFriendshipButton(VisitProfileController controller) {
    return Obx(() {
      final state = controller.friendshipState.value;

      // Show both accept and reject buttons for pending received requests
      if (state == FriendshipState.pendingReceived) {
        return Row(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.handleFriendship(
                      action: FriendshipAction.accept),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 4),
                        Text('Accept'),
                      ],
                    ),
            ),
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.handleFriendship(
                      action: FriendshipAction.reject),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close),
                        SizedBox(width: 4),
                        Text('Reject'),
                      ],
                    ),
            ),
          ],
        );
      }

      // Regular single button for other states
      return ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.handleFriendship(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(state),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(state.buttonText),
      );
    });
  }

  Color _getButtonColor(FriendshipState state) {
    switch (state) {
      case FriendshipState.pendingSent:
        return Colors.orange;
      case FriendshipState.pendingReceived:
        return Colors.green;
      case FriendshipState.accepted:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: Get.width,
      height: Get.height,
      hasDecoImage: true,
      decoImagePath: user.avatar,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 85,
              backgroundColor: Colors.white,
              child: CustomAvatar(
                width: Dimensions.imageSizeLarge * 2,
                radius: 80,
                path: user.avatar,
              ),
            ),
            gapH8,
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
            Text(
              user.bio ?? "",
              maxLines: 3,
              style: const TextStyle(color: Colors.white70),
            ),
            gapH16,
            if (!isMe())
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    _buildFriendshipButton(Get.find<VisitProfileController>()),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final chatController = Get.find<ChatController>();
                        await chatController
                            .createChat(type: 'private', participants: [
                          user.id
                        ], args: {
                          'name': user.name,
                          'avatar': user.avatar ?? "",
                        });
                      },
                      label: const Text('Message'),
                      icon: const Icon(Icons.chat),
                    ),
                  ],
                ),
              ),
            gapH16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(context, "344", 'Posts'),
                _buildStatColumn(context, "344", 'Followers'),
                _buildStatColumn(context, "344", 'Friends'),
              ],
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UserDetailsExpansion(user: user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
