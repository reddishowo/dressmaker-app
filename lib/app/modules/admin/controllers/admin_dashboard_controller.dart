import 'package:clothing_store/app/data/models/measurement_model.dart';
import 'package:clothing_store/app/data/models/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../data/services/authentication_controller.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  final RxInt totalUsers = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> recentUsers = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recentOrders = <Map<String, dynamic>>[].obs;
  final RxList<FeedbackModel> recentFeedback = <FeedbackModel>[].obs;
  final RxMap<String, List<Map<String, dynamic>>> userOrders = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (!_authController.isAdmin()) {
      Get.offAllNamed('/home');
      return;
    }
    loadDashboardData();
  }

  Future<MeasurementModel?> getUserMeasurement(String userId) async {
    try {
      print('Fetching measurements for userId: $userId');

      final sizeDoc = await _firestore.collection('measurements').doc(userId).get();

      if (!sizeDoc.exists) {
        print('No measurements found for userId: $userId');
        return null;
      }

      final data = sizeDoc.data();
      if (data == null || data.isEmpty) {
        print('Measurement data is empty for userId: $userId');
        return null;
      }
      print('Measurement data retrieved: $data');

      return MeasurementModel.fromMap(data, sizeDoc.id);
    } catch (e) {
      print('Error fetching measurement for userId: $userId. Error: $e');
      return null;
    }
  }

  void showMeasurementDialog(String userId, String username) async {
    try {
      Get.dialog(
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final measurement = await getUserMeasurement(userId);
      Get.back(); // Close loading dialog

      if (measurement != null) {
        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.straighten, color: Colors.blue),
                const SizedBox(width: 8),
                Text('$username\'s Measurements'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMeasurementRow('Shoulder Width', measurement.shoulderWidth),
                  _buildMeasurementRow('Chest', measurement.chest),
                  _buildMeasurementRow('Waist', measurement.waist),
                  _buildMeasurementRow('Hip', measurement.hip),
                  _buildMeasurementRow('Sleeve Length', measurement.sleeveLength),
                  _buildMeasurementRow('Arm Circumference', measurement.armCircumference),
                  _buildMeasurementRow('Body Length', measurement.bodyLength),
                  _buildMeasurementRow('Neck Circumference', measurement.neckCircumference),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.update, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Last Updated: ${DateFormat('MMM d, y').format(measurement.lastUpdated)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'No Measurements',
          'No measurement data available for $username',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning, color: Colors.white),
        );
      }
    } catch (e) {
      print('Error in showMeasurementDialog: $e');
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Error',
        'Failed to load measurements: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Widget _buildMeasurementRow(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${value.toStringAsFixed(1)} cm',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadUserStatistics(),
        loadAllUserOrders(),
        loadRecentFeedback(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserStatistics() async {
    // Fetch total users
    final usersSnapshot = await _firestore.collection('users').get();
    totalUsers.value = usersSnapshot.docs.length;

    // Fetch recent users
    final recentUsersSnapshot = await _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .get();

    recentUsers.value = recentUsersSnapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
              'createdAt': (doc.data()['createdAt'] as Timestamp).toDate(),
            })
        .toList();
  }

  Future<void> loadAllUserOrders() async {
    // Clear existing orders
    userOrders.clear();
    totalOrders.value = 0;
    totalRevenue.value = 0;

    // Get all users
    final usersSnapshot = await _firestore.collection('users').get();

    // For each user, fetch their orders
    for (var userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final userData = userDoc.data();

      // Fetch orders for this user
      final userOrdersSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('date', descending: true)
          .get();

      if (userOrdersSnapshot.docs.isNotEmpty) {
        final ordersList = userOrdersSnapshot.docs.map((orderDoc) {
          final orderData = orderDoc.data();
          return {
            'id': orderDoc.id,
            ...orderData,
            'date': (orderData['date'] as Timestamp).toDate(),
            'userName': userData['username'] ?? 'Unknown User',
            'userEmail': userData['email'] ?? 'No Email',
          };
        }).toList();

        userOrders[userId] = ordersList;
        totalOrders.value += ordersList.length;

        // Update total revenue
        for (var order in ordersList) {
          totalRevenue.value += (order['total'] ?? 0).toDouble();
        }
      }
    }

    // Update recent orders list
    final allOrders = userOrders.values.expand((orders) => orders).toList()
      ..sort((a, b) => b['date'].compareTo(a['date']));

    recentOrders.value = allOrders.take(5).toList();
  }

  Future<void> loadRecentFeedback() async {
    try {
      final feedbackSnapshot = await _firestore
          .collection('feedback')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      recentFeedback.value = feedbackSnapshot.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading feedback: $e');
      Get.snackbar(
        'Error',
        'Failed to load feedback data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      // Show confirmation dialog
      final bool confirm = await Get.dialog(
        AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this feedback? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (!confirm) return;

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Delete the feedback from Firestore
      await _firestore.collection('feedback').doc(feedbackId).delete();

      // Remove the feedback from local state
      recentFeedback.removeWhere((feedback) => feedback.id == feedbackId);

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Feedback deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to delete feedback: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> respondToFeedback(String feedbackId, String response) async {
    try {
      await _firestore.collection('feedback').doc(feedbackId).update({
        'adminResponse': response,
        'respondedAt': Timestamp.now(),
      });

      // Update local state
      final index = recentFeedback.indexWhere((feedback) => feedback.id == feedbackId);
      if (index != -1) {
        final updatedFeedback = recentFeedback[index].copyWith(
          adminResponse: response,
          respondedAt: DateTime.now(),
        );
        recentFeedback[index] = updatedFeedback;
      }

      Get.snackbar(
        'Success',
        'Response sent successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send response: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  Future<void> deleteOrder(String userId, String orderId) async {
    try {
      // Show confirmation dialog
      final bool confirm = await Get.dialog(
        AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this order? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (!confirm) return;

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Delete the order from Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .delete();

      // Remove the order from local state
      if (userOrders.containsKey(userId)) {
        userOrders[userId]?.removeWhere((order) => order['id'] == orderId);

        // If this user has no more orders, remove them from userOrders
        if (userOrders[userId]?.isEmpty ?? true) {
          userOrders.remove(userId);
        }

        // Update total orders count
        totalOrders.value--;

        // Update total revenue
        final deletedOrder = userOrders[userId]?.firstWhere(
          (order) => order['id'] == orderId,
          orElse: () => {},
        );
        if (deletedOrder != null && deletedOrder['total'] != null) {
          totalRevenue.value -= deletedOrder['total'].toDouble();
        }
      }

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Order deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false
      ) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to delete order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Show feedback detail dialog
  void showFeedbackDetailDialog(FeedbackModel feedback) {
    final TextEditingController responseController = TextEditingController();
    responseController.text = feedback.adminResponse ?? '';

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.feedback, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Feedback Detail'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From User: ${feedback.userId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Submitted: ${DateFormat('MMM d, y HH:mm').format(feedback.createdAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const Divider(),
              const Text(
                'Feedback:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(feedback.text),
              const Divider(),
              const Text(
                'Admin Response:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: responseController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your response here...',
                  border: OutlineInputBorder(),
                ),
              ),
              if (feedback.adminResponse != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Last Response: ${DateFormat('MMM d, y HH:mm').format(feedback.respondedAt ?? DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => deleteFeedback(feedback.id),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (responseController.text.trim().isNotEmpty) {
                respondToFeedback(feedback.id, responseController.text.trim());
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter a response',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Send Response'),
          ),
        ],
      ),
    );
  }

  void showFeedbackListDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.feedback, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Recent Feedback'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (recentFeedback.isEmpty) {
              return const Center(
                child: Text('No feedback available'),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: recentFeedback.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final feedback = recentFeedback[index];
                return ListTile(
                  title: Text(
                    feedback.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'From: ${feedback.userId}\n${DateFormat('MMM d, y').format(feedback.createdAt)}',
                  ),
                  trailing: feedback.adminResponse != null
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.pending, color: Colors.orange),
                  onTap: () {
                    Get.back();
                    showFeedbackDetailDialog(feedback);
                  },
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          TextButton.icon(
            onPressed: () {
              Get.back();
              loadRecentFeedback();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}