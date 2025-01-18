import 'package:flutter/material.dart';
import 'package:navy/core/helpers/responsive_helper.dart';
import 'package:navy/utils/dimensions.dart';

class WebShadowWrap extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? maxHeight;
  final double? minHeight;
  const WebShadowWrap(
      {super.key,
      required this.child,
      this.width = Dimensions.webMaxWidth,
      this.maxHeight,
      this.minHeight});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Padding(
            padding: ResponsiveHelper.isMobile(context)
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeLarge,
                    horizontal: Dimensions.paddingSizeExtraSmall,
                  ),
            child: Container(
              constraints: BoxConstraints(
                minHeight:
                    minHeight ?? MediaQuery.of(context).size.height * 0.6,
                maxHeight: maxHeight != null ? maxHeight! : double.infinity,
              ),
              padding: !ResponsiveHelper.isMobile(context)
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : null,
              decoration: !ResponsiveHelper.isMobile(context)
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 5,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.12),
                        )
                      ],
                    )
                  : null,
              width: width,
              child: child,
            ),
          )
        : child;
  }
}
