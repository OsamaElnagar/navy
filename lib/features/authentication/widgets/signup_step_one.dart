import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_auth_field.dart';
import 'package:navy/core/helpers/validation.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';

import '../../../components/prepare_image_to_upload.dart';
import '../../../utils/gaps.dart';

class SignupStepOne extends GetView<AuthController> {
  final GlobalKey<FormState> formKey;

  const SignupStepOne({
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
                  'Personal Information',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.nameController,
                  hintText: 'Name',
                  iconAsset: 'assets/icons/person_light.svg',
                  validator: Validation.validateName,
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.usernameController,
                  hintText: 'Username',
                  iconAsset: 'assets/icons/person_filled.svg',
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  iconAsset: 'assets/icons/mail_light.svg',
                  validator: Validation.validateEmail,
                ),
                gapH16,
                ...[
                  PrepareImageToUpload(
                    title: 'Avatar',
                    initialImage: controller.avatar,
                    onImageChanged: controller.updateAvatar,
                  ),
                ],
                gapH24,
                // ElevatedButton(
                //   onPressed: () {
                //     // Move to the next step
                //     Get.find<SignupStepperController>().nextStep();
                //   },
                //   child: const Text('Next'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
