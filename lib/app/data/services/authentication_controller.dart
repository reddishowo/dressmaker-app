import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final Rx<ProfileModel?> currentUser = Rx<ProfileModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    ever(currentUser, handleInitialScreen);
    _setupAuthListener();
  }

  // Setup auth listener to handle user state
  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // Fetch user profile from Firestore
        try {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            currentUser.value = ProfileModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }
        } catch (e) {
          print('Error fetching user profile: $e');
          currentUser.value = null;
        }
      } else {
        currentUser.value = null;
      }
    });
  }

  // Handle initial screen based on auth state
  void handleInitialScreen(ProfileModel? user) {
    if (user != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  // Method to handle login
  Future<void> login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Attempt to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      // Fetch user profile from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (doc.exists) {
        currentUser.value = ProfileModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        
        // Clear controllers
        loginEmailController.clear();
        loginPasswordController.clear();

        Get.snackbar(
          "Success",
          "Welcome back, ${currentUser.value?.username}!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login failed: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle registration
  Future<void> register() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Create user in Firebase Auth
      final UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Create ProfileModel instance
      final profile = ProfileModel(
        id: userCredential.user!.uid,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Save user profile to Firestore
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toMap());

      // Update current user
      currentUser.value = profile;

      // Clear controllers
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();

      Get.snackbar(
        "Success",
        "Welcome, ${profile.username}!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Registration failed: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Logout failed: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get current user profile
  ProfileModel? getCurrentUser() {
    return currentUser.value;
  }

  // Social login methods remain the same...
  Future<void> signInWithGoogle() async {
    try {
      Get.snackbar("Google Sign-In", "Google Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed: $e");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      Get.snackbar(
          "Facebook Sign-In", "Facebook Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Facebook Sign-In failed: $e");
    }
  }

  Future<void> signInWithApple() async {
    try {
      Get.snackbar("Apple Sign-In", "Apple Sign-In is under development.");
    } catch (e) {
      Get.snackbar("Error", "Apple Sign-In failed: $e");
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
