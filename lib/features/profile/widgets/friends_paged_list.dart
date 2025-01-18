import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/features/profile/controller/friends_controller.dart';
import 'package:navy/features/profile/model/friend_model.dart';

class FriendsPagedList extends StatelessWidget {
  final void Function(Friend friend)? onFriendTap;
  final bool showDividers;
  final EdgeInsetsGeometry? padding;

  const FriendsPagedList({
    super.key,
    this.onFriendTap,
    this.showDividers = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendsController>(
      builder: (controller) {
        return PagedListView<int, Friend>(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          pagingController: controller.friendsPagingController,
          builderDelegate: PagedChildBuilderDelegate<Friend>(
            itemBuilder: (context, friend, index) => ListTile(
              leading: CustomAvatar(path: friend.avatar),
              title: Text(
                friend.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Friends since ${friend.acceptedAt}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: onFriendTap != null ? () => onFriendTap!(friend) : null,
              titleTextStyle: const TextStyle(),
            ),
            firstPageProgressIndicatorBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            noItemsFoundIndicatorBuilder: (context) => _buildEmptyState(
              icon: Icons.people_outline,
              message: 'No friends found',
              subtitle: 'Start connecting with people!',
            ),
            firstPageErrorIndicatorBuilder: (context) => _buildEmptyState(
              icon: Icons.error_outline,
              message: 'Error loading friends',
              subtitle: controller.friendsPagingController.error?.toString() ??
                  'Failed to load friends',
              action: FilledButton.icon(
                onPressed: () => controller.friendsPagingController.refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ),
            noMoreItemsIndicatorBuilder: (context) =>
                _buildEndOfListIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String subtitle,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color:
                Theme.of(Get.context!).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Theme.of(Get.context!).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: 24),
            action,
          ],
        ],
      ),
    );
  }

  Widget _buildEndOfListIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Icon(
            Icons.check_circle_outline,
            color:
                Theme.of(Get.context!).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            "You've reached the end",
            style: Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
