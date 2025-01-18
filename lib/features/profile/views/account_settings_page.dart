import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navy/utils/gaps.dart';

import '../../../utils/responsive.dart';

class AccountSetingsPage extends StatelessWidget {
  const AccountSetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!Responsive.isMobile(context)) 25.h,
        Text(
          "Account Setting",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        SvgPicture.asset(
          'assets/icons/logo.svg',
          // height: 300,
          width: 600,
        )
      ],
    );
  }
}
