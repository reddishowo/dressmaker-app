// lib/app/modules/admin/bindings/admin_dashboard_binding.dart

import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
    );
  }
}