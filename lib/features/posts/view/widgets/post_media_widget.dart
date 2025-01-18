import 'package:flutter/material.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/core/helpers/media_helper.dart';

import '../../../../core/video/post_video_player.dart';

class PostMediaWidget extends StatelessWidget {
  final String mediaUrl;

  const PostMediaWidget({
    super.key,
    required this.mediaUrl,
  });
  static const double maxMediaHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final MediaType mediaType = MediaType.fromUrl(mediaUrl);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (mediaType == MediaType.image) {
          return ClipRRect(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxMediaHeight,
                maxWidth: maxWidth,
              ),
              child: CustomImage(
                path: mediaUrl,
                fit: BoxFit.fitWidth,
                width: maxWidth,
              ),
            ),
          );
        } else if (mediaType == MediaType.video) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              // maxHeight: maxMediaHeight,
              maxWidth: maxWidth,
            ),
            child: PostVideoPlayer(
              videoUrl: mediaUrl,
              autoPlay: false,
              playTriggerFraction: 0.8,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
