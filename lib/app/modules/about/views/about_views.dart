import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
          backgroundColor: themeController.currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: themeController.currentTheme.appBarTheme.backgroundColor,
            elevation: 0,
            title: Text(
              'About',
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: themeController.isHalloweenTheme.value
                            ? ThemeController.halloweenCardBg
                            : Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: themeController.isHalloweenTheme.value
                            ? ThemeController.halloweenPrimary
                            : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App Version
                  Center(
                    child: Obx(() => Text(
                          'Version ${controller.appVersion.value}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeController.isHalloweenTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        )),
                  ),
                  const SizedBox(height: 24),

                  // App Description
                  Card(
                    elevation: 0,
                    color: themeController.currentTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About App',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeController.isHalloweenTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                controller.appDescription.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.isHalloweenTheme.value
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Development Team
                  Card(
                    elevation: 0,
                    color: themeController.currentTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Development Team',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeController.isHalloweenTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(() => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.developers.length,
                                itemBuilder: (context, index) {
                                  final developer = controller.developers[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: themeController.isHalloweenTheme.value
                                          ? ThemeController.halloweenPrimary
                                          : Colors.blue,
                                      child: Text(
                                        developer['name']![0],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      developer['name'] ?? '',
                                      style: TextStyle(
                                        color: themeController.isHalloweenTheme.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      developer['role'] ?? '',
                                      style: TextStyle(
                                        color: themeController.isHalloweenTheme.value
                                            ? Colors.white70
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.email,
                                        color: themeController.isHalloweenTheme.value
                                            ? ThemeController.halloweenPrimary
                                            : Colors.blue,
                                      ),
                                      onPressed: () {
                                        Get.snackbar(
                                          'Contact',
                                          'Contact ${developer['name']} at ${developer['email']}',
                                          backgroundColor: themeController.isHalloweenTheme.value
                                              ? ThemeController.halloweenCardBg
                                              : Colors.white,
                                          colorText: themeController.isHalloweenTheme.value
                                              ? Colors.white
                                              : Colors.black,
                                        );
                                      },
                                    ),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Support Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.support_agent,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: themeController.isHalloweenTheme.value
                            ? ThemeController.halloweenPrimary
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: controller.contactSupport,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}