import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navy/core/helpers/route_helper.dart';

import '../../../utils/assets_config.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/defaults.dart';
import '../../../utils/gaps.dart';
import '../widgets/sign_in_form.dart';
// import '../widgets/social_login_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          // First time pressed, show snackbar
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit the application'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Second time pressed within 2 seconds, exit the app
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDefaults.padding * 1.5,
                            ),
                            child: SvgPicture.asset(
                              AssetConfig.logo,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //     vertical: AppDefaults.padding * 1.5,
                          //   ),
                          //   child: OutlinedButton.icon(
                          //     onPressed: () => Get.back(),
                          //     icon: SvgPicture.asset(
                          //       AppConfig.iconArrowBackwardLight,
                          //     ),
                          //     label: const Text('Back'),
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      gapH24,
                      Row(
                        children: [
                          Text(
                            'Don’t have an account?',
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
                                Get.offAllNamed(RouteHelper.getSignUpRoute()),
                            child: const Text('Sign up'),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Sign up with Open account',
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .titleSmall
                      //       ?.copyWith(fontWeight: FontWeight.bold),
                      // ),
                      // gapH24,
                      // SocialLoginButton(
                      //   onGoogleLoginPressed: () {},
                      //   onAppleLoginPressed: () {},
                      // ),
                      // gapH24,
                      // const Divider(),
                      // gapH24,
                      // Text(
                      //   'Or continue with email address',
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .titleSmall
                      //       ?.copyWith(fontWeight: FontWeight.bold),
                      // ),
                      gapH16,

                      const SignInForm(),
                      gapH24,

                      /// FOOTER TEXT
                      Text(
                        'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      gapH24,

                      /// SIGNUP TEXT
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
