import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/posts/controller/comment_controller.dart';
import 'package:navy/theme/app_colors.dart';
import 'dart:io';

class CreateCommentSection extends GetView<CommentController> {
  const CreateCommentSection({
    super.key,
    required this.postId,
  });

  final int postId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentController>(
      builder: (controller) => Column(
        children: [
          if (controller.selectedMedia != null)
            Stack(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: controller.isVideo
                      ? const Center(child: Icon(Icons.video_file, size: 40))
                      : Image.file(
                          File(controller.selectedMedia!.path),
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    onPressed: controller.clearSelectedMedia,
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showMediaPicker(context),
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.textGrey,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.commentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a comment',
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _handleSubmit(context),
                  icon: const Icon(Icons.send),
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
    final comment = controller.commentController.text.trim();
    if (comment.isEmpty && controller.selectedMedia == null) return;

    await controller.createCommentOrReply(postId, comment);
  }
}
