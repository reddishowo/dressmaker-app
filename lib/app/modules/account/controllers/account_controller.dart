import 'dart:io';
import 'package:clothing_store/app/data/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:clothing_store/app/data/services/authentication_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final isEditing = false.obs;

  File? profileImage;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadProfileImage();
  }

  void _initializeControllers() {
    final currentUser = authController.currentUser.value;
    if (currentUser != null) {
      usernameController.text = currentUser.username;
      phoneController.text = currentUser.phone;
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      profileImage = File(imagePath);
      update();
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = pickedFile.name;
        final localImagePath = '${directory.path}/$fileName';

        // Save the image locally
        final File localImage = File(pickedFile.path);
        final savedImage = await localImage.copy(localImagePath);

        // Update local reference
        profileImage = savedImage;

        // Save path to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('profileImagePath', savedImage.path);

        update(); // Update UI
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

      // Update Firestore
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

      // Save success message
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
        'Failed to update profile: $e',
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
