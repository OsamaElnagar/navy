import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/features/posts/model/comment_model.dart';
import 'package:navy/features/posts/repo/comment_repository.dart';
import 'package:navy/services/dio_client.dart';
import 'package:image_picker/image_picker.dart';

class CommentController extends GetxController implements GetxService {
  final CommentRepository commentRepository;

  CommentController({required this.commentRepository});

  final Map<int, PagingController<int, CommentModel>>
      commentsPagingControllers = {};
  final Map<int, PagingController<int, CommentModel>> repliesPagingControllers =
      {};

  final ImagePicker _picker = ImagePicker();
  XFile? selectedMedia;
  bool isVideo = false;
  bool isLoading = false;

  void initCommentsController(int postId) {
    if (!commentsPagingControllers.containsKey(postId)) {
      final controller = PagingController<int, CommentModel>(firstPageKey: 1);
      controller.addPageRequestListener((pageKey) {
        getComments(postId, pageKey, false);
      });
      commentsPagingControllers[postId] = controller;
    }
  }

  void initRepliesController(int commentId) {
    if (!repliesPagingControllers.containsKey(commentId)) {
      final controller = PagingController<int, CommentModel>(firstPageKey: 1);
      controller.addPageRequestListener((pageKey) {
        getReplies(commentId, pageKey, false);
      });
      repliesPagingControllers[commentId] = controller;
    }
  }

  void disposeCommentsController(int postId) {
    final controller = commentsPagingControllers[postId];
    if (controller != null) {
      controller.dispose();
      commentsPagingControllers.remove(postId);
    }
  }

  void disposeRepliesController(int commentId) {
    final controller = repliesPagingControllers[commentId];
    if (controller != null) {
      controller.dispose();
      repliesPagingControllers.remove(commentId);
    }
  }

  Future<void> getComments(int postId, int page, bool reload) async {
    try {
      Response response =
          await commentRepository.getComments(postId, page: page);
      if (response.statusCode == 200) {
        List content = response.data['content'];
        final pagination = response.data['pagination'];
        final currentPage = pagination['current_page'];
        final lastPage = pagination['last_page'];
        // final perPage = pagination['per_page'];
        // final total = pagination['total'];

        final isLastPage = currentPage >= lastPage;
        if (reload) {
          commentsPagingControllers[postId]?.refresh();
        }

        List<CommentModel> newComments =
            content.map((e) => CommentModel.fromJson(e)).toList();

        if (isLastPage) {
          commentsPagingControllers[postId]?.appendLastPage(newComments);
        } else {
          commentsPagingControllers[postId]?.appendPage(newComments, page + 1);
        }
      }
    } catch (error) {
      commentsPagingControllers[postId]?.error = error;
      printLog('Error getting comments: $error');
    }
  }

  Future<void> getReplies(int commentId, int page, bool reload) async {
    try {
      Response response =
          await commentRepository.getReplies(commentId, page: page);
      if (response.statusCode == 200) {
        List content = response.data['content'];
        final pagination = response.data['pagination'];
        final currentPage = pagination['current_page'];
        final lastPage = pagination['last_page'];
        // final perPage = pagination['per_page'];
        // final total = pagination['total'];

        final isLastPage = currentPage >= lastPage;
        if (reload) {
          repliesPagingControllers[commentId]?.refresh();
        }

        List<CommentModel> newReplies =
            content.map((e) => CommentModel.fromJson(e)).toList();

        if (isLastPage) {
          repliesPagingControllers[commentId]?.appendLastPage(newReplies);
        } else {
          repliesPagingControllers[commentId]?.appendPage(newReplies, page + 1);
        }
      }
    } catch (error) {
      repliesPagingControllers[commentId]?.error = error;
      printLog('Error getting replies: $error');
    }
  }

  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  Future<void> pickMedia({required bool fromCamera}) async {
    try {
      final XFile? media = await _picker.pickMedia(
        imageQuality: 50,
        // source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (media != null) {
        // Check file size
        final bytes = await media.length();
        final mimeType = media.mimeType ?? '';
        final isVideoFile = mimeType.startsWith('video/');

        // Convert bytes to KB
        final sizeInKB = bytes / 1024;
        final maxSize = isVideoFile
            ? 50 * 1024
            : 3 * 1024; // 50MB for video, 3MB for images

        if (sizeInKB > maxSize) {
          Get.snackbar(
            'Error',
            'File size exceeds the limit (${isVideoFile ? '50MB' : '3MB'})',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        selectedMedia = media;
        isVideo = isVideoFile;
        update();
      }
    } catch (e) {
      printLog('Error picking media: $e');
    }
  }

  void clearSelectedMedia() {
    selectedMedia = null;
    isVideo = false;
    update();
  }

  Future<void> createCommentOrReply(int postId, String comment,
      {int? parentId}) async {
    try {
      final body = {
        'post_id': postId.toString(),
        'comment': comment,
        if (parentId != null) 'parent_id': parentId.toString(),
      };

      List<MultipartBody> multipartBody = [];

      // Add media file if selected
      if (selectedMedia != null) {
        multipartBody.add(
          MultipartBody('media', selectedMedia!),
        );
      }

      await commentRepository.createCommentOrReply(body, multipartBody);

      // Clear the form
      if (parentId != null) {
        replyController.clear();
      } else {
        commentController.clear();
      }
      clearSelectedMedia();

      // Refresh the appropriate controller
      if (parentId != null) {
        repliesPagingControllers[parentId]?.refresh();
      } else {
        commentsPagingControllers[postId]?.refresh();
      }
    } catch (error) {
      printLog('Error creating comment: $error');
      rethrow;
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await commentRepository.deleteComment(commentId);
      // Refresh relevant controllers after deletion
    } catch (error) {
      printLog('Error deleting comment: $error');
      rethrow;
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    update(); // Notify listeners
  }

  Future<void> refreshReplies(int parentId) async {
    // Implement logic to refresh replies for the given parentId
    initRepliesController(parentId); // Reinitialize the replies controller
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (var controller in commentsPagingControllers.values) {
      controller.dispose();
    }
    for (var controller in repliesPagingControllers.values) {
      controller.dispose();
    }
    commentsPagingControllers.clear();
    repliesPagingControllers.clear();
    commentController.dispose();
    replyController.dispose();
    super.onClose();
  }
}
