// lib/app/modules/account_settings/bindings/account_settings_binding.dart

import 'package:clothing_store/app/modules/account/controllers/account_controller.dart';
import 'package:get/get.dart';

class AccountSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSettingsController>(
      () => AccountSettingsController(),
    );
  }
}