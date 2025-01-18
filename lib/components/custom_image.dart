import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navy/core/helpers/conditional_widget.dart';

import '../utils/images.dart';

class CustomAvatar extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit? fit;
  final String? placeholder;

  const CustomAvatar({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
      condition: path != null || path != "",
      builder: (context) => CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(path!),
      ),
      fallback: (context) => const Icon(Icons.person),
    );
  }
}

class CustomImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit? fit;
  final String? placeholder;

  const CustomImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
            imageUrl: path!,
            height: height,
            width: width,
            fit: fit,
            placeholder: (context, url) => Image.asset(
                  placeholder ?? Images.placeholderMedium,
                  height: height,
                  width: width,
                  fit: fit,
                ),
            errorWidget: (context, url, error) => Image.asset(
                  placeholder ?? Images.placeholderMedium,
                  height: height,
                  width: width,
                  fit: fit,
                )),
      ),
    );
  }
}
