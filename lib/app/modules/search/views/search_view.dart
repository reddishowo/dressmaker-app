import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import 'package:clothing_store/app/data/services/theme_controller.dart';

class SearchView extends GetView<SearchControllers> {
  
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Tampilkan fitur filter (opsional)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search pages, features...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: controller.performSearch,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else if (controller.searchResults.isEmpty) {
                return Text('No results found');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      var result = controller.searchResults[index];
                      return ListTile(
                        title: Text(result.name),
                        subtitle: Text(result.description),
                        onTap: () {
                          // Arahkan ke halaman yang sesuai
                          Get.toNamed(result.route);
                        },
                      );
                    },
                  ),
                );
              }
            }),
          ],
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
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }
}
