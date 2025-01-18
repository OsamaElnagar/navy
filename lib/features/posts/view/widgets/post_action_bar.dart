import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:navy/features/initial/view/widgets/popup_menu_wrapper.dart';
import 'package:navy/theme/app_colors.dart';

import '../../controller/post_controller.dart';
import '../../model/post_model.dart';
import '../../model/reaction_type.dart';
import 'post_comments_section.dart';

class PostActionBar extends StatefulWidget {
  final Post post;

  const PostActionBar({
    super.key,
    required this.post,
  });

  @override
  State<PostActionBar> createState() => _PostActionBarState();
}

class _PostActionBarState extends State<PostActionBar> {
  late final PostController _postController;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _postController = Get.find<PostController>();
  }

  Future<void> _handleReaction(ReactionType reactionType) async {
    try {
      await _postController.toggleReaction(
        widget.post.id,
        reactionType.name,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update reaction')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildReactionButton(),
              ActionButton(
                icon: Icons.comment,
                label: 'Comment',
                onPressed: () {
                  setState(() => _showComments = !_showComments);
                },
                isActive: _showComments,
                count: widget.post.commentsCount,
              ),
              ActionButton(
                icon: Icons.share,
                label: 'Share',
                onPressed: () {
                  // Add share functionality
                },
              ),
            ],
          ),
        ),
        if (_showComments)
          PostCommentsSection(
            postId: widget.post.id,
            isExpanded: _showComments,
          ),
      ],
    );
  }

  Widget _buildReactionButton() {
    ReactionType? currentReaction = widget.post.selfReactionType != null
        ? ReactionType.values.firstWhere(
            (r) => r.name == widget.post.selfReactionType,
            orElse: () => ReactionType.like)
        : null;

    return PopupMenuWrapper(
      onSelected: (reaction) {
        if (reaction is ReactionType) {
          _handleReaction(reaction);
        }
      },
      menuItems: ReactionType.values.map((reaction) {
        return PopupMenuItem<ReactionType>(
          value: reaction,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reaction.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  reaction.label,
                  style: TextStyle(
                    color: reaction.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      // Customization
      trigger: PMTrigger.longPress,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: 24.0,
      elevation: 8.0,
      padding: EdgeInsets.zero,
      // Animation
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.easeOutBack,

      // Positioning
      preferredPosition: PMPosition.topCenter,
      offset: 12.0,

      // Arrow indicator
      showArrow: false,

      // Barrier
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),

      // Constraints
      constraints: const BoxConstraints(
        maxWidth: 320,
        minWidth: 280,
      ),
      axisDirection: PMAxisDirection.horizontal,
      menuWidth: 320,
      child: LikeButton(
        size: 66,
        isLiked: widget.post.selfReacted,
        likeCount: widget.post.reactionsCount,
        bubblesSize: 0,
        likeBuilder: (bool isLiked) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentReaction?.icon ?? Icons.thumb_up_outlined,
                color: isLiked
                    ? currentReaction?.color ?? Colors.blue
                    : AppColors.textGrey,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                currentReaction?.label ?? 'Like',
                style: TextStyle(
                  color: isLiked
                      ? currentReaction?.color ?? Colors.blue
                      : AppColors.textGrey,
                ),
              ),
            ],
          );
        },
        onTap: (isLiked) async {
          try {
            if (isLiked) {
              final success = await _postController.toggleReaction(
                widget.post.id,
                widget.post.selfReactionType ?? ReactionType.like.name,
              );
              return !success;
            } else {
              final success = await _postController.toggleReaction(
                widget.post.id,
                ReactionType.like.name,
              );
              return success;
            }
          } catch (e) {
            return isLiked;
          }
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final int? count;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.primary : AppColors.textGrey,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 4),
          Text(label),
          if (count != null && count! > 0) ...[
            const SizedBox(width: 4),
            Text(count.toString()),
          ],
        ],
      ),
    );
  }
}
