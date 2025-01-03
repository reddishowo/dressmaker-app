class Feature {
  final String name;
  final String route;
  final String description;

  Feature({required this.name, required this.route, required this.description});
}

final List<Feature> appFeatures = [
  Feature(name: 'Profile', route: '/profile', description: 'User profile page'),
  Feature(name: 'Check Order', route: '/check', description: 'Order tracking page'),
  Feature(name: 'Measurement', route: '/measurements', description: 'Clothing measurement page'),
  Feature(name: 'About', route: '/about', description: 'About the store'),
  Feature(name: 'Account Settings', route: '/account-settings', description: 'Manage account settings'),
];
