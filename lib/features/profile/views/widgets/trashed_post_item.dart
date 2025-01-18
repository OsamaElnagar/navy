import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_dialog.dart';
import 'package:navy/features/posts/view/widgets/post_media_widget.dart';
import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:navy/features/profile/model/trash_post_model.dart';
import 'package:navy/theme/app_colors.dart';

import '../../../initial/view/widgets/popup_menu_wrapper.dart';

class TrashedPost extends StatefulWidget {
  const TrashedPost({super.key, required this.post});

  final TrashPost post;

  @override
  State<TrashedPost> createState() => _TrashedPostState();
}

class _TrashedPostState extends State<TrashedPost> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deleted ${widget.post.updatedAt}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Created ${widget.post.createdAt}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textGrey,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuWrapper(
                      onSelected: (value) async {
                        if (value == 'restore') {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: 'Restore Post',
                              message:
                                  'Are you sure you want to restore this post?',
                              confirmText: 'Restore',
                              onConfirm: () async {
                                Get.back();
                                await Get.find<ProfileController>()
                                    .restorePost(widget.post.id);
                              },
                            ),
                          );
                        } else if (value == 'force_delete') {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: 'Delete Permanently',
                              message:
                                  'This action cannot be undone. Are you sure you want to permanently delete this post?',
                              confirmText: 'Delete Forever',
                              onConfirm: () async {
                                Get.back();
                                await Get.find<ProfileController>()
                                    .forceDeletePost(widget.post.id);
                              },
                            ),
                          );
                        }
                      },
                      menuItems: const [
                        PopupMenuItem(
                          value: 'restore',
                          child: Row(
                            children: [
                              Icon(Icons.restore),
                              SizedBox(width: 8),
                              Text('Restore Post'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'force_delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete Permanently',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      borderRadius: 12.0,
                      elevation: 4.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                      animationDuration: const Duration(milliseconds: 300),
                      animationCurve: Curves.easeOutBack,
                      preferredPosition: PMPosition.topRight,
                      offset: 8.0,
                      barrierDismissible: true,
                      barrierColor: Colors.black45,
                      constraints: const BoxConstraints(
                        maxWidth: 280,
                        minWidth: 120,
                      ),
                      child: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                if (widget.post.content.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.post.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          letterSpacing: 0.1,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.post.media.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  if (widget.post.media.length == 1) ...[
                    PostMediaWidget(mediaUrl: widget.post.media.first),
                  ] else ...[
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: widget.post.media.length == 2 ? 2 : 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: widget.post.media.map((mediaUrl) {
                        return PostMediaWidget(mediaUrl: mediaUrl);
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
