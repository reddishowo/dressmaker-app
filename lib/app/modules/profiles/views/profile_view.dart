import 'package:clothing_store/app/data/services/authentication_controller.dart';
import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: themeController.currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                themeController.currentTheme.appBarTheme.backgroundColor,
            title: Text(
              'Profil',
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenPrimary
                      : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Card
                  Card(
                    elevation: 0,
                    color: themeController.currentTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              authController.currentUser.value?.username
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  'U',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authController.currentUser.value?.username ??
                                      'Username',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        themeController.isHalloweenTheme.value
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  authController.currentUser.value?.email ??
                                      'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        themeController.isHalloweenTheme.value
                                            ? Colors.white70
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Menu Items Card
                  Card(
                    elevation: 0,
                    color: themeController.currentTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Akun Anda',
                          subtitle: 'Buat perubahan pada akun anda',
                          onTap: () {
                            // Navigate to account settings
                            Get.toNamed('/account-settings');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.straighten,
                          title: 'Ukuran Saya',
                          subtitle: 'Atur ukuran badan anda',
                          onTap: () {
                            // Navigate to size settings
                            Get.toNamed('/measurements');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.message,
                          title: 'Feedback',
                          subtitle: 'Berikan Saran dan Kritik',
                          onTap: () {
                            Get.toNamed('/feedback');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.info_outline,
                          title: 'Tentang Aplikasi',
                          subtitle: 'Versi 1.0.0',
                          onTap: () {
                            Get.toNamed('/about');
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.color_lens_outlined,
                          title: 'Tema Halloween',
                          subtitle: themeController.isHalloweenTheme.value
                              ? 'Nonaktifkan tema'
                              : 'Aktifkan tema',
                          trailing: Switch(
                            value: themeController.isHalloweenTheme.value,
                            onChanged: (value) => themeController.toggleTheme(),
                            activeColor: ThemeController.halloweenPrimary,
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Keluar',
                            subtitle:
                                'Keluar dari akun ? ',
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Anda yakin ingin keluar?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        authController.logout();
                                      },
                                      child: Text('Ya, Keluar'),
                                    ),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            child: BottomNavigationBar(
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
              currentIndex: 3, // Profile tab is selected
              selectedItemColor: themeController.isHalloweenTheme.value 
                  ? ThemeController.halloweenPrimary 
                  : Colors.blue[700],
              unselectedItemColor: Colors.grey[600],
              onTap: (index) {
                switch (index) {
                  case 0:
                    Get.offAllNamed('/home');
                    break;
                  case 1:
                    Get.offAllNamed('/search');
                    break;
                  case 2:
                    Get.offAllNamed('/check');
                    break;
                  case 3:
                    // Already on profile
                    break;
                }
              },
            ),
          ),
        ));
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenCardBg
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black87,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeController.isHalloweenTheme.value
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.isHalloweenTheme.value
                            ? Colors.white70
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: themeController.isHalloweenTheme.value
                      ? Colors.white70
                      : Colors.grey,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: themeController.isHalloweenTheme.value
          ? Colors.grey[800]
          : Colors.grey[200],
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
