import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive_flutter/adapters.dart';
import 'package:navy/controllers/theme_controller.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/services/notification_service.dart';

import 'bindings/initial_binding.dart';
import 'core/helpers/dependency_injection.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

void registerAdapters() {
  Hive.registerAdapter(UserResponseAdapter());
  Hive.registerAdapter(UserAdapter());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerAdapters();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DependencyInjection.initialize();

  if (!GetPlatform.isWindows) {
    await Get.find<NotificationService>().initialize();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NAVY',
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          getPages: RouteHelper.routes,
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
          initialBinding: InitialBinding(),
          initialRoute: RouteHelper.initial,
          themeMode: themeController.themeMode,
          theme: AppTheme.light(context),
          darkTheme: AppTheme.dark(context),
          onInit: () async {
            await Future.delayed(
              const Duration(seconds: 1),
              () => Get.find<NotificationService>().handlePendingNotification(),
            );
          },
        );
      },
    );
  }
}
