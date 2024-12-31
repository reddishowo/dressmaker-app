import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../controllers/check_order_controller.dart';

class CheckOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckOrderController>(
      () => CheckOrderController(),
    );
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
