import 'package:get/get.dart';
import '../controllers/measurement_controller.dart';

class MeasurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeasurementController>(
      () => MeasurementController(),
    );
  }
}