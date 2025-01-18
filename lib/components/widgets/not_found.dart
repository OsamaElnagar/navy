import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/gaps.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gapH(200),
          SvgPicture.asset(
            'assets/icons/logo.svg',
            // height: 300,
            width: 600,
          ),
          gapH20,
          Text(
            "We are working on it. Soon it will be available. Thanks for your patience.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
