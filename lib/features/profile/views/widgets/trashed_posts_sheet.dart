import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:navy/features/profile/views/widgets/trashed_posts.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart' as wolt;

class TrashedPostsSheet {
  static void show(BuildContext context) {
    final controller = Get.find<ProfileController>();

    // Initialize the pagination listener
    controller.trashedPostsPagingController.addPageRequestListener((pageKey) {
      controller.getTrashedPosts(pageKey, true);
    });

    wolt.WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalContext) {
        return [
          wolt.WoltModalSheetPage(
            hasSabGradient: true,
            topBarTitle: const Text('Trashed Posts'),
            isTopBarLayerAlwaysVisible: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            trailingNavBarWidget: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(modalContext).pop(),
            ),
            // Wrap the content in a SizedBox to constrain height
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: RefreshIndicator(
                onRefresh: () async =>
                    controller.trashedPostsPagingController.refresh,
                child: TrashedPosts(
                  pagingController: controller.trashedPostsPagingController,
                  onTryAgain: () => controller.getTrashedPosts(1, true),
                ),
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        return wolt.WoltModalType.dialog();
      },
      enableDrag: false,
      useSafeArea: true,
    );
  }
}
