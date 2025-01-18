import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navy/utils/defaults.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer(
      {super.key,
      this.child,
      this.width,
      this.height,
      this.alignment,
      this.margin,
      this.hasDecoImage = false,
      this.decoImagePath = ''});

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final bool hasDecoImage;
  final String? decoImagePath;
  final AlignmentGeometry? alignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).drawerTheme.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDefaults.borderRadius),
        ),
        image: hasDecoImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(decoImagePath!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(2 / 3),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      alignment: alignment,
      padding: const EdgeInsets.all(AppDefaults.padding * 0.75),
      child: child,
    );
  }
}
