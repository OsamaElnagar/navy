import 'dart:convert';

import 'package:get/get.dart';
import 'package:navy/core/middleware/auth_middleware.dart';
import 'package:navy/features/authentication/view/register_page.dart';
import 'package:navy/features/authentication/view/sign_in_page.dart';
import 'package:navy/features/chat/view/chat_room_page.dart';
import 'package:navy/features/profile/controller/visit_profile_controller.dart';
import 'package:navy/features/profile/repo/profile_repo.dart';
import 'package:navy/features/profile/views/visit_profile_page.dart';

// import 'package:navy/models/notification_body.dart';

import '../../bindings/initial_binding.dart';
import '../../features/initial/view/initial_page.dart';
import '../../features/payment/controllers/payment_controller.dart';
import '../../features/payment/views/payment_test_screen.dart';
import '../../features/profile/views/profile_page.dart';
import '../middleware/chat_middleware.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String sendOtpScreen = '/send-otp';
  static const String verification = '/verification';
  static const String changePassword = '/change-password';

  static const String trashedPosts = '/trashed-posts';
  static const String profile = '/profile';
  static const String visitProfile = '/visit-profile';
  static const String update = '/update';

  static const String chatsScreen = '/chats-screen';
  static const String chatRoom = '/chat-room';
  static const String onBoardScreen = '/onBoardScreen';
  static const String settingScreen = '/settingScreen';
  static const String languageScreen = '/language-screen';
  static const String html = '/html';
  static const String paymentTest = '/payment-test';
  static const String notifications = '/notifications';

  static String getInitialRoute() => initial;

  static String getSignInRoute(String page) => '$signIn?page=$page';

  static String getSignUpRoute() => register;

  static String getPersonalProfileRoute() => profile;

  static String getSendOtpScreen(String fromScreen) {
    return '$sendOtpScreen?fromPage=$fromScreen';
  }

  static String getVerificationRoute(
      String identity, String identityType, String fromPage) {
    String data = Uri.encodeComponent(jsonEncode(identity));
    return '$verification?identity=$data&identity_type=$identityType&fromPage=$fromPage';
  }

  static String getChangePasswordRoute(
      String identity, String identityType, String otp) {
    String identity0 = Uri.encodeComponent(jsonEncode(identity));
    String otp0 = Uri.encodeComponent(jsonEncode(otp));
    return '/$changePassword?identity=$identity0&identity_type=$identityType&otp=$otp0';
  }

  static String getUpdateRoute(bool isUpdate) =>
      '$update?update=${isUpdate.toString()}';

  static String getChatRoomRoute(
          {required int chatId, bool? fromNotification}) =>
      '$chatRoom/$chatId?fromNotification=$fromNotification';

  static String getHtmlRoute(String page) => '$html?page=$page';

  static String getLanguageScreen(String fromPage) =>
      '$languageScreen?fromPage=$fromPage';

  static String getVisitProfileRoute(int id, {bool fromNotification = false}) =>
      "$visitProfile/$id?fromNotification=$fromNotification";

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      binding: InitialBinding(),
      page: () => const InitialPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
    ),

    // GetPage(
    //   name: trashedPosts,
    //   page: () => const TrashedPostsPage(),
    // ),

    GetPage(
      name: profile,
      binding: InitialBinding(),
      page: () => const ProfilePage(),
    ),

    GetPage(
      name: '$visitProfile/:id',
      binding: InitialBinding(),
      page: () {
        final fromNotification = Get.parameters['fromNotification'] == 'true';

        if (fromNotification) {
          Get.put(VisitProfileController(
            friendshipService: Get.find(),
            repository: ProfileRepository(
              dioClient: Get.find(),
              userHiveService: Get.find(),
            ),
          ));
        }
        return const VisitProfilePage();
      },
    ),

    GetPage(
      name: "$chatRoom/:id",
      binding: InitialBinding(),
      middlewares: [ChatMiddleware()],
      page: () => const ChatRoomPage(),
    ),
    // GetPage(
    //     binding: InitialBinding(),
    //     name: html,
    //     page: () => HtmlViewerScreen(
    //         htmlType: Get.parameters['page'] == 'terms-and-condition'
    //             ? HtmlType.termsAndCondition
    //             : Get.parameters['page'] == 'privacy-policy'
    //                 ? HtmlType.privacyPolicy
    //                 : Get.parameters['page'] == 'cancellation_policy'
    //                     ? HtmlType.cancellationPolicy
    //                     : Get.parameters['page'] == 'refund_policy'
    //                         ? HtmlType.refundPolicy
    //                         : HtmlType.aboutUs)),

    GetPage(
      name: paymentTest,
      page: () => PaymentTestScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PaymentController());
      }),
    ),
  ];
}
