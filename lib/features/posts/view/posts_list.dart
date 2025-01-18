import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/active_uploads_indicator.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/model/post_model.dart';
import 'package:navy/features/posts/view/widgets/post_shimmer.dart';

import 'widgets/mobile_post.dart';

class PostsList extends GetView<PostController> {
  PostsList({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: true,
      cacheExtent: 0,
      slivers: [
        const SliverToBoxAdapter(
          child: ActiveUploadsIndicator(),
        ),
        PagedSliverList<int, Post>(
          shrinkWrapFirstPageIndicators: true,
          pagingController: controller.postsPagingController,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, post, index) => MobilePost(post: post),
            newPageProgressIndicatorBuilder: (context) => const PostShimmer(),
            firstPageProgressIndicatorBuilder: (context) => Column(
              children: List.generate(3, (index) => const PostShimmer()),
            ),
            noItemsFoundIndicatorBuilder: (context) => _buildEmptyState(
              icon: Icons.inbox_outlined,
              message: "No posts found",
              subtitle: "Be the first one to share something!",
            ),
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 300),
            firstPageErrorIndicatorBuilder: (context) => _buildEmptyState(
              icon: Icons.error_outline,
              message: "Oops! Something went wrong",
              subtitle: controller.postsPagingController.error?.toString() ??
                  "Failed to load posts",
              action: FilledButton.icon(
                onPressed: () {
                  controller.refreshPosts();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
              ),
            ),
            noMoreItemsIndicatorBuilder: (context) =>
                _buildEndOfListIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String subtitle,
    Widget? action,
  }) {
    return Center(
      child: Padding(
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
      ),
    );
  }

  Widget _buildEndOfListIndicator() {
    return Container(
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
            style: Get.textTheme.bodyMedium?.copyWith(
              color:
                  Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
