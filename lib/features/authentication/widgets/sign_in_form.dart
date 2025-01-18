import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_auth_field.dart';
import '../../../utils/gaps.dart';
import '../controller/auth_controller.dart';

class SignInForm extends GetView<AuthController> {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          CustomTextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Your email/username/phone',
            iconAsset: 'assets/icons/mail_light.svg',
          ),
          gapH16,

          CustomTextFormField(
            controller: controller.passwordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: 'Password',
            iconAsset: 'assets/icons/lock_light.svg',
            obscureText: true,
          ),
          gapH16,

          /// SIGN IN BUTTON
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Sign in'),
              )),
        ],
      ),
    );
  }
}
