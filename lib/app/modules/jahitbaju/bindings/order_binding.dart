// order_binding.dart
import 'package:clothing_store/app/modules/jahitbaju/controllers/order_controller.dart';
import 'package:get/get.dart';


class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
