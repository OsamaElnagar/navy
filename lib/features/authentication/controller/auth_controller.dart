import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/foundation.dart';
// import 'package:device_info_plus/device_info_plus.dart';  // Commenting out problematic package
import 'package:package_info_plus/package_info_plus.dart';
import 'package:navy/components/custom_snackbar.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/authentication/repo/auth_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy/services/dio_client.dart';
import '../model/user_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final deviceNameController = TextEditingController();

  RxBool isLoading = false.obs;

  UserResponse? userResponse;

  Future<void> login() async {
    isLoading(true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        customSnackBar('Please enter both email and password');
        return;
      }

      final deviceName = await getDeviceName();
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'device_name': deviceName,
      };

      Response response = await authRepo.login(body);

      if (response.statusCode == 200 &&
          response.data['response_code'] == 'default_200') {
        userResponse = UserResponse.fromJson(response.data['content']);
        await authRepo.saveUserResponse(userResponse!);
        authRepo.updateToken(userResponse!.token);

        // Update FCM token after successful login
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await authRepo.updateFCMToken(fcmToken);
        }

        Get.offAllNamed(RouteHelper.getInitialRoute());
        customSnackBar('Logged in successfully'.tr, isError: false);
      } else {
        customSnackBar("Something went wrong");
      }
    } catch (e) {
      customSnackBar(e.toString());
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> logout() async {
    Response? response = await authRepo.logout();

    if (response?.statusCode == 200) {
      await authRepo.clearUserResponse();
      customSnackBar('Logged out successfully', isError: false);
      Get.offAllNamed(RouteHelper.getSignInRoute(''));
    } else {
      customSnackBar("${response?.data['message']}?");
    }
    update();
  }

  assignUser(UserResponse user) {
    userResponse = user;
    update();
  }

  XFile? avatar;

  void updateAvatar(XFile? image) {
    avatar = image;
    update();
  }

  Future<void> register() async {
    isLoading(true);
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();
      final passwordConfirmation = confirmPasswordController.text.trim();
      final username = usernameController.text.trim();
      final website = websiteController.text.trim();
      final bio = bioController.text.trim();
      final location = locationController.text.trim();
      final dateOfBirth = dateOfBirthController.text.trim();
      final deviceName = deviceNameController.text.trim();

      if (name.isEmpty ||
              email.isEmpty ||
              password.isEmpty ||
              passwordConfirmation.isEmpty ||
              username.isEmpty ||
              phone.isEmpty //||
          // website.isEmpty ||
          // bio.isEmpty ||
          // location.isEmpty ||
          // dateOfBirth.isEmpty ||
          // deviceName.isEmpty
          ) {
        customSnackBar('All fields are required');
        return;
      }

      if (password != passwordConfirmation) {
        customSnackBar('Passwords do not match');
        return;
      }

      Map<String, String> body = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'username': username,
        'website': website,
        'bio': bio,
        'location': location,
        'date_of_birth': dateOfBirth,
        'device_name': deviceName,
      };

      List<MultipartBody> multipartBody = [];

      if (avatar != null) {
        multipartBody.add(MultipartBody('avatar', avatar!));
      }

      Response response = await authRepo.register(body, multipartBody);

      if (response.statusCode == 200 &&
          response.data['response_code'] == 'default_200') {
        userResponse = UserResponse.fromJson(response.data['content']);
        await authRepo.saveUserResponse(userResponse!);
        authRepo.updateToken(userResponse!.token);

        Get.offNamed(RouteHelper.getInitialRoute());
        customSnackBar('Registered successfully', isError: false);
      } else {
        customSnackBar(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      customSnackBar(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    websiteController.dispose();
    bioController.dispose();
    locationController.dispose();
    dateOfBirthController.dispose();
    deviceNameController.dispose();
    super.onClose();
  }

  Future<String> getDeviceName() async {
    String deviceName = 'Unknown device';

    try {
      if (kIsWeb) {
        deviceName = 'Web Browser';
      } else if (GetPlatform.isAndroid) {
        deviceName = 'Android Device';
      } else if (GetPlatform.isIOS) {
        deviceName = 'iOS Device';
      } else if (GetPlatform.isWindows) {
        deviceName = 'Windows Device';
      } else if (GetPlatform.isMacOS) {
        deviceName = 'macOS Device';
      } else if (GetPlatform.isLinux) {
        deviceName = 'Linux Device';
      }

      try {
        final packageInfo = await PackageInfo.fromPlatform();
        deviceName += ' (App v${packageInfo.version})';
      } catch (e) {
        printLog('Error getting package info: $e');
      }
    } catch (e) {
      printLog('Error getting device info: $e');
    }

    return deviceName;
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  void clearUserResponse() {
    authRepo.clearUserResponse();
  }

  Future<Response> updateFCMToken(fcmToken) async {
    printLog('FCM TOken: $fcmToken');
    Response response = await authRepo.updateFCMToken(fcmToken);
    return response;
  }
}
