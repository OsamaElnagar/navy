import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:navy/features/initial/view/widgets/popup_menu_wrapper.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/model/post_model.dart';

import '../../../theme/app_colors.dart';
import '../../posts/model/reaction_type.dart';

class ReelReactions extends StatelessWidget {
  ReelReactions({super.key, required this.reel});

  final Post reel;

  final PostController _postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    ReactionType? currentReaction = reel.selfReactionType != null
        ? ReactionType.values.firstWhere((r) => r.name == reel.selfReactionType,
            orElse: () => ReactionType.like)
        : null;

    return PopupMenuWrapper(
      onSelected: (reaction) async {
        await _postController.toggleReaction(
          reel.id,
          reaction.name,
        );
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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(20),
      // Animation
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.easeOutBack,

      // Positioning
      preferredPosition: PMPosition.topLeft,
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
      menuWidth: 365,
      child: LikeButton(
        size: 66,
        isLiked: reel.selfReacted,
        padding: EdgeInsets.zero,
        likeCount: reel.reactionsCount,
        countPostion: CountPostion.bottom,
        countBuilder: (likeCount, isLiked, text) => Text(text),
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
                reel.id,
                reel.selfReactionType ?? ReactionType.like.name,
              );
              return !success;
            } else {
              final success = await _postController.toggleReaction(
                reel.id,
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
