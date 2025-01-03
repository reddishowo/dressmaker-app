import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class Feature {
  final String name;
  final String route;
  final String description;
  final IconData? icon; // Optional icon for UI representation
  final bool requiresAuth; // Flag for features that require authentication

  const Feature({
    required this.name, 
    required this.route, 
    required this.description,
    this.icon,
    this.requiresAuth = false,
  });

  // Helper method to navigate to the feature
  void navigate() => Get.toNamed(route);
}

// Extending the Routes class to include feature-specific methods
extension FeatureRoutes on Routes {
  static Feature getFeatureByRoute(String route) {
    return appFeatures.firstWhere(
      (feature) => feature.route == route,
      orElse: () => throw Exception('Feature not found for route: $route'),
    );
  }

  static bool isFeatureAvailable(String route) {
    return appFeatures.any((feature) => feature.route == route);
  }
}

final List<Feature> appFeatures = [
  Feature(
    name: 'Home',
    route: Routes.HOME,
    description: 'Main dashboard page',
  ),
  Feature(
    name: 'Profile',
    route: Routes.PROFILE,
    description: 'User profile page',
    requiresAuth: true,
  ),
  Feature(
    name: 'Check Order',
    route: Routes.CHECK,
    description: 'Order tracking page',
  ),
  Feature(
    name: 'Measurement',
    route: Routes.MEASUREMENT,
    description: 'Clothing measurement page',
  ),
  Feature(
    name: 'About',
    route: Routes.ABOUT,
    description: 'About the store',
  ),
  Feature(
    name: 'Account Settings',
    route: Routes.ACCOUNT,
    description: 'Manage account settings',
    requiresAuth: true,
  ),
  Feature(
    name: 'Search',
    route: Routes.SEARCH,
    description: 'Search products and orders',
  ),
  Feature(
    name: 'Order Clothes',
    route: Routes.JAHITBAJU,
    description: 'Place clothing orders',
    requiresAuth: true,
  ),
];

// Grouping features by authentication requirement
class FeatureGroups {
  static List<Feature> get authRequired => 
    appFeatures.where((feature) => feature.requiresAuth).toList();

  static List<Feature> get publicFeatures =>
    appFeatures.where((feature) => !feature.requiresAuth).toList();

  static List<Feature> getFeaturesByTags(List<String> tags) {
    // Implementation for future feature categorization
    return [];
  }
}