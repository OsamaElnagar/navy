import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/assets_config.dart';
import '../../../utils/defaults.dart';
import '../../../utils/responsive.dart';
import '../widgets/signup_benefits.dart';
import '../widgets/signup_stepper.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                flex: Responsive.isTablet(context) ? 2 : 1,
                child: Container(
                  color: Theme.of(context).dividerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// APP LOGO
                      if (!Responsive.isMobile(context))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding,
                            vertical: AppDefaults.padding * 1.5,
                          ),
                          child: SvgPicture.asset(AssetConfig.logo),
                        ),

                      /// SIGNUP BENEFITS
                      const Expanded(child: SignupBenefits()),
                    ],
                  ),
                ),
              ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// APP LOGO
                      Responsive.isMobile(context)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDefaults.padding,
                                vertical: AppDefaults.padding * 1.5,
                              ),
                              child: SvgPicture.asset(AssetConfig.logo),
                            )
                          : const SizedBox(),
                    ],
                  ),

                  /// SIGNUP FORM
                  Expanded(child: SignupStepper()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                              
                                Text(
                                  'Already a member?',
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
                                  onPressed: () => Get.toNamed('/sign-in'),
                                  child: const Text('Sign in'),
                                ),
                              ],
                            ),
                          hGap(10),
*/
