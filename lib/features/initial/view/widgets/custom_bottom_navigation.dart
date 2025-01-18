import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart' as animate;
import 'package:get/get.dart';
import 'package:navy/features/chat/controller/chat_controller.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:navy/features/initial/controller/feed_page_controller.dart';

class CustomBottomNavigation extends StatelessWidget {
  final FeedPageController controller;

  const CustomBottomNavigation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isVisible.value
        ? animate.FadeInUp(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SalomonBottomBar(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                curve: Curves.decelerate,
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.currentIndex.value = index,
                selectedItemColor: Theme.of(context).canvasColor,
                unselectedItemColor: Theme.of(context).disabledColor,
                items: [
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.feed),
                    title: const Text('Feed'),
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.video_library),
                    title: const Text('Videos'),
                  ),
                  SalomonBottomBarItem(
                    icon: Stack(
                      children: [
                        const Icon(Icons.chat_outlined),
                        if (Get.find<ChatController>().totalUnreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                Get.find<ChatController>()
                                    .totalUnreadCount
                                    .toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: const Text('Chats'),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }
}
