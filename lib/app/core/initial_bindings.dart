import 'package:get/get.dart';
import '../data/services/authentication_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register AuthController as permanent binding
    Get.put(AuthController(), permanent: true);
  }
}