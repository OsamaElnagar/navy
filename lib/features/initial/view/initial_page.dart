import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/chat/view/chat_list_page.dart';
import 'package:navy/features/initial/controller/feed_page_controller.dart';
import 'package:navy/features/initial/view/widgets/custom_bottom_navigation.dart';
import 'package:navy/features/initial/view/widgets/feed_header.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/view/posts_list.dart';
import 'package:navy/features/reels/view/reels_page.dart';
// import 'package:navy/features/reels/view/reels_screen.dart';
import 'package:navy/utils/responsive.dart';

import '../../posts/view/create_post_bottom_sheet.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late UserResponse? navy;
  final FeedPageController controller = Get.find<FeedPageController>();

  Future<bool> _onWillPop() async {
    if (controller.currentIndex.value != 0) {
      controller.currentIndex(0);
      return false;
    }
    return true;
  }

  void _showCreatePostSheet() {
    Get.bottomSheet(
      const CreatePostBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  void initState() {
    navy = Get.find<UserHiveService>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return SafeArea(
                child: Row(
                  children: <Widget>[
                    if (!Responsive.isMobile(context))
                      NavigationRail(
                        backgroundColor: Theme.of(context).dividerColor,
                        selectedIndex: 0,
                        extended: false,
                        onDestinationSelected: (int index) {
                          // Handle navigation
                        },
                        labelType: NavigationRailLabelType.all,
                        destinations: const <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.home, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.home_filled, color: Colors.white),
                            label: Text('Home',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.favorite, color: Colors.white),
                            label: Text('Favorites',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.settings, color: Colors.white),
                            label: Text('Settings',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => Future.sync(() {
                          Get.find<PostController>()
                              .postsPagingController
                              .refresh();
                          navy = Get.find<UserHiveService>().getUser();
                        }),
                        child: CustomScrollView(
                          controller: controller.scrollController,
                          slivers: [
                            SliverAppBar(
                              floating: true,
                              snap: true,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              expandedHeight: 220,
                              collapsedHeight: kToolbarHeight,
                              flexibleSpace: FlexibleSpaceBar(
                                background: FeedHeader(
                                  user: navy,
                                  onCreatePost: _showCreatePostSheet,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: PostsList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case 1:
              return const ReelsPage();
            case 2:
              return ChatListPage();
            default:
              return SafeArea(
                child: Row(
                  children: <Widget>[
                    if (!Responsive.isMobile(context))
                      NavigationRail(
                        backgroundColor: Theme.of(context).dividerColor,
                        selectedIndex: 0,
                        extended: false,
                        onDestinationSelected: (int index) {
                          // Handle navigation
                        },
                        labelType: NavigationRailLabelType.all,
                        destinations: const <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.home, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.home_filled, color: Colors.white),
                            label: Text('Home',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.favorite, color: Colors.white),
                            label: Text('Favorites',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings, color: Colors.grey),
                            selectedIcon:
                                Icon(Icons.settings, color: Colors.white),
                            label: Text('Settings',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => Future.sync(() {
                          Get.find<PostController>()
                              .postsPagingController
                              .refresh();
                          navy = Get.find<UserHiveService>().getUser();
                        }),
                        child: CustomScrollView(
                          controller: controller.scrollController,
                          slivers: [
                            SliverAppBar(
                              floating: true,
                              snap: true,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              expandedHeight: 220,
                              collapsedHeight: kToolbarHeight,
                              flexibleSpace: FlexibleSpaceBar(
                                background: FeedHeader(
                                  user: navy,
                                  onCreatePost: _showCreatePostSheet,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: PostsList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }
        }),
        bottomNavigationBar: CustomBottomNavigation(controller: controller),
      ),
    );
  }
}
