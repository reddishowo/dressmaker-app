import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/theme_controller.dart';
import '../controllers/check_order_controller.dart';

class CheckOrderView extends GetView<CheckOrderController> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final isHalloween = themeController.isHalloweenTheme.value;
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: isHalloween ? ThemeController.halloweenPrimary : Color(0xFF1E88E5),
        brightness: isHalloween ? Brightness.dark : Theme.of(context).brightness,
      );

      return Scaffold(
        backgroundColor: isHalloween ? ThemeController.halloweenBackground : colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(colorScheme, isHalloween),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                sliver: Obx(() {
                  if (controller.isLoading.value) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  if (controller.orders.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No orders found',
                          style: TextStyle(
                            color: isHalloween ? Colors.white70 : colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = controller.orders[index];
                        return _buildOrderCard(order, colorScheme, isHalloween);
                      },
                      childCount: controller.orders.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2, // Set to 2 since this is the Orders tab
          onTap: homeController.onNavBarTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isHalloween ? ThemeController.halloweenBackground : colorScheme.surface,
          selectedItemColor: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
          unselectedItemColor: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed('/order'),
          backgroundColor: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
          child: Icon(
            Icons.add,
            color: isHalloween ? Colors.white : colorScheme.onPrimary,
          ),
        ),
      );
    });
  }

  Widget _buildSliverAppBar(ColorScheme colorScheme, bool isHalloween) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      backgroundColor: isHalloween ? ThemeController.halloweenBackground : colorScheme.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 24, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
          ),
          onPressed: () => controller.loadOrders(),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildOrderCard(DocumentSnapshot order, ColorScheme colorScheme, bool isHalloween) {
    final data = order.data() as Map<String, dynamic>;
    final status = data['status'] as String;
    final date = (data['date'] as Timestamp).toDate();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isHalloween ? ThemeController.halloweenCardBg : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isHalloween 
              ? ThemeController.halloweenPrimary.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showOrderDetails(order, colorScheme, isHalloween),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['name'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isHalloween ? Colors.white : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    _buildStatusChip(status, colorScheme, isHalloween),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Order Date: ${_formatDate(date)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Meeting Date: ${_formatDate(data['meetingDate'].toDate())}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (data['notes']?.isNotEmpty ?? false) ...[
                  SizedBox(height: 8),
                  Text(
                    'Notes: ${data['notes']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ColorScheme colorScheme, bool isHalloween) {
    Color chipColor;
    if (isHalloween) {
      chipColor = ThemeController.halloweenPrimary;
    } else {
      switch (status.toLowerCase()) {
        case 'completed':
          chipColor = Colors.green;
          break;
        case 'in progress':
        case 'dalam proses':
          chipColor = Colors.orange;
          break;
        case 'cancelled':
          chipColor = Colors.red;
          break;
        default:
          chipColor = colorScheme.primary;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showOrderDetails(DocumentSnapshot order, ColorScheme colorScheme, bool isHalloween) {
    final data = order.data() as Map<String, dynamic>;
    
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isHalloween ? ThemeController.halloweenCardBg : colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
              ),
            ),
            SizedBox(height: 24),
            _buildDetailRow('Status', data['status'], colorScheme, isHalloween),
            _buildDetailRow('Clothing Type', data['clothingType'], colorScheme, isHalloween),
            _buildDetailRow('Fabric Type', data['fabricType'], colorScheme, isHalloween),
            _buildDetailRow('Meeting Date', _formatDate(data['meetingDate'].toDate()), colorScheme, isHalloween),
            if (data['notes']?.isNotEmpty ?? false)
              _buildDetailRow('Notes', data['notes'], colorScheme, isHalloween),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  'Update Status',
                  Icons.edit,
                  () => _showUpdateStatusDialog(order.id, data['status'], colorScheme, isHalloween),
                  colorScheme,
                  isHalloween,
                ),
                _buildActionButton(
                  'Delete',
                  Icons.delete,
                  () => _showDeleteConfirmation(order.id, colorScheme, isHalloween),
                  colorScheme,
                  isHalloween,
                  isDestructive: true,
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme, bool isHalloween) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
              ),
            ),
          // Lanjutan file check_order_view.dart

          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isHalloween ? Colors.white : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    ColorScheme colorScheme,
    bool isHalloween, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.red
        : (isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary);

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showUpdateStatusDialog(
    String orderId,
    String currentStatus,
    ColorScheme colorScheme,
    bool isHalloween,
  ) {
    final statuses = ['In Progress', 'Completed', 'Cancelled'];
    String selectedStatus = currentStatus;

    Get.dialog(
      AlertDialog(
        backgroundColor: isHalloween ? ThemeController.halloweenCardBg : colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Update Status',
          style: TextStyle(
            color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: statuses.map((status) {
              return RadioListTile<String>(
                title: Text(
                  status,
                  style: TextStyle(
                    color: isHalloween ? Colors.white : colorScheme.onSurface,
                  ),
                ),
                value: status,
                groupValue: selectedStatus,
                activeColor: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
                onChanged: (value) {
                  selectedStatus = value!;
                  controller.updateOrderStatus(orderId, value);
                  Get.back();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    String orderId,
    ColorScheme colorScheme,
    bool isHalloween,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isHalloween ? ThemeController.halloweenCardBg : colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Order',
          style: TextStyle(
            color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this order?',
          style: TextStyle(
            color: isHalloween ? Colors.white : colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteOrder(orderId);
              Get.back();
              Get.back(); // Close bottom sheet
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}