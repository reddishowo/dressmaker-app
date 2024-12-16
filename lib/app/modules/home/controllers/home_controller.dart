import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/services/authentication_controller.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final Rx<String> activeOrder = ''.obs;
  final Rx<String> activeOrderStatus = ''.obs;
  final Rx<Map<String, String>> userSize = Rx<Map<String, String>>({});
  final RxList<Map<String, dynamic>> recentOrders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> upcomingSchedules = <Map<String, dynamic>>[].obs;
  final RxInt selectedIndex = 0.obs;

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
        activeOrderStatus.value = activeOrderDoc.docs.first.data()['status'] ?? '';
      }
    } catch (e) {
      print('Error loading active order: $e');
    }
  }

  Future<void> _loadUserSizes(String userId) async {
    try {
      final sizeDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('measurements')
          .doc('current')
          .get();
      if (sizeDoc.exists) {
        userSize.value = Map<String, String>.from(sizeDoc.data() ?? {});
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
      upcomingSchedules.value = schedulesQuery.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading schedules: $e');
    }
  }

  void onNavBarTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0: // Home
        break;
      case 1: // Search
        // Get.toNamed('/search');
        break;
      case 2: // Orders
        // Get.toNamed('/orders');
        break;
      case 3: // Profile
        Get.toNamed('/profile');
        break;
    }
  }

  // Navigation methods
  void goToAllOrders() {
    // Get.toNamed('/orders');
  }

  void goToOrder() {
    Get.toNamed('/jahitbaju');
  }

  void goToAllSizes() {
    // Get.toNamed('/sizes');
  }

  void goToSchedule() {
    // Get.toNamed('/schedule');
  }

  void goToMeasurements() {
    // Get.toNamed('/measurements');
  }

  void goToOrderDetails(String orderId) {
    // Get.toNamed('/order-details/$orderId');
  }
}