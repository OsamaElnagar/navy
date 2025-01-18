import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navy/components/custom_image.dart';
import 'package:navy/core/video/reels_video_player.dart';
import 'package:navy/features/initial/controller/feed_page_controller.dart';
import 'package:navy/features/posts/model/post_model.dart';
import 'package:navy/features/posts/view/create_post_bottom_sheet.dart';
import 'package:navy/features/reels/controller/reels_controller.dart';
import 'package:navy/features/reels/widgets/floaing_reels_actions.dart';
import 'package:animate_do/animate_do.dart' as animate_do;

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late final ReelsController reelsController;

  PageController pageController = PageController();

  @override
  void initState() {
    reelsController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagedPageView<int, Post>(
        scrollDirection: Axis.vertical,
        pagingController: reelsController.reelsPagingController,
        pageController: pageController,
        addAutomaticKeepAlives: true,
        addSemanticIndexes: true,
        allowImplicitScrolling: true,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, reel, index) => _ReelItem(
            reel: reel,
            index: index,
          ),
          firstPageProgressIndicatorBuilder: (_) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          newPageProgressIndicatorBuilder: (_) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          noItemsFoundIndicatorBuilder: (_) => const Center(
            child: Text(
              'No reels found',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReelItem extends StatelessWidget {
  final Post reel;
  final int index;

  const _ReelItem({
    required this.reel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        ReelVideoPlayer(
          videoUrl: reel.media.first,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 50,
          child: _ReelOverlay(reel: reel),
        ),
        Positioned(
          bottom: 30,
          right: 10,
          child: animate_do.FadeInRight(
            child: FloatingReelsActions(reel: reel),
          ),
        ),
        Positioned(
          top: 30,
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.all(8.0),
            child: animate_do.FadeInDown(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.find<FeedPageController>().currentIndex(0);
                      Get.bottomSheet(
                        const CreatePostBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(Get.context!).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.find<FeedPageController>().currentIndex(0);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReelOverlay extends StatelessWidget {
  final Post reel;

  const _ReelOverlay({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: animate_do.FadeInUp(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User Info Row
            Row(
              children: [
                CustomAvatar(path: reel.owner.avatar),
                const SizedBox(width: 12),
                Text(
                  reel.owner.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Content
            if (reel.content.isNotEmpty)
              Text(
                reel.content,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
