// lib/app/modules/account_settings/views/account_settings_view.dart

import 'package:clothing_store/app/modules/account/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clothing_store/app/data/services/theme_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: themeController.currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                themeController.currentTheme.appBarTheme.backgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Account Settings',
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: controller.updateProfile,
                child: Text(
                  controller.isEditing.value ? 'Save' : 'Edit',
                  style: TextStyle(
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            controller.authController.currentUser.value?.username
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: themeController.isHalloweenTheme.value
                                  ? ThemeController.halloweenPrimary
                                  : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  // Form Fields
                  _buildFormField(
                    label: 'Email',
                    value: controller.authController.currentUser.value?.email ?? '',
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    label: 'Username',
                    controller: controller.usernameController,
                    enabled: controller.isEditing.value,
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    label: 'Phone',
                    controller: controller.phoneController,
                    enabled: controller.isEditing.value,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildFormField({
    required String label,
    String? value,
    TextEditingController? controller,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isHalloweenTheme.value
                ? Colors.white70
                : Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: TextStyle(
            color: themeController.isHalloweenTheme.value
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: value,
            filled: true,
            fillColor: themeController.isHalloweenTheme.value
                ? ThemeController.halloweenCardBg
                : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}