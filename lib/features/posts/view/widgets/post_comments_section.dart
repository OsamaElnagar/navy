import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/features/posts/controller/comment_controller.dart';
import 'package:navy/features/posts/model/comment_model.dart';
import 'package:navy/features/posts/view/widgets/comment_replies_section.dart';
import 'package:navy/features/posts/view/widgets/create_reply_section.dart';
import 'package:navy/features/posts/view/widgets/post_media_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'create_comment_section.dart';

class PostCommentsSection extends StatefulWidget {
  final int postId;
  final bool isExpanded;

  const PostCommentsSection({
    super.key,
    required this.postId,
    required this.isExpanded,
  });

  @override
  State<PostCommentsSection> createState() => _PostCommentsSectionState();
}

class _PostCommentsSectionState extends State<PostCommentsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final CommentController _commentController = Get.find<CommentController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.forward();
      _commentController.initCommentsController(widget.postId);
    }
  }

  @override
  void didUpdateWidget(PostCommentsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
        _commentController.initCommentsController(widget.postId);
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.disposeCommentsController(widget.postId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: Column(
        children: [
          const Divider(),
          CreateCommentSection(postId: widget.postId),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GetBuilder<CommentController>(
              builder: (controller) {
                final pagingController =
                    controller.commentsPagingControllers[widget.postId];
                if (pagingController == null) return const SizedBox.shrink();

                return PagedListView<int, CommentModel>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CommentModel>(
                    firstPageProgressIndicatorBuilder: (_) =>
                        const CommentsShimmerLoading(),
                    itemBuilder: (context, comment, index) =>
                        CommentItem(comment: comment),
                    noItemsFoundIndicatorBuilder: (_) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No comments yet'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatefulWidget {
  final CommentModel comment;

  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  bool _showReplyInput = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.comment.user.avatar),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.comment.user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          if (widget.comment.comment != null)
                            Text(widget.comment.comment!),
                          if (widget.comment.media != '') ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: PostMediaWidget(
                                mediaUrl: widget.comment.media!,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.comment.createdAt,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (widget.comment.parentId == null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showReplyInput = !_showReplyInput;
                                });
                              },
                              child: Text(
                                _showReplyInput ? 'Cancel' : 'Reply',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          if (widget.comment.repliesCount != null &&
                              widget.comment.repliesCount! > 0)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showReplies = !_showReplies;
                                });
                              },
                              child: Text(
                                _showReplies
                                    ? 'Hide replies'
                                    : 'View ${widget.comment.repliesCount} ${widget.comment.repliesCount == 1 ? 'reply' : 'replies'}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showReplyInput)
            CreateReplySection(
              postId: widget.comment.postId,
              parentId: widget.comment.id,
            ),
          if (widget.comment.repliesCount != null &&
              widget.comment.repliesCount! > 0)
            CommentRepliesSection(
              commentId: widget.comment.id,
              postId: widget.comment.postId,
              isExpanded: _showReplies,
            ),
        ],
      ),
    );
  }
}

class CommentsShimmerLoading extends StatelessWidget {
  const CommentsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isPlatformDarkMode;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
