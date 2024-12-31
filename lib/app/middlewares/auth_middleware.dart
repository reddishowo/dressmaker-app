// lib/app/middlewares/auth_middleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/authentication_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is not logged in, redirect to login
    if (authController.currentUser.value == null) {
      return const RouteSettings(name: '/login');
    }
    
    // If trying to access admin route but not admin, redirect to home
    if (route?.startsWith('/admin') == true && !authController.isAdmin()) {
      return const RouteSettings(name: '/home');
    }
    
    return null;
  }
}