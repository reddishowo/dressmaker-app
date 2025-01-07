import 'package:get/get.dart';
import '../controllers/payment_controller.dart';
class PaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}