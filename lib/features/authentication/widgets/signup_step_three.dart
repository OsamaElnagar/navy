import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_auth_field.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';
import 'package:navy/utils/assets_config.dart';
import 'package:navy/utils/gaps.dart';

class SignupStepThree extends GetView<AuthController> {
  final GlobalKey<FormState> formKey;

  const SignupStepThree({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Information',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.websiteController,
                  hintText: 'Website',
                  iconAsset: AssetConfig.kIconTrendingDownFilled,
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.locationController,
                  hintText: 'Location',
                  iconAsset: AssetConfig.kIconLocationLight,
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.bioController,
                  hintText: 'Bio',
                  iconAsset: AssetConfig.kIconBookmarkLight,
                ),
                gapH24,
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up'),
                  ),
                ),
                gapH24,
                Text(
                  'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
