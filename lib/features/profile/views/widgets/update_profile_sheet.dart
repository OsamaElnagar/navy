import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:navy/utils/gaps.dart';
import 'package:get/get.dart';

import '../profile_page.dart';

class UpdateProfileSheet {
  static void show(BuildContext context) {
    final controller = Get.find<ProfileController>();

    WoltModalSheet.show<void>(
      context: context,
      barrierDismissible: false,
      pageListBuilder: (modalContext) {
        return [
          // First page - Basic Info
          WoltModalSheetPage(
            hasSabGradient: true,
            topBarTitle: const Text('Update Profile'),
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(modalContext).pop(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Section
                  Stack(
                    children: [
                      Obx(() {
                        final avatarUrl = controller.userResponse?.user.avatar;
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              controller.selectedImage.value != null
                                  ? FileImage(controller.selectedImage.value!)
                                  : (avatarUrl != null
                                      ? NetworkImage(avatarUrl)
                                      : null) as ImageProvider?,
                          child: (avatarUrl == null &&
                                  controller.selectedImage.value == null)
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            color: Colors.white,
                            onPressed: controller.pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapH24,
                  TextFormFieldComponent(
                    label: 'Name',
                    controller: controller.nameController,
                    hintText: 'Enter your name',
                  ),
                  gapH16,
                  TextFormFieldComponent(
                    label: 'Bio',
                    controller: controller.bioController,
                    hintText: 'Tell us about yourself',
                    maxLines: 3,
                  ),
                  gapH24,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          WoltModalSheet.of(modalContext).showNext(),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Second page - Contact Info
          WoltModalSheetPage(
            hasSabGradient: true,
            topBarTitle: const Text('Contact Information'),
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leadingNavBarWidget: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => WoltModalSheet.of(modalContext).showPrevious(),
            ),
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(modalContext).pop(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormFieldComponent(
                    label: 'Date of Birth',
                    controller: controller.dateOfBirthController,
                    hintText: 'Enter your Date of Birth',
                    keyboardType: TextInputType.phone,
                  ),
                  gapH16,
                  TextFormFieldComponent(
                    label: 'Location',
                    controller: controller.locationController,
                    hintText: 'Enter your location',
                  ),
                  gapH16,
                  TextFormFieldComponent(
                    label: 'Website',
                    controller: controller.websiteController,
                    hintText: 'Enter your website',
                    keyboardType: TextInputType.url,
                  ),
                  gapH24,
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.updateProfile,
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text('Update Profile'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < 600) {
          return WoltModalType.bottomSheet();
        } else {
          return WoltModalType.dialog();
        }
      },
    );
  }
}
