import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/helpers/responsive_helper.dart';
import '../theme/app_colors.dart';
import '../utils/dimensions.dart';

void customSnackBar(
  String? message, {
  bool isError = true,
  double margin = Dimensions.paddingSizeSmall,
  int duration = 4,
  Color? backgroundColor,
  Widget? customWidget,
  double borderRadius = Dimensions.radiusSmall,
  BuildContext? context,
  SnackPosition position = SnackPosition.TOP,
  IconData? icon,
  VoidCallback? onTap,
  String? actionLabel,
  bool showProgressIndicator = false,
}) {
  if (message != null && message.isNotEmpty) {
    final BuildContext currentContext =
        context ?? Get.context ?? Get.overlayContext ?? Get.key.currentContext!;
    final double screenWidth = MediaQuery.of(currentContext).size.width;
    final bool isDark = Theme.of(currentContext).brightness == Brightness.dark;

    // Theme-aware colors
    final Color defaultBgColor = isError
        ? AppColors.error
        : (isDark ? AppColors.bgSecondaryDark : AppColors.bgSecondaryLight);
    final Color textColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    Get.showSnackbar(GetSnackBar(
      backgroundColor: backgroundColor ?? defaultBgColor,
      message: customWidget == null ? message.tr : null,
      messageText: customWidget ??
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 24),
                const SizedBox(width: Dimensions.paddingSizeSmall),
              ],
              Expanded(
                child: Text(
                  message.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onTap,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
      maxWidth: Dimensions.webMaxWidth,
      duration: Duration(seconds: duration),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.only(
        top: position == SnackPosition.TOP ? Dimensions.paddingSizeSmall : 0,
        left: ResponsiveHelper.isDesktop(currentContext)
            ? (screenWidth - Dimensions.webMaxWidth) / 2
            : Dimensions.paddingSizeSmall,
        right: ResponsiveHelper.isDesktop(currentContext)
            ? (screenWidth - Dimensions.webMaxWidth) / 2
            : Dimensions.paddingSizeSmall,
        bottom: position == SnackPosition.BOTTOM ? margin : 0,
      ),
      borderRadius: borderRadius,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: position,
      showProgressIndicator: showProgressIndicator,
      progressIndicatorBackgroundColor: textColor,
    ));
  }
}
