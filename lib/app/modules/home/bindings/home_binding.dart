import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
        Get.lazyPut<ThemeController>(() => ThemeController());

  }
}
