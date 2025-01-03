import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/feature.dart';

class SearchControllers extends GetxController {
    final RxInt selectedIndex = 1.obs;
  var searchController = TextEditingController();
  var searchResults = <Feature>[].obs;
  var isLoading = false.obs;

  void performSearch() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    // Filter fitur berdasarkan query
    searchResults.value = appFeatures
        .where((feature) =>
            feature.name.toLowerCase().contains(query) ||
            feature.description.toLowerCase().contains(query))
        .toList();
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
}
