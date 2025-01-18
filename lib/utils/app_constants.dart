import '../models/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String appVersion = '1.0';
  static const String baseUrl = 'http://navy-system.test';
  static const String apiUrl = "$baseUrl/api/";
  static const String emulatorApiUrl = "http://10.0.2.2:8000/api/";
  static const String realApiUrl = "http://192.168.1.2:8000/api/";

  static const String login = 'login';
  static const String registerVendor = 'register-vendor';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String forgotPassword = 'forgot-password';
  static const String configUri = '/api/v1/customer/config';

  static const String posts = "posts";
  static const String reactions = "reactions";

  static const String chats = "chats";

  static const String comments = "comments";
  static const String replies = "replies";
  static const String deleteComment = "delete-comment";
  static const String toggleReaction = "toggle-reaction";

  static const String reels = "videos";

  //SharedPreferences keys
  static const String guestId = 'guest_id';
  static const String theme = 'mv_theme';
  static const String token = 'token';
  static const String zoneId = 'zoneId';
  static const String localizationKey = 'x-localization';
  static const String appApiKey = 'x-api-key';
  static const String appApiValue =
      'base64:w6sjMKUQFMBVtF8SfyX9ynzouNTdlu2o1y2zCMePuhs=';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String acceptCookies = 'accept_cookies';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String userCountryCode = 'user_country_code';
  static const String notification = 'notification';
  static const String searchHistory = 'search_history';
  static const String notificationCount = 'notification_count';
  static const String isSplashSeen = 'splash_seen';
  static const String cookiesManagement = 'cookies_management';
  static const String changeLanguage = 'change-language';

  static Map<String, String> configHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
    AppConstants.zoneId: 'configuration',
  };
  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: Images.us,
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      imageUrl: Images.ar,
      languageName: 'عربى',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}

class PusherConfig {
  static const String pusherAPPID = "1906325";
  static const String pusherAPPKEY = "53e7b62ce031beb52e7b";
  static const String pusherAPPSECRET = "6b7841121d0f6ee8cd7e";
  static const String pusherAPPCLUSTER = "eu";
}

class PaymentConfig {
  static const String paymobApiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TWpReE1qQXpMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuYnpHZk9rQTFvMzdVTHpxZ3lWaUctNnlOSXNvZ2RmeVJ5S1Z6dzRYc1lYcHNGc2EwY0tNNWY3d3N5MURoZnlSbHFVVGZ2bFVvN1FueWxDRUhvdk5rQmc=';
  static const int paymobCardIntegrationId = 2397670;
  static const int paymobWalletIntegrationId = 4890459;
  static const int paymobKioskIntegrationId = 123456;
  static const int paymobIframeId = 430046;
}
