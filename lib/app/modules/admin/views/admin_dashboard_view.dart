import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../data/services/authentication_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      // Wrap the entire body in a SafeArea widget
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: controller.refreshData,
                  child: CustomScrollView(
                    // Use CustomScrollView with SliverList for better performance
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildStatisticsSection(),
                            const SizedBox(height: 24),
                            _buildRecentFeedbackSection(),
                            const SizedBox(height: 24),
                            _buildRecentUsersSection(),
                            const SizedBox(height: 24),
                            _buildAllUsersOrdersSection(),
                            // Add bottom padding to prevent overflow
                            const SizedBox(height: 32),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Ganti GridView dengan Row untuk layout yang lebih fleksibel
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    '${controller.totalUsers}',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    '${controller.totalOrders}',
                    Icons.shopping_bag,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Feedback',
                    '${controller.recentFeedback.length}',
                    Icons.feedback,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );  
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),  // Kurangi padding horizontal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),  // Kurangi ukuran icon
          const SizedBox(height: 8),  // Kurangi spacing
          Text(
            title,
            style: TextStyle(
              fontSize: 12,  // Kurangi ukuran font
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),  // Kurangi spacing
          Text(
            value,
            style: TextStyle(
              fontSize: 20,  // Kurangi ukuran font
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: controller.showFeedbackListDialog,
              icon: const Icon(Icons.list),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Obx(() {
            if (controller.recentFeedback.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No feedback available'),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 3, // Show only 3 most recent feedback
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index >= controller.recentFeedback.length) {
                  return const SizedBox.shrink();
                }
                
                final feedback = controller.recentFeedback[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: feedback.adminResponse != null ? Colors.green : Colors.orange,
                    child: Icon(
                      feedback.adminResponse != null ? Icons.check : Icons.pending,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    feedback.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${DateFormat('MMM d, y').format(feedback.createdAt)}\nFrom: ${feedback.userId}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => controller.showFeedbackDetailDialog(feedback),
                  ),
                  onTap: () => controller.showFeedbackDetailDialog(feedback),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Users',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed('/admin/users');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: controller.recentUsers.length,
            itemBuilder: (context, index) {
              final user = controller.recentUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    (user['username'] as String)[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user['username'] ?? 'Unknown User'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['email'] ?? 'No email'),
                    Text(
                      'Joined: ${DateFormat('MMM d, y').format(user['createdAt'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.toNamed('/admin/user-details', arguments: user);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllUsersOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All User Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: 'all',
              items: const [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All Orders'),
                ),
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {
                // Implement filter functionality
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...controller.userOrders.entries.map((entry) {
          final userId = entry.key;
          final orders = entry.value;
          if (orders.isEmpty) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        orders.first['userName'] ?? 'Unknown User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${orders.length} orders',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(orders.first['userEmail'] ?? 'No Email'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      (orders.first['userName'] as String)[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.straighten, color: Colors.blue),
                        tooltip: 'View Measurements',
                        onPressed: () => controller.showMeasurementDialog(
                          userId,
                          orders.first['userName'] ?? 'Unknown User',
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => controller.showMeasurementDialog(
                    userId,
                    orders.first['userName'] ?? 'Unknown User',
                  ),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Dismissible(
                      key: Key(order['id']),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this order? This action cannot be undone.',
                            ),
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
                        ) ?? false;
                      },
                      onDismissed: (direction) {
                        controller.deleteOrder(userId, order['id']);
                      },
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          order['name'] ?? 'Unnamed Order',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildStatusChip(order['status']),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('MMM d, y').format(order['date']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            if (order['notes'] != null && order['notes'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  order['notes'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,children: [
                                if (order['total'] != null)
                                  Text(
                                    '\$${order['total'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  '${order['clothingType'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteOrder(userId, order['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        break;
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        break;
      case 'dalam proses':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[900]!;
        break;
      case 'cancelled':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[900]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),  
    );
  }
}