import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';

import '../../../../components/custom_dialog.dart';
import 'update_profile_sheet.dart';
import 'trashed_posts_sheet.dart';

class FloatingActions extends StatelessWidget {
  FloatingActions({super.key});

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _key,
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.grey.withOpacity(0.3),
      ),
      children: [
        Row(
          children: [
            const Text('Logout'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                _key.currentState?.toggle();
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: 'Logout',
                    message:
                        'You are about to logout your acount from this device!',
                    confirmText: 'Logout',
                    onConfirm: () async {
                      await Get.find<AuthController>().logout();
                      Get.back();
                    },
                  ),
                );
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Trashed Posts'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                _key.currentState?.toggle();
                TrashedPostsSheet.show(context);
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
        Row(
          children: [
            const Text('update profile'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                _key.currentState?.toggle();
                UpdateProfileSheet.show(context);
              },
              child: const Icon(Icons.person),
            ),
          ],
        ),
        const Row(
          children: [
            Text('New Post'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
