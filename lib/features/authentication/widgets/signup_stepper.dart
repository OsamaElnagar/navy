import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_stepper.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/authentication/widgets/signup_step_one.dart';
import 'package:navy/features/authentication/widgets/signup_step_three.dart';
import 'package:navy/features/authentication/widgets/signup_step_two.dart';
import 'package:navy/theme/app_colors.dart';
import 'package:navy/utils/gaps.dart';
import 'package:navy/features/authentication/controller/signup_stepper_controller.dart';

class SignupStepper extends StatelessWidget {
  SignupStepper({super.key});

  final SignupStepperController signupStepperController =
      Get.put(SignupStepperController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Signup',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          gapH24,

          /// SIGNUP TEXT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textGrey),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    color: AppColors.titleLight,
                  ),
                ),
                onPressed: () =>
                    Get.offAllNamed(RouteHelper.getSignInRoute('')),
                child: const Text('Sign in'),
              ),
            ],
          ),

          gapH24,
          Obx(
            () => CustomStepper(
              currentStep: signupStepperController.currentStep.value,
              totalSteps: 3,
              onPrevious: signupStepperController.currentStep.value > 0
                  ? signupStepperController.previousStep
                  : null,
              onNext: signupStepperController.nextStep,
            ),
          ),
          Expanded(
            child: PageView(
              controller: signupStepperController.pageController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              onPageChanged: (index) =>
                  signupStepperController.currentStep.value = index,
              children: [
                SignupStepOne(
                  formKey: signupStepperController.formKeyStepOne,
                ),
                SignupStepTwo(
                  formKey: signupStepperController.formKeyStepTwo,
                ),
                SignupStepThree(
                  formKey: signupStepperController.formKeyStepThree,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
