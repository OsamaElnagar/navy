import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/core/helpers/media_helper.dart';
import 'package:navy/features/posts/model/post_model.dart' hide Pagination;
import 'package:navy/models/pagination.dart';

import '../repo/reels_repository.dart';

class ReelsController extends GetxController {
  final ReelsRepository reelsRepository;

  ReelsController({
    required this.reelsRepository,
  });

  Pagination _pagination = Pagination(
    currentPage: 1,
    lastPage: 1,
    perPage: 10,
    total: 10,
  );

  final PagingController<int, Post> reelsPagingController =
      PagingController(firstPageKey: 1);

  final RxBool isPlaying = false.obs;
  final RxBool isMuted = false.obs;

  final Rx<Post?> currentPost = Rx<Post?>(null);

  @override
  void onInit() {
    super.onInit();

    reelsPagingController.addPageRequestListener((pageKey) {
      getReels(pageKey, false);
    });
  }

  Future<void> getReels(int page, bool reload) async {
    try {
      Response response = await reelsRepository.getReels(page: page);
      if (response.statusCode == 200) {
        List content = response.data['content'];
        _pagination = Pagination.fromJson(response.data['pagination']);

        final isLastPage = page >= _pagination.lastPage;
        if (reload) {
          reelsPagingController.refresh();
        }

        List<Post> newReels = content
            .map((e) => Post.fromJson(e))
            .where((post) =>
                post.media.isNotEmpty &&
                MediaType.fromUrl(post.media.first) == MediaType.video)
            .toList();

        if (newReels.isEmpty) {
          reelsPagingController.error = 'No reels found.';
        }

        if (isLastPage) {
          reelsPagingController.appendLastPage(newReels);
        } else {
          final nextPageKey = page + 1;
          reelsPagingController.appendPage(newReels, nextPageKey);
        }
      } else {
        reelsPagingController.error = 'Error fetching reels';
      }
    } catch (error) {
      reelsPagingController.error = 'Error fetching reels\n$error';
    } finally {}
  }

  Future<void> refreshReels() async {
    return reelsPagingController.refresh();
  }
}
