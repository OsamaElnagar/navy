import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/posts/model/post_model.dart';
import 'package:navy/features/posts/view/widgets/post_comments_section.dart';
import 'package:navy/features/reels/controller/reels_controller.dart';
import 'package:navy/features/reels/widgets/reel_reactions.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FloatingReelsActions extends StatelessWidget {
  FloatingReelsActions({super.key, required this.reel});

  final ReelsController reelsController = Get.find();
  final Post reel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        ReelReactions(reel: reel),
        InkWell(
          onTap: () => _showCommentsSheet(context, reel.id),
          child: Column(
            children: [
              const Icon(Icons.comment,
                  color: Color.fromRGBO(255, 255, 255, 1), size: 32),
              const SizedBox(height: 4),
              Text(
                '${reel.commentsCount}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            // Implement share functionality
          },
          child: const Column(
            children: [
              Icon(Icons.share, color: Colors.white, size: 32),
              SizedBox(height: 4),
              Text('Share', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommentsSheet(BuildContext context, int postId) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            hasSabGradient: false,
            enableDrag: true,
            topBarTitle: Text(
              'Comments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: PostCommentsSection(
                postId: postId,
                isExpanded: true,
              ),
            ),
          ),
        ];
      },
    );
  }
}
