import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields in registration
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Method to handle registration
  Future<void> register() async {
    try {
      // Sign up with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Prepare profile data
      final profile = ProfileModel(
        id: userCredential.user!.uid,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Save profile to Firestore
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toMap());

      // Success message or redirection
      Get.snackbar("Success", "Registration successful!");
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e");
    }
  }

  // Method for Google Sign-In (placeholder for actual implementation)
  Future<void> signInWithGoogle() async {
    try {
      // Implement Google Sign-In here
      // Example: final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      Get.snackbar("Google Sign-In", "Google Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed: $e");
    }
  }

  // Method for Facebook Sign-In (placeholder for actual implementation)
  Future<void> signInWithFacebook() async {
    try {
      // Implement Facebook Sign-In here
      Get.snackbar("Facebook Sign-In", "Facebook Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Facebook Sign-In failed: $e");
    }
  }

  // Method for Apple Sign-In (placeholder for actual implementation)
  Future<void> signInWithApple() async {
    try {
      // Implement Apple Sign-In here
      Get.snackbar("Apple Sign-In", "Apple Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Apple Sign-In failed: $e");
    }
  }

  // Dispose controllers on close
  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
