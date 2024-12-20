import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final RxBool isHalloweenTheme = false.obs;
  
  // Colors for Halloween theme
  static const halloweenPrimary = Color(0xFFFF6B00);  // Pumpkin Orange
  static const halloweenSecondary = Color(0xFF4A154B);  // Deep Purple
  static const halloweenBackground = Color(0xFF1A1A1A);  // Dark Gray
  static const halloweenCardBg = Color(0xFF2D2D2D);  // Lighter Dark Gray
  static const halloweenAccent = Color(0xFF76FF03);  // Toxic Green
  
  // Regular theme colors
  static const regularPrimary = Colors.blue;
  static const regularBackground = Color(0xFFF5F5F5);
  static const regularCardBg = Colors.white;
  
  ThemeData get currentTheme => isHalloweenTheme.value ? halloweenTheme : regularTheme;
  
  final ThemeData halloweenTheme = ThemeData(
    primaryColor: halloweenPrimary,
    scaffoldBackgroundColor: halloweenBackground,
    cardColor: halloweenCardBg,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: halloweenCardBg,
      selectedItemColor: halloweenPrimary,
      unselectedItemColor: Colors.grey[600],
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: halloweenBackground,
      foregroundColor: halloweenPrimary,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: halloweenPrimary),
    ),
    iconTheme: IconThemeData(
      color: halloweenPrimary,
    ),
  );
  
  final ThemeData regularTheme = ThemeData(
    primaryColor: regularPrimary,
    scaffoldBackgroundColor: regularBackground,
    cardColor: regularCardBg,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: regularCardBg,
      selectedItemColor: regularPrimary,
      unselectedItemColor: Colors.grey[600],
    ),
  );
  
  void toggleTheme() {
    isHalloweenTheme.value = !isHalloweenTheme.value;
    Get.changeTheme(currentTheme);
  }
}