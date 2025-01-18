import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:animate_do/animate_do.dart' as animate;

class BarTaps extends GetView<ProfileController> {
  const BarTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return animate.FadeInUp(
      child: Obx(
        () => Container(
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            curve: Curves.decelerate,
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.onTabChange(index),
            selectedItemColor: Theme.of(context).canvasColor,
            unselectedItemColor: Theme.of(context).disabledColor,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.feed),
                title: const Text('Posts'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.video_library),
                title: const Text('Videos'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.people),
                title: const Text('Friends'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
