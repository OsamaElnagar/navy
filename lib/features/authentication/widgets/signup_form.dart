import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_auth_field.dart';
import 'package:navy/core/helpers/validation.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';

import '../../../utils/gaps.dart';
import 'social_login_button.dart';

class SignupForm extends GetView<AuthController> {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              gapH16,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                      hintText: 'Name',
                      iconAsset: 'assets/icons/person_light.svg',
                      validator: Validation.validateName,
                    ),
                    gapH16,
                    CustomTextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Email',
                      iconAsset: 'assets/icons/mail_light.svg',
                      validator: Validation.validateEmail,
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
                    CustomTextFormField(
                      controller: controller.confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Confirm Password',
                      iconAsset: 'assets/icons/lock_light.svg',
                      obscureText: true,
                    ),
                    gapH16,
                    CustomTextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Phone Number',
                      iconAsset: 'assets/icons/phone_light.svg',
                    ),
                    gapH16,

                    /// CONTINUE BUTTON
                    SizedBox(
                      width: 296,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.register();
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
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
    );
  }
}
