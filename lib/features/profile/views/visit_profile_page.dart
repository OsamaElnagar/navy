import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/core/helpers/conditional_widget.dart';
import 'package:navy/features/profile/controller/visit_profile_controller.dart';
import 'package:navy/features/profile/views/widgets/bar_taps.dart';
import 'package:navy/features/profile/views/widgets/user_posts_list.dart';
import 'package:navy/utils/gaps.dart';

import 'widgets/general_info.dart';
import 'widgets/general_info_shimmer.dart';

class VisitProfilePage extends StatefulWidget {
  const VisitProfilePage({
    super.key,
  });

  @override
  State<VisitProfilePage> createState() => _VisitProfilePageState();
}

class _VisitProfilePageState extends State<VisitProfilePage> {
  late VisitProfileController controller;

  int id = int.parse(Get.parameters['id'] ?? "0");

  @override
  void initState() {
    controller = Get.find()..initProfile(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshProfile();
          await controller.checkFriendshipStatus(id);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  GetBuilder<VisitProfileController>(
                    initState: (_) {},
                    builder: (_) {
                      return ConditionalWidget(
                        condition: controller.profile != null,
                        builder: (context) =>
                            GeneralInfo(user: controller.profile!),
                        fallback: (context) => const GeneralInfoShimmer(),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 36),
                    child: Row(
                      children: [
                        gapW16,
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  gapH16,
                  const BarTaps(),
                  Obx(
                    () => IndexedStack(
                      index: controller.currentIndex.value,
                      children: [
                        UserPostsList(
                          pagingController: controller.postsPagingController,
                          onTryAgain: controller.refreshProfile,
                        ),
                        const Center(
                          child: Text('Videos'),
                        ),
                        const Center(
                          child: Text('Friends'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
