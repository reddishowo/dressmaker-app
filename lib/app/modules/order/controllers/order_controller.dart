import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/authentication_controller.dart';
import '../../home/controllers/home_controller.dart';

class OrderController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var selectedClothingType = ''.obs;
  var selectedFabricType = ''.obs;
  var meetingDate = DateTime.now().obs;
  var isDelivery = false.obs;

  TextEditingController additionalNotesController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();

  void setClothingType(String type) {
    selectedClothingType.value = type;
  }

  void setFabricType(String type) {
    selectedFabricType.value = type;
  }

  void setMeetingDate(DateTime date) {
    meetingDate.value = date;
  }

  void setDelivery(bool value) {
    isDelivery.value = value;
  }

  Future<void> submitOrder() async {
    try {
      if (authController.currentUser.value == null) {
        Get.snackbar(
          "Error",
          "Please login first",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (selectedClothingType.isEmpty || selectedFabricType.isEmpty) {
        Get.snackbar(
          "Error",
          "Please select clothing and fabric type",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (isDelivery.value && deliveryAddressController.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter a delivery address",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final String userId = authController.currentUser.value!.id;
      final String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create order data
      final orderData = {
        'id': orderId,
        'name': '${selectedClothingType.value} - ${selectedFabricType.value}',
        'clothingType': selectedClothingType.value,
        'fabricType': selectedFabricType.value,
        'meetingDate': meetingDate.value,
        'notes': additionalNotesController.text,
        'delivery': isDelivery.value,
        'deliveryAddress': isDelivery.value ? deliveryAddressController.text : null,
        'status': 'Dalam Proses',
        'date': FieldValue.serverTimestamp(),
        'userId': userId,
      };

      // Save order to Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      // Create schedule for the meeting
      final scheduleData = {
        'title': 'Fitting - ${selectedClothingType.value}',
        'date': meetingDate.value,
        'orderId': orderId,
        'type': 'fitting',
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .add(scheduleData);

      // Reset form
      selectedClothingType.value = '';
      selectedFabricType.value = '';
      meetingDate.value = DateTime.now();
      additionalNotesController.clear();
      deliveryAddressController.clear();
      isDelivery.value = false;

      // Show success message
      Get.snackbar(
        "Success",
        "Order submitted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh home view data
      final homeController = Get.find<HomeController>();
      homeController.loadUserData();

      // Navigate back to home
      Get.offNamed('/payment');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit order: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    additionalNotesController.dispose();
    deliveryAddressController.dispose();
    super.onClose();
  }
}