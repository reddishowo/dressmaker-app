import 'package:clothing_store/app/modules/intro/controllers/introcontroller.dart';
import 'package:get/get.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(
      () => IntroController(),
    );
  }
}
