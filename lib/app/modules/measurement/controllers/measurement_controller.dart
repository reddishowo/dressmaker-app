import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/measurement_model.dart';
import '../../../data/services/authentication_controller.dart';

class MeasurementController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Text editing controllers
  final shoulderController = TextEditingController();
  final chestController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final sleeveController = TextEditingController();
  final armController = TextEditingController();
  final bodyController = TextEditingController();
  final neckController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final Rx<MeasurementModel?> currentMeasurement = Rx<MeasurementModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMeasurements();
  }

  // Load user's measurements
  Future<void> loadMeasurements() async {
    if (authController.currentUser.value?.id == null) return;

    try {
      isLoading.value = true;
      final doc = await _firestore
          .collection('measurements')
          .doc(authController.currentUser.value!.id)
          .get();

      if (doc.exists) {
        currentMeasurement.value = MeasurementModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        _populateControllers();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load measurements: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Populate text controllers with current measurements
  void _populateControllers() {
    if (currentMeasurement.value != null) {
      shoulderController.text = currentMeasurement.value!.shoulderWidth.toString();
      chestController.text = currentMeasurement.value!.chest.toString();
      waistController.text = currentMeasurement.value!.waist.toString();
      hipController.text = currentMeasurement.value!.hip.toString();
      sleeveController.text = currentMeasurement.value!.sleeveLength.toString();
      armController.text = currentMeasurement.value!.armCircumference.toString();
      bodyController.text = currentMeasurement.value!.bodyLength.toString();
      neckController.text = currentMeasurement.value!.neckCircumference.toString();
    }
  }

  // Save or update measurements
  Future<void> saveMeasurements() async {
    if (authController.currentUser.value?.id == null) return;

    try {
      isLoading.value = true;

      final measurements = MeasurementModel(
        id: authController.currentUser.value!.id,
        userId: authController.currentUser.value!.id,
        shoulderWidth: double.parse(shoulderController.text),
        chest: double.parse(chestController.text),
        waist: double.parse(waistController.text),
        hip: double.parse(hipController.text),
        sleeveLength: double.parse(sleeveController.text),
        armCircumference: double.parse(armController.text),
        bodyLength: double.parse(bodyController.text),
        neckCircumference: double.parse(neckController.text),
        lastUpdated: DateTime.now(),
      );

      await _firestore
          .collection('measurements')
          .doc(authController.currentUser.value!.id)
          .set(measurements.toMap());

      currentMeasurement.value = measurements;

      Get.snackbar(
        "Success",
        "Measurements saved successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save measurements: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    shoulderController.dispose();
    chestController.dispose();
    waistController.dispose();
    hipController.dispose();
    sleeveController.dispose();
    armController.dispose();
    bodyController.dispose();
    neckController.dispose();
    super.onClose();
  }
}
