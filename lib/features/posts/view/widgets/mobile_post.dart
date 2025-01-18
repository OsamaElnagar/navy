import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/custom_dialog.dart';
import 'package:navy/components/custom_loader.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/model/post_model.dart';
import 'package:navy/features/posts/view/widgets/post_media_widget.dart';
import 'package:navy/theme/app_colors.dart';
import 'package:pretty_logger/pretty_logger.dart';

import '../../../initial/view/widgets/popup_menu_wrapper.dart';
import 'post_action_bar.dart';

class MobilePost extends StatefulWidget {
  const MobilePost({super.key, required this.post});

  final Post post;

  @override
  State<MobilePost> createState() => _MobilePostState();
}

class _MobilePostState extends State<MobilePost> {
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
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.post.owner.avatar),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.owner.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.post.createdAt,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textGrey,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuWrapper(
                      onSelected: (value) {
                        PLog.cyan('Selected: $value');
                        if (value == 'edit') {
                          // Handle edit
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: 'Delete Post',
                              message:
                                  'The post will be moved to the trash and you can restore it within 30 days. \nOtherwise it will be permanently deleted.',
                              confirmText: 'Delete',
                              onConfirm: () async {
                                var controller = Get.find<PostController>();
                                await controller.deletePost(widget.post.id);
                                while (controller.isDeleting) {
                                  Get.dialog(
                                    const CustomLoader(
                                      task: 'Deleting post...',
                                    ),
                                    barrierDismissible: false,
                                  );
                                }
                                Get.back();
                              },
                            ),
                          );
                        } else if (value == 'view_profile') {
                          Get.toNamed(
                              RouteHelper.getVisitProfileRoute(
                                  widget.post.owner.id),
                              arguments: {
                                'id': widget.post.owner.id,
                              });
                        } else if (value == 'report') {
                          // Handle report
                        } else if (value == 'block') {
                          // Handle block
                        }
                      },
                      menuItems: [
                        if (widget.post.owner.id ==
                            Get.find<UserHiveService>().getUser()?.user.id) ...[
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit Post'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete Post'),
                          ),
                        ] else ...[
                          const PopupMenuItem(
                            value: 'view_profile',
                            child: Text('View Profile'),
                          ),
                          const PopupMenuItem(
                            value: 'report',
                            child: Text('Report Post'),
                          ),
                          const PopupMenuItem(
                            value: 'block',
                            child: Text('Block User'),
                          ),
                        ],
                      ],
                      borderRadius: 12.0,
                      elevation: 4.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),

                      // Animation
                      animationDuration: const Duration(milliseconds: 300),
                      animationCurve: Curves.easeOutBack,

                      // Positioning
                      preferredPosition: PMPosition.topRight,
                      offset: 8.0,

                      // Barrier
                      barrierDismissible: true,
                      barrierColor: Colors.black45,

                      // Constraints
                      constraints: const BoxConstraints(
                        maxWidth: 280,
                        minWidth: 120,
                      ),
                      child: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                // Post content
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
                    // For multiple media items
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
          Align(
            alignment: Alignment.center,
            child: PostActionBar(
              post: widget.post,
            ),
          ),
        ],
      ),
    );
  }
}
