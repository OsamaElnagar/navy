import 'package:get/get.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';
import 'package:navy/features/authentication/repo/auth_repo.dart';
import 'package:navy/features/chat/controller/chat_controller.dart';
import 'package:navy/features/chat/controller/chat_room_controller.dart';
import 'package:navy/features/chat/repo/chat_repository.dart';
import 'package:navy/features/initial/controller/feed_page_controller.dart';
import 'package:navy/features/payment/controllers/payment_controller.dart';
import 'package:navy/features/posts/controller/comment_controller.dart';
import 'package:navy/features/posts/controller/create_post_controller.dart';
import 'package:navy/features/posts/controller/post_controller.dart';
import 'package:navy/features/posts/repo/comment_repository.dart';
import 'package:navy/features/profile/controller/friends_controller.dart';
import 'package:navy/features/profile/controller/profile_controller.dart';
import 'package:navy/features/profile/controller/visit_profile_controller.dart';
import 'package:navy/features/profile/repo/profile_repo.dart';
import 'package:navy/features/profile/service/friendship_service.dart';
import 'package:navy/features/reels/controller/reels_controller.dart';
import 'package:navy/features/reels/repo/reels_repository.dart';
// import 'package:navy/features/reels/repo/reels_repository.dart';
import 'package:navy/services/dio_client.dart';

import '../features/posts/repo/post_repository.dart';
import '../controllers/upload_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AuthController(
        authRepo: AuthRepo(
          dioClient: Get.find(),
          sharedPreferences: Get.find(),
          userHiveService: Get.find(),
        ),
      ),
    );
    Get.lazyPut(
      () => PaymentController(),
    );

    Get.lazyPut(
      () => FeedPageController(),
    );

    Get.lazyPut(
      () => ReelsController(
        reelsRepository: ReelsRepository(
          dioClient: Get.find(),
        ),
      ),
    );

    Get.lazyPut(
      () => PostController(
        postRepository: PostRepository(
          dioClient: Get.find(),
        ),
      ),
    );

    Get.lazyPut(
      () => CommentController(
        commentRepository: CommentRepository(
          dioClient: Get.find<DioClient>(),
        ),
      ),
    );

    Get.lazyPut(
      () => CreatePostController(
        postRepo: PostRepository(
          dioClient: Get.find(),
        ),
      ),
    );

    Get.lazyPut(() => UploadController());

    Get.lazyPut(
      () => ProfileController(
        repository: ProfileRepository(
          dioClient: Get.find(),
          userHiveService: Get.find(),
        ),
      ),
    );

    Get.lazyPut<IFriendshipService>(
      () => FriendshipService(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut(
      () => VisitProfileController(
        friendshipService: Get.find(),
        repository: ProfileRepository(
          dioClient: Get.find(),
          userHiveService: Get.find(),
        ),
      ),
    );

    Get.lazyPut(
      () => FriendsController(
        friendshipService: Get.find(),
        repo: ProfileRepository(
          dioClient: Get.find(),
          userHiveService: Get.find(),
        ),
      ),
    );

    Get.lazyPut(
      () => ChatController(
        chatRepository: ChatRepository(
          dioClient: Get.find(),
        ),
      ),
    );
    Get.lazyPut(
      () => ChatRoomController(
        repo: ChatRepository(
          dioClient: Get.find(),
        ),
      ),
    );
  }
}
