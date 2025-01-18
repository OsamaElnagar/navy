import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/features/posts/controller/comment_controller.dart';
import 'package:navy/features/posts/model/comment_model.dart';
import 'package:navy/features/posts/view/widgets/post_comments_section.dart';

class CommentRepliesSection extends StatefulWidget {
  final int commentId;
  final int postId;
  final bool isExpanded;

  const CommentRepliesSection({
    super.key,
    required this.commentId,
    required this.postId,
    required this.isExpanded,
  });

  @override
  State<CommentRepliesSection> createState() => _CommentRepliesSectionState();
}

class _CommentRepliesSectionState extends State<CommentRepliesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final CommentController _commentController = Get.find<CommentController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.forward();
      _commentController.initRepliesController(widget.commentId);
    }
  }

  @override
  void didUpdateWidget(CommentRepliesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
        _commentController.initRepliesController(widget.commentId);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.disposeRepliesController(widget.commentId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Column(
          children: [
            // CreateReplySection(
            //   postId: widget.postId,
            //   parentId: widget.commentId,
            // ),
            GetBuilder<CommentController>(
              builder: (controller) {
                final pagingController =
                    controller.repliesPagingControllers[widget.commentId];
                if (pagingController == null) return const SizedBox.shrink();

                return PagedListView<int, CommentModel>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CommentModel>(
                    firstPageProgressIndicatorBuilder: (_) =>
                        const CommentsShimmerLoading(),
                    itemBuilder: (context, reply, index) =>
                        CommentItem(comment: reply),
                    noItemsFoundIndicatorBuilder: (_) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No replies yet'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
