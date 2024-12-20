import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: themeController.isHalloweenTheme.value 
          ? ThemeController.halloweenBackground 
          : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Etiqueerna Dressmaker",
          style: TextStyle(
            color: themeController.isHalloweenTheme.value 
                ? ThemeController.halloweenPrimary 
                : Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: themeController.isHalloweenTheme.value 
            ? ThemeController.halloweenBackground 
            : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined, 
                  color: themeController.isHalloweenTheme.value 
                      ? ThemeController.halloweenPrimary 
                      : Colors.black87,
                  size: 28
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        final user = controller.authController.currentUser.value;
        if (user == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                themeController.isHalloweenTheme.value 
                    ? ThemeController.halloweenPrimary 
                    : Colors.black
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadUserData(),
          color: themeController.isHalloweenTheme.value 
              ? ThemeController.halloweenPrimary 
              : Colors.blue[700],
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(user.username),
                _buildActiveOrderSection(),
                _buildMenuIcons(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSizesSection(),
                      _buildRecentOrdersSection(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Obx(() => BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          backgroundColor: themeController.isHalloweenTheme.value 
              ? ThemeController.halloweenCardBg 
              : Colors.white,
          items: [
            _buildNavBarItem(Icons.home_outlined, Icons.home, 'Home'),
            _buildNavBarItem(Icons.search_outlined, Icons.search, 'Search'),
            _buildNavBarItem(Icons.shopping_bag_outlined, Icons.shopping_bag, 'Orders'),
            _buildNavBarItem(Icons.person_outline, Icons.person, 'Profile'),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: themeController.isHalloweenTheme.value 
              ? ThemeController.halloweenPrimary 
              : Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          onTap: controller.onNavBarTapped,
        )),
      ),
    ));
  }

  Widget _buildWelcomeSection(String username) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: themeController.isHalloweenTheme.value 
              ? [ThemeController.halloweenPrimary, ThemeController.halloweenSecondary]
              : [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeController.isHalloweenTheme.value 
                ? ThemeController.halloweenPrimary.withOpacity(0.3)
                : Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeController.isHalloweenTheme.value 
            ? ThemeController.halloweenCardBg 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(
              "Pesanan Aktif",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: themeController.isHalloweenTheme.value 
                    ? Colors.white 
                    : Colors.black,
              ),
            ),
            trailing: TextButton.icon(
              icon: Icon(Icons.arrow_forward, size: 16),
              label: Text("Lihat Semua"),
              style: TextButton.styleFrom(
                foregroundColor: themeController.isHalloweenTheme.value 
                    ? ThemeController.halloweenPrimary 
                    : Colors.blue[700],
              ),
              onPressed: controller.goToAllOrders,
            ),
          ),
          Obx(() => Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.activeOrder.value.isEmpty
                            ? "Tidak ada pesanan aktif"
                            : controller.activeOrder.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: themeController.isHalloweenTheme.value 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                      if (controller.activeOrder.value.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.isHalloweenTheme.value 
                                ? ThemeController.halloweenAccent.withOpacity(0.2)
                                : Colors.green[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.activeOrderStatus.value,
                            style: TextStyle(
                              color: themeController.isHalloweenTheme.value 
                                  ? ThemeController.halloweenAccent
                                  : Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (controller.activeOrder.value.isNotEmpty)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuIcons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuIcon(Icons.cut_outlined, "Jahit Baju", controller.goToOrder),
          _buildMenuIcon(Icons.calendar_today_outlined, "Jadwal", controller.goToSchedule),
          _buildMenuIcon(Icons.straighten_outlined, "Ukuran", controller.goToMeasurements),
          _buildMenuIcon(Icons.shopping_bag_outlined, "Pesanan", controller.goToAllOrders),
        ],
      ),
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.isHalloweenTheme.value 
                  ? ThemeController.halloweenCardBg 
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: themeController.isHalloweenTheme.value 
                  ? ThemeController.halloweenPrimary 
                  : Colors.blue[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: themeController.isHalloweenTheme.value 
                  ? Colors.white 
                  : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizesSection() {
    return _buildSection(
      title: "Ukuran Saya",
      trailing: "Lihat Semua Ukuran →",
      onTap: controller.goToAllSizes,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSizeBox("Lingkar Dada", controller.userSize.value['Lingkar Dada'] ?? '-'),
                _buildSizeBox("Lingkar Pinggang", controller.userSize.value['Lingkar Pinggang'] ?? '-'),
                _buildSizeBox("Lingkar Pinggul", controller.userSize.value['Lingkar Pinggul'] ?? '-'),
              ],
            )),
      ),
    );
  }

  Widget _buildSizeBox(String label, String size) {
    return Container(
      width: Get.width * 0.27,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: themeController.isHalloweenTheme.value 
            ? ThemeController.halloweenCardBg 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: themeController.isHalloweenTheme.value 
                  ? Colors.white70 
                  : Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            size,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: themeController.isHalloweenTheme.value 
                  ? ThemeController.halloweenPrimary 
                  : Colors.blue[700],
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

  Widget _buildOrderCard(
    String title,
    String id,
    DateTime date,
    String status, {
    bool isCompleted = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeController.isHalloweenTheme.value 
            ? ThemeController.halloweenCardBg 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          "$title #$id",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: themeController.isHalloweenTheme.value 
                ? Colors.white 
                : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              date.toString(),
              style: TextStyle(
                fontSize: 14,
                color: themeController.isHalloweenTheme.value 
                    ? Colors.white70 
                    : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeController.isHalloweenTheme.value 
                        ? (isCompleted 
                            ? ThemeController.halloweenSecondary.withOpacity(0.3)
                            : ThemeController.halloweenAccent.withOpacity(0.2))
                        : (isCompleted 
                            ? Colors.grey[100] 
                            : Colors.green[50]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: themeController.isHalloweenTheme.value 
                          ? (isCompleted 
                              ? Colors.white70
                              : ThemeController.halloweenAccent)
                          : (isCompleted 
                              ? Colors.grey[700] 
                              : Colors.green[700]),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                TextButton.icon(
                  icon: Icon(
                    Icons.visibility_outlined, 
                    size: 16,
                    color: themeController.isHalloweenTheme.value 
                        ? ThemeController.halloweenPrimary 
                        : Colors.blue[700],
                  ),
                  label: Text(
                    "Detail",
                    style: TextStyle(
                      color: themeController.isHalloweenTheme.value 
                          ? ThemeController.halloweenPrimary 
                          : Colors.blue[700],
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () => controller.goToOrderDetails(id),
                ),
              ],
            ),
          ],
        ),
      ),
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
                color: themeController.isHalloweenTheme.value 
                    ? Colors.white 
                    : Colors.black,
              ),
            ),
            if (trailing != null)
              GestureDetector(
                onTap: onTap,
                child: Text(
                  trailing,
                  style: TextStyle(
                    color: themeController.isHalloweenTheme.value 
                        ? ThemeController.halloweenPrimary 
                        : Colors.blue,
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

  BottomNavigationBarItem _buildNavBarItem(IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon, 
        size: 24,
        color: themeController.isHalloweenTheme.value 
            ? Colors.grey[600] 
            : Colors.grey[600],
      ),
      activeIcon: Icon(
        activeIcon, 
        size: 24,
        color: themeController.isHalloweenTheme.value 
            ? ThemeController.halloweenPrimary 
            : Colors.blue[700],
      ),
      label: label,
    );
  }
}