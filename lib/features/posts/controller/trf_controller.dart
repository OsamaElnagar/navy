//TRF = Trash Posts, Restore Posts, Force Delete Posts.

import 'package:get/get.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:pretty_logger/pretty_logger.dart';

import '../model/post_model.dart';
import '../repo/trf_repo.dart';

class TrfController extends GetxController {
  final TrfRepo trfRepo;
  TrfController({required this.trfRepo});

  final List<Post> trashedPosts = [];

  Future<void> getTrashed() async {
    final response = await trfRepo.getTrashed();
    if (response.statusCode == 200) {
      trashedPosts.addAll(response.data);
    } else {
      customSnackBar('Failed to get trashed posts');
      PLog.red('Failed to get trashed posts');
    }
    update();
  }

  void restorePost(Post post) async {
    final response = await trfRepo.restorePost(post.id);
    if (response.statusCode == 200) {
      trashedPosts.remove(post);
      customSnackBar('Post restored');
    } else {
      customSnackBar('Failed to restore post');
      PLog.red('Failed to restore post');
    }
    update();
  }

  void forceDeletePost(Post post) async {
    final response = await trfRepo.forceDeletePost(post.id);
    if (response.statusCode == 200) {
      trashedPosts.remove(post);
      customSnackBar('Post permanently deleted');
    } else {
      customSnackBar('Failed to delete post');
      PLog.red('Failed to delete post');
    }
    update();
  }
}
