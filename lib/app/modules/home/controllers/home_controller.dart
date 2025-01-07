import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/authentication_controller.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final Rx<String> activeOrder = ''.obs;
  final Rx<String> activeOrderStatus = ''.obs;
  final Rx<Map<String, String>> userSize = Rx<Map<String, String>>({});
  final RxList<Map<String, dynamic>> recentOrders =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> upcomingSchedules =
      <Map<String, dynamic>>[].obs;
  final RxInt selectedIndex = 0.obs;
  final RxMap<String, String> allMeasurements = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (authController.currentUser.value != null) {
      String userId = authController.currentUser.value!.id;
      await Future.wait([
        _loadActiveOrder(userId),
        _loadUserSizes(userId),
        _loadRecentOrders(userId),
        _loadUpcomingSchedules(userId),
      ]);
    }
  }

  Future<void> _loadActiveOrder(String userId) async {
    try {
      final activeOrderDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .where('status', isEqualTo: 'Dalam Proses')
          .limit(1)
          .get();
      if (activeOrderDoc.docs.isNotEmpty) {
        activeOrder.value = activeOrderDoc.docs.first.data()['name'] ?? '';
        activeOrderStatus.value =
            activeOrderDoc.docs.first.data()['status'] ?? '';
      }
    } catch (e) {
      print('Error loading active order: $e');
    }
  }

  Future<void> _loadUserSizes(String userId) async {
    try {
      final sizeDoc =
          await _firestore.collection('measurements').doc(userId).get();

      if (sizeDoc.exists) {
        // Store all measurements
        Map<String, dynamic> data = sizeDoc.data() ?? {};
        allMeasurements.value = {
          'Lebar Bahu': '${data['shoulderWidth'] ?? '-'} cm',
          'Lingkar Dada': '${data['chest'] ?? '-'} cm',
          'Lingkar Pinggang': '${data['waist'] ?? '-'} cm',
          'Lingkar Pinggul': '${data['hip'] ?? '-'} cm',
          'Panjang Lengan': '${data['sleeveLength'] ?? '-'} cm',
          'Lingkar Lengan': '${data['armCircumference'] ?? '-'} cm',
          'Panjang Badan': '${data['bodyLength'] ?? '-'} cm',
          'Lingkar Leher': '${data['neckCircumference'] ?? '-'} cm',
        };

        // Update the user size for display in the main view
        userSize.value = {
          'Lingkar Dada': '${data['chest'] ?? '-'} cm',
          'Lingkar Pinggang': '${data['waist'] ?? '-'} cm',
          'Lingkar Pinggul': '${data['hip'] ?? '-'} cm',
        };
      }
    } catch (e) {
      print('Error loading user sizes: $e');
    }
  }

  Future<void> _loadRecentOrders(String userId) async {
    try {
      final ordersQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('date', descending: true)
          .limit(5)
          .get();
      recentOrders.value = ordersQuery.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading recent orders: $e');
    }
  }

  Future<void> _loadUpcomingSchedules(String userId) async {
    try {
      final schedulesQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .where('date', isGreaterThan: DateTime.now())
          .orderBy('date')
          .limit(3)
          .get();
      upcomingSchedules.value =
          schedulesQuery.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading schedules: $e');
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

  // Navigation methods
  void goToAllOrders() {
    Get.toNamed('/check');
  }

  void goToOrder() {
    Get.toNamed('/jahitbaju');
  }

  void goToAllSizes() {
    Get.toNamed('/sizes');
  }

  void goToMeasurements() {
    Get.toNamed('/measurements');
  }

  void goToOrderDetails(String orderId) {
    Get.toNamed('/order-details/$orderId');
  }

  void showAllSizesModal() {
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Obx(() => Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.85),
              decoration: BoxDecoration(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenCardBg
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeController.isHalloweenTheme.value
                          ? ThemeController.halloweenBackground
                          : Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.straighten,
                              size: 28,
                              color: themeController.isHalloweenTheme.value
                                  ? ThemeController.halloweenPrimary
                                  : Colors.blue[700],
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Semua Ukuran',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeController.isHalloweenTheme.value
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: themeController.isHalloweenTheme.value
                                ? Colors.white70
                                : Colors.black54,
                            size: 24,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: allMeasurements.entries.map((entry) {
                          return Container(
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              color: themeController.isHalloweenTheme.value
                                  ? ThemeController.halloweenBackground
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: themeController.isHalloweenTheme.value
                                    ? ThemeController.halloweenPrimary
                                        .withOpacity(0.2)
                                    : Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                if (themeController.isHalloweenTheme.value)
                                  Positioned(
                                    right: -10,
                                    top: -10,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: ThemeController.halloweenPrimary
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeController
                                                  .isHalloweenTheme.value
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            entry.value,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: themeController
                                                      .isHalloweenTheme.value
                                                  ? ThemeController
                                                      .halloweenPrimary
                                                  : Colors.blue[700],
                                            ),
                                          ),
                                          Text(
                                            ' cm',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: themeController
                                                      .isHalloweenTheme.value
                                                  ? Colors.white70
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Footer
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeController.isHalloweenTheme.value
                          ? ThemeController.halloweenBackground
                          : Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.edit_outlined),
                            label: Text(
                              'Ubah Ukuran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  themeController.isHalloweenTheme.value
                                      ? ThemeController.halloweenPrimary
                                      : Colors.blue[700],
                              elevation: 2,
                              shadowColor:
                                  themeController.isHalloweenTheme.value
                                      ? ThemeController.halloweenPrimary
                                          .withOpacity(0.4)
                                      : Colors.blue.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                              goToMeasurements();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
      barrierColor: themeController.isHalloweenTheme.value
          ? Colors.black87
          : Colors.black54,
    );
  }
}
