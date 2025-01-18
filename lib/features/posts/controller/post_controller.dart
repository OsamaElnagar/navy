import 'package:dio/dio.dart' show Response;
import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:navy/features/posts/model/post_model.dart';
import 'package:navy/features/posts/repo/post_repository.dart';
import 'package:pretty_logger/pretty_logger.dart';

import '../../../core/helpers/log_helper.dart';

class PostController extends GetxController implements GetxService {
  final PostRepository postRepository;
  PostResponse? _postResponse;
  final bool _isLoading = false;

  PostController({required this.postRepository});

  PostResponse? get postResponse => _postResponse;
  bool get isLoading => _isLoading;

  Pagination _pagination = Pagination(
    currentPage: 1,
    lastPage: 1,
    perPage: 10,
    total: 10,
  );
  Pagination? get pagination => _pagination;

  final PagingController<int, Post> postsPagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    postsPagingController.addPageRequestListener((pageKey) {
      getPosts(pageKey);
    });
    postsPagingController.addStatusListener((pagingStatus) {
      PLog.green('Paging Status is: ${pagingStatus.toString()}');
    });
  }

  @override
  void dispose() {
    postsPagingController.dispose();
    super.dispose();
  }

  Future<void> getPosts(int page) async {
    try {
      Response response = await postRepository.getPosts(page: page);
      if (response.statusCode == 200) {
        List content = response.data['content'];
        _pagination = Pagination.fromJson(response.data['pagination']);

        final isLastPage = page >= _pagination.lastPage;

        List<Post> newPosts = content.map((e) => Post.fromJson(e)).toList();

        printLog(newPosts.length.toString());

        if (newPosts.isEmpty) {
          postsPagingController.error = 'No posts found.';
        } else if (isLastPage) {
          postsPagingController.appendLastPage(newPosts);
        } else {
          final nextPageKey = page + 1;
          postsPagingController.appendPage(newPosts, nextPageKey);
        }
      } else {
        postsPagingController.error = 'Error fetching data';
      }
    } catch (error) {
      postsPagingController.error = 'Error fetching data\n$error';
    }
  }

  Future<void> refreshPosts() async {
    return postsPagingController.refresh();
  }

  Future<bool> toggleReaction(int postId, String reactionType) async {
    try {
      Response response =
          await postRepository.toggleReaction(postId, reactionType);
      if (response.statusCode == 200) {
        final currentItems = postsPagingController.itemList ?? [];
        final postIndex = currentItems.indexWhere((post) => post.id == postId);

        if (postIndex != -1) {
          final post = currentItems[postIndex];
          final content = response.data['content'];
          final action = content['action'];
          final reactionCounts = content['reaction_counts'];

          // Create a new post with updated reaction data
          Post updatedPost;
          switch (action) {
            case 'added':
            case 'updated':
              updatedPost = Post(
                id: post.id,
                content: post.content,
                visibility: post.visibility,
                location: post.location,
                createdAt: post.createdAt,
                updatedAt: post.updatedAt,
                reactionsCount: (reactionCounts as Map<String, dynamic>)
                    .values
                    .fold(0, (sum, count) => sum + (count as int)),
                commentsCount: post.commentsCount,
                sharesCount: post.sharesCount,
                selfReacted: true,
                selfReactionType: reactionType,
                media: post.media,
                owner: post.owner,
              );
              break;

            case 'removed':
              updatedPost = Post(
                id: post.id,
                content: post.content,
                visibility: post.visibility,
                location: post.location,
                createdAt: post.createdAt,
                updatedAt: post.updatedAt,
                reactionsCount: reactionCounts is List
                    ? post.reactionsCount -
                        1 // Subtract only the user's reaction when reaction_counts is empty
                    : (reactionCounts as Map<String, dynamic>)
                        .values
                        .fold(0, (sum, count) => sum + (count as int)),
                commentsCount: post.commentsCount,
                sharesCount: post.sharesCount,
                selfReacted: false,
                selfReactionType: null,
                media: post.media,
                owner: post.owner,
              );
              break;

            default:
              return false;
          }

          // Update the post in the list
          currentItems[postIndex] = updatedPost;
          postsPagingController.itemList = List.from(currentItems);
          update();
          return true;
        }
      }
      return false;
    } catch (e) {
      PLog.error('Error toggling reaction: \n$e');
      return false;
    }
  }

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  Future<void> deletePost(int postId) async {
    if (_isDeleting) return;
    _isDeleting = true;
    update();
    Response response = await postRepository.deletePost(postId);
    if (response.statusCode == 200) {
      postsPagingController.itemList?.removeWhere((post) => post.id == postId);
      postsPagingController.refresh();
      customSnackBar('Post successfully added to trash!', isError: false);
    } else {
      customSnackBar('Failed to delete post!', isError: true);
    }
    _isDeleting = false;
    update();
  }
}
