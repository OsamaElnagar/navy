import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:navy/utils/extensions.dart';
import 'package:navy/utils/styles.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/defaults.dart';

class BenefitText extends StatelessWidget {
  const BenefitText({
    super.key,
    this.isTitle = false,
    required this.title,
    this.icon = 'assets/icons/check_circled_light.svg',
  });

  final bool isTitle;

  final String title, icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
      ),
      leading: isTitle
          ? null
          : SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
              colorFilter: AppColors.success.toColorFilter,
            ),
      title: Text(
        title,
        style: isTitle ? ubuntuBold : ubuntuMedium,
      ),
      titleAlignment: ListTileTitleAlignment.titleHeight,
    );
  }
}
