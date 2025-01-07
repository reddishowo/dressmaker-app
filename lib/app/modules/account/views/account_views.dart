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
          appBar: _buildAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildProfileForm(),
                ],
              ),
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeController.currentTheme.appBarTheme.backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenPrimary
              : Colors.black,
          size: 22,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Account Settings',
        style: TextStyle(
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenPrimary
              : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: TextButton.icon(
                onPressed: controller.updateProfile,
                icon: Icon(
                  controller.isEditing.value ? Icons.save : Icons.edit,
                  color: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenPrimary
                      : Colors.blue,
                ),
                label: Text(
                  controller.isEditing.value ? 'Save' : 'Edit',
                  style: TextStyle(
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: themeController.isHalloweenTheme.value
                      ? ThemeController.halloweenCardBg
                      : Colors.grey[200],
                  backgroundImage: controller.profileImage != null
                      ? FileImage(controller.profileImage!)
                      : null,
                  child: controller.profileImage == null
                      ? Text(
                          controller.authController.currentUser.value?.username
                                  ?.substring(0, 1)
                                  ?.toUpperCase() ??
                              'U',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: themeController.isHalloweenTheme.value
                                ? ThemeController.halloweenPrimary
                                : Colors.black87,
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  shape: CircleBorder(),
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeController.isHalloweenTheme.value
                            ? ThemeController.halloweenPrimary
                            : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            controller.authController.currentUser.value?.username ?? 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isHalloweenTheme.value
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Email',
            value: controller.authController.currentUser.value?.email ?? '',
            icon: Icons.email_outlined,
            enabled: false,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Username',
            controller: controller.usernameController,
            icon: Icons.person_outline,
            enabled: controller.isEditing.value,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Phone',
            controller: controller.phoneController,
            icon: Icons.phone_outlined,
            enabled: controller.isEditing.value,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: themeController.isHalloweenTheme.value
            ? ThemeController.halloweenPrimary
            : Colors.black87,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    String? value,
    TextEditingController? controller,
    bool enabled = true,
    TextInputType? keyboardType,
    IconData? icon,
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
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: TextField(
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
              prefixIcon: Icon(
                icon,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.grey[600],
              ),
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
                  width: 1.5,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
