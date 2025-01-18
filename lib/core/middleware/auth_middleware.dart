import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/authentication/controller/auth_controller.dart';

import '../helpers/route_helper.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    // If the user is not logged in and the route is not public, redirect to login
    if (!authController.isLoggedIn() && !isPublicRoute(route)) {
      return RouteSettings(name: RouteHelper.getSignInRoute(''));
    }
    return null;
  }

  bool isPublicRoute(String? route) {
    List<String> publicRoutes = [RouteHelper.signIn, RouteHelper.register];
    return publicRoutes.contains(route);
  }
}
