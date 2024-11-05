// File 2: /lib/app/modules/intro/controllers/introcontroller.dart

import 'package:get/get.dart';

class IntroController extends GetxController {
  // Method to navigate to the Register Page
  void goToRegister() {
    Get.toNamed('/register'); // Make sure the route is defined in AppRoutes
  }
}
