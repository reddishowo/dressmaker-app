import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/authentication_controller.dart';
import '../../../data/models/profile_model.dart'; // Tambahkan import ini

class CheckOrderController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final orders = <DocumentSnapshot>[].obs;
  final isLoading = true.obs;
  final RxInt selectedIndex = 2.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      
      // Pastikan user sudah login
      ProfileModel? currentUser = authController.currentUser.value;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final QuerySnapshot orderSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('orders')
          .orderBy('date', descending: true)
          .get();

      orders.value = orderSnapshot.docs;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load orders: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      ProfileModel? currentUser = authController.currentUser.value;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      // Delete order document
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('orders')
          .doc(orderId)
          .delete();

      // Delete associated schedule
      final QuerySnapshot scheduleSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('schedules')
          .where('orderId', isEqualTo: orderId)
          .get();

      for (var doc in scheduleSnapshot.docs) {
        await doc.reference.delete();
      }

      // Refresh orders list
      await loadOrders();

      Get.snackbar(
        "Success",
        "Order deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete order: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      ProfileModel? currentUser = authController.currentUser.value;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});

      await loadOrders();

      Get.snackbar(
        "Success",
        "Order status updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update order status: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void onNavBarTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0: // Home
        Get.offAllNamed('/home');
        break;
      case 1: // Search
         Get.toNamed('/search');
        break;
      case 2: // Orders
        Get.offAllNamed('/check');
        break;
      case 3: // Profile
        Get.offAllNamed('/profile');
        break;
    }
  }
}