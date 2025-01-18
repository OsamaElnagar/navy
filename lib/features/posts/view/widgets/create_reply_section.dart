import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/posts/controller/comment_controller.dart';
import 'package:navy/theme/app_colors.dart';

class CreateReplySection extends GetView<CommentController> {
  final int postId;
  final int parentId;

  const CreateReplySection({
    super.key,
    required this.postId,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentController>(
      builder: (controller) => Column(
        children: [
          if (controller.selectedMedia != null)
            Stack(
              children: [
                Container(
                  height: 80,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: controller.isVideo
                      ? const Center(child: Icon(Icons.video_file, size: 30))
                      : Image.file(
                          File(controller.selectedMedia!.path),
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    onPressed: controller.clearSelectedMedia,
                    icon: const Icon(Icons.close, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showMediaPicker(context),
                  icon: const Icon(Icons.attach_file, size: 20),
                  color: AppColors.textGrey,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.replyController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a reply',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => _handleSubmit(context),
                  icon: controller.isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Icon(Icons.send, size: 20),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take photo/video'),
              onTap: () {
                Navigator.pop(context);
                controller.pickMedia(fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                controller.pickMedia(fromCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    final reply = controller.replyController.text.trim();
    if (reply.isEmpty && controller.selectedMedia == null) return;

    controller.setLoading(true);
    await controller.createCommentOrReply(postId, reply, parentId: parentId);
    controller.setLoading(false);

    controller.refreshReplies(parentId);
  }
}
