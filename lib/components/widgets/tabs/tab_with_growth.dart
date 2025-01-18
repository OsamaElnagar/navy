import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/defaults.dart';
import '../../../utils/gaps.dart';
import '../../../utils/responsive.dart';


class TabWithGrowth extends StatelessWidget {
  const TabWithGrowth({
    super.key,
    required this.title,
    required this.amount,
    required this.growthPercentage,
    this.iconSrc = "assets/icons/shopping_bag_light.svg",
    this.isPositiveGrowth = true,
    this.iconBgColor = AppColors.secondaryBabyBlue,
    this.isVertical = false,
    this.bgColor,
    this.iconColor,
    this.growthBgColor,
    this.iconRight = false,
  });
  final String title, amount, growthPercentage, iconSrc;
  final bool isPositiveGrowth;
  final Color iconBgColor;
  final bool isVertical;
  final Color? bgColor;
  final Color? iconColor;
  final Color? growthBgColor;
  final bool iconRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding * 0.75,
      ),
      width: double.infinity,
      // height: 100,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDefaults.borderRadius),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context) && !isVertical)
            CircleAvatar(
              radius: 20,
              backgroundColor: iconBgColor,
              child: SvgPicture.asset(
                iconSrc,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColors.titleLight,
                  BlendMode.srcIn,
                ),
              ),
            ),
          if (!Responsive.isMobile(context)) gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isVertical)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: iconBgColor,
                    child: SvgPicture.asset(
                      iconSrc,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        iconColor ?? AppColors.titleLight,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                if (isVertical) gapH8,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (isVertical) gapW4,
                    if (isVertical) const Icon(Icons.error, size: 15),
                  ],
                ),
                Text(
                  amount,
                  style: Responsive.isDesktop(context)
                      ? Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold)
                      : Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                ),
                if (Responsive.isMobile(context) || isVertical)
                  Column(
                    children: [
                      gapH4,
                      Chip(
                        backgroundColor: growthBgColor ??
                            (isPositiveGrowth
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1)),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                          vertical: AppDefaults.padding * 0.25,
                        ),
                        label: Text(
                          isPositiveGrowth
                              ? "+$growthPercentage"
                              : "-$growthPercentage",
                          style: TextStyle(
                            color: isPositiveGrowth
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!Responsive.isMobile(context) && !isVertical)
            Chip(
              backgroundColor: growthBgColor ??
                  (isPositiveGrowth
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1)),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding * 0.25,
                  vertical: AppDefaults.padding * 0.25),
              label: Text(
                isPositiveGrowth ? "+$growthPercentage" : "-$growthPercentage",
                style: TextStyle(
                    color:
                        isPositiveGrowth ? AppColors.success : AppColors.error),
              ),
            ),
          if (iconRight)
            CircleAvatar(
              radius: 20,
              backgroundColor: iconBgColor,
              child: SvgPicture.asset(
                iconSrc,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColors.titleLight,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
