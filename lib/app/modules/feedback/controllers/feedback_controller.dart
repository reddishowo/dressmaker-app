import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/feedback_model.dart';


class FeedbackController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final feedbackTextController = TextEditingController();

  final publicFeedbacks = <FeedbackModel>[].obs;
  final myFeedbacks = <FeedbackModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFeedbacks();
  }

  void _loadFeedbacks() {
    // Load public feedbacks
    firestore
        .collection('feedback')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      publicFeedbacks.value = snapshot.docs
          .map((doc) => FeedbackModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });

    // Load user's feedbacks if logged in
    if (auth.currentUser != null) {
      firestore
          .collection('feedback')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        myFeedbacks.value = snapshot.docs
            .map((doc) => FeedbackModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
      });
    }
  }

  Future<void> addFeedback() async {
    if (feedbackTextController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your feedback');
      return;
    }

    try {
      await firestore.collection('feedback').add({
        'userId': auth.currentUser?.uid ?? 'anonymous',
        'text': feedbackTextController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      feedbackTextController.clear();
      Get.snackbar('Success', 'Feedback submitted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit feedback');
    }
  }

  Future<void> updateFeedback(String id) async {
    if (feedbackTextController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter updated feedback');
      return;
    }

    try {
      await firestore.collection('feedback').doc(id).update({
        'text': feedbackTextController.text,
      });

      feedbackTextController.clear();
      Get.snackbar('Success', 'Feedback updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update feedback');
    }
  }

  Future<void> deleteFeedback(String id) async {
  try {
    await firestore.collection('feedback').doc(id).delete();
    // Refresh the local list after deletion
    myFeedbacks.removeWhere((feedback) => feedback.id == id);
    Get.snackbar('Success', 'Feedback deleted');
  } catch (e) {
    Get.snackbar('Error', 'Failed to delete feedback');
  }
}
}
