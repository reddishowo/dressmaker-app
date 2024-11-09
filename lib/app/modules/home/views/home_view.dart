import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Etiqueerna Dressmaker",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.authController.currentUser.value;
        if (user == null) return Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(user.username),
              SizedBox(height: 16),

              // Active Order
              _buildActiveOrderSection(),
              SizedBox(height: 24),

              // Menu Icons
              _buildMenuIcons(),
              SizedBox(height: 24),

              // My Sizes
              _buildSizesSection(),
              SizedBox(height: 24),

              // Recent Orders
              _buildRecentOrdersSection(),
              SizedBox(height: 24),

              // Upcoming Schedule
              _buildUpcomingScheduleSection(),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            onTap: controller.onNavBarTapped,
          )),
    );
  }

  Widget _buildWelcomeSection(String username) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150',
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text("Pesanan Aktif"),
            trailing: TextButton(
              child: Text(
                "Lihat Semua",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: controller.goToAllOrders,
            ),
          ),
          Obx(() => ListTile(
                title: Text(controller.activeOrder.value),
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.activeOrderStatus.value,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMenuIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMenuIcon(Icons.cut_outlined, "Jahit Baju", controller.goToOrder),
        _buildMenuIcon(
            Icons.calendar_today_outlined, "Jadwal", controller.goToSchedule),
        _buildMenuIcon(
            Icons.straighten_outlined, "Ukuran", controller.goToMeasurements),
        _buildMenuIcon(
            Icons.shopping_bag_outlined, "Pesanan", controller.goToAllOrders),
      ],
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSizesSection() {
    return _buildSection(
      title: "Ukuran Saya",
      trailing: "Lihat Semua Ukuran >",
      onTap: controller.goToAllSizes,
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeBox("Lingkar Dada",
                  controller.userSize.value['Lingkar Dada'] ?? '-'),
              _buildSizeBox("Lingkar Pinggang",
                  controller.userSize.value['Lingkar Pinggang'] ?? '-'),
              _buildSizeBox("Lingkar Pinggul",
                  controller.userSize.value['Lingkar Pinggul'] ?? '-'),
            ],
          )),
    );
  }

  Widget _buildSizeBox(String label, String size) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            size,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    return _buildSection(
      title: "Pesanan Terakhir",
      child: Obx(() => Column(
            children: controller.recentOrders
                .map((order) => _buildOrderCard(
                      order['name'],
                      order['id'],
                      order['date'].toDate(),
                      order['status'],
                      isCompleted: order['status'] == 'Selesai',
                    ))
                .toList(),
          )),
    );
  }

  Widget _buildOrderCard(String title, String id, DateTime date, String status,
      {bool isCompleted = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text("$title #$id"),
        subtitle: Text(date.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.grey[100] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isCompleted ? Colors.grey : Colors.green,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 8),
            TextButton(
              child: Text(
                "Lihat Detail",
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
              onPressed: () => controller.goToOrderDetails(id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingScheduleSection() {
    return _buildSection(
      title: "Jadwal Mendatang",
      child: Obx(() => Column(
            children: controller.upcomingSchedules
                .map((schedule) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today_outlined),
                        title: Text(schedule['title']),
                        subtitle: Text(
                          "${schedule['date'].toDate().toString()}",
                        ),
                      ),
                    ))
                .toList(),
          )),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    String? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (trailing != null)
              GestureDetector(
                onTap: onTap,
                child: Text(
                  trailing,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }
}
