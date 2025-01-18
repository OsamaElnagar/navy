import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_auth_field.dart';
import 'package:navy/core/helpers/validation.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';
import 'package:navy/utils/gaps.dart';

class SignupStepTwo extends GetView<AuthController> {
  final GlobalKey<FormState> formKey;

  const SignupStepTwo({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              Text(
                'Sign up with Open account',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              gapH24,
              SocialLoginButton(
                onGoogleLoginPressed: () {},
                onAppleLoginPressed: () {},
              ),
              gapH24,
              const Divider(),
              gapH24,
             
              Text(
                'Or continue with email address',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
                             */
              Text(
                'Credentials',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              gapH16,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Password',
                      iconAsset: 'assets/icons/lock_light.svg',
                      obscureText: true,
                      //validator: Validation.validatePassword,
                    ),
                    gapH16,
                    CustomTextFormField(
                      controller: controller.confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Confirm Password',
                      iconAsset: 'assets/icons/lock_light.svg',
                      obscureText: true,
                      // validator: (value) => Validation.validateConfirmPassword(
                      //   controller.passwordController.text,
                      //   value ?? '',
                      // ),
                    ),
                    gapH16,
                    CustomTextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Phone Number',
                      iconAsset: 'assets/icons/phone_light.svg',
                      validator: Validation.validatePhone,
                    ),
                    gapH16,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
