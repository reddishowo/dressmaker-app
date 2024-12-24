// lib/app/modules/account_settings/controllers/account_settings_controller.dart

import 'package:clothing_store/app/data/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:clothing_store/app/data/services/authentication_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  
  final isLoading = false.obs;
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    final currentUser = authController.currentUser.value;
    if (currentUser != null) {
      usernameController.text = currentUser.username;
      phoneController.text = currentUser.phone;
    }
  }

  Future<void> updateProfile() async {
    if (!isEditing.value) {
      isEditing.value = true;
      return;
    }

    if (usernameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final userId = authController.currentUser.value?.id;

      if (userId == null) {
        throw Exception('User not found');
      }

      await _firestore.collection('users').doc(userId).update({
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
      });

      // Refresh user data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        authController.currentUser.value = ProfileModel.fromMap(
          userDoc.data() as Map<String, dynamic>,
          userDoc.id,
        );
      }

      isEditing.value = false;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}