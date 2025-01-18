import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/posts/controller/create_post_controller.dart';
import 'package:navy/features/posts/repo/post_repository.dart';
import 'package:navy/utils/gaps.dart';
import 'package:navy/core/helpers/media_helper.dart';

class CreatePostBottomSheet extends StatefulWidget {
  const CreatePostBottomSheet({super.key});

  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  late final CreatePostController controller;
  final String tag = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    // Create a new instance for this bottom sheet
    controller = Get.put(
      CreatePostController(
        postRepo: PostRepository(
          dioClient: Get.find(),
        ),
      ),
      tag: tag, // Unique tag for this instance
    );
  }

  final UserResponse? navy = Get.find<UserHiveService>().getUser();

  Widget _buildMediaPreview(XFile media) {
    final MediaType mediaType = MediaType.fromUrl(media.path);

    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: mediaType == MediaType.video
                  ? _VideoThumbnail(videoFile: media)
                  : Image.file(
                      File(media.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => controller.removeMedia(media),
            ),
          ),
          if (mediaType == MediaType.video)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              Text(
                'Create Post',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        Get.back();
                        await controller.createPost();
                      },
                child: const Text('Post'),
              ),
            ],
          ),
          gapH16,
          Row(
            children: [
              Text('${navy?.user.name}'),
              Text('@${navy?.user.username}'),
            ],
          ),
          gapH16,
          Expanded(
            child: TextField(
              controller: controller.contentController,
              maxLines: 10,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
          if (controller.selectedMedia.isNotEmpty) ...[
            gapH16,
            Obx(() {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedMedia.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child:
                          _buildMediaPreview(controller.selectedMedia[index]),
                    );
                  },
                ),
              );
            }),
          ],
          gapH16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => controller.pickImageMedia(),
                icon: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () => controller.pickGalleryVideo(),
                icon: Icon(
                  Icons.videocam,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // This will trigger onClose in the controller
    Get.delete<CreatePostController>(tag: tag);
    super.dispose();
  }
}

class _VideoThumbnail extends StatelessWidget {
  final XFile videoFile;

  const _VideoThumbnail({required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_file,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            videoFile.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
