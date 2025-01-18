import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:navy/features/profile/views/widgets/bar_taps.dart';
import 'package:navy/features/profile/views/widgets/floating_actions.dart';
import 'package:navy/features/profile/views/widgets/general_info.dart';
import 'package:navy/features/profile/views/widgets/user_posts_list.dart';
import 'package:navy/features/profile/widgets/friends_paged_list.dart';
import 'package:navy/utils/gaps.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshProfile();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  GeneralInfo(user: controller.userResponse!.user),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 36,
                    ),
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
                        const FriendsPagedList(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          onFriendTap: null,
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingActions(),
    );
  }
}

class TextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  const TextFormFieldComponent({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        gapH4,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
