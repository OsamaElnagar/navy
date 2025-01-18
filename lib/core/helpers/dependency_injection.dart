import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navy/controllers/theme_controller.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/features/authentication/service/user_hive_service.dart';
import 'package:navy/features/notifications/handlers/chat_notification_handler.dart';
import 'package:navy/features/notifications/handlers/friendship_notification_handler.dart';
import 'package:navy/features/splash/controller/splash_controller.dart';
import 'package:navy/features/splash/repository/splash_repo.dart';
import 'package:navy/models/language_model.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/services/notification_service.dart';
import 'package:navy/services/payments/payment_service_interface.dart';
import 'package:navy/services/payments/paymob_service.dart';
import 'package:navy/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  ///The following methods will be called before GetMaterialApp.
  ///IT is responsible for loading some dependencies before the app starts.
  static Future<void> initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences, permanent: true);

    final userBox = await Hive.openBox<UserResponse>('userBox');

    Get.put(UserHiveService(userBox), permanent: true);

    Get.put(
      DioClient(
        appBaseUrl: GetPlatform.isAndroid || GetPlatform.isMobile
            ? AppConstants.realApiUrl
            : AppConstants.apiUrl,
      ),
    );

    Get.put<PaymentServiceInterface>(
      PaymobService()..initialize(),
      //permanent: true,
    );

    Get.lazyPut(
      () => SplashController(
        splashRepo: SplashRepo(
          dioClient: Get.find<DioClient>(),
          sharedPreferences: Get.find<SharedPreferences>(),
        ),
        userHiveService: Get.find<UserHiveService>(),
      ),
    );

    Get.lazyPut(
      () => ThemeController(
        sharedPreferences: Get.find<SharedPreferences>(),
      ),
    );

    Get.put(
      NotificationService(
        handlers: [
          FriendshipNotificationHandler(),
          ChatNotificationHandler(),
        ],
      ),
      permanent: true,
    );
  }

  static Future<Map<String, Map<String, String>>> initializeLanguages() async {
    Map<String, Map<String, String>> languages = {};
    for (LanguageModel languageModel in AppConstants.languages) {
      String jsonStringValues = await rootBundle
          .loadString('assets/language/${languageModel.languageCode}.json');
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      Map<String, String> jsonValue = {};
      mappedJson.forEach((key, value) {
        jsonValue[key] = value.toString();
      });
      languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
          jsonValue;
    }
    return languages;
  }
}
