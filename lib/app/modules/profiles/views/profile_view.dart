import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
              radius: 40,
            ),
            SizedBox(height: 16),
            _buildProfileItem(
              icon: Icons.person,
              title: 'Akun Anda',
              subtitle: controller.currentUserName,
            ),
            _buildProfileItem(
              icon: Icons.straighten,
              title: 'Ukuran Saya',
              subtitle: 'Atur ukuran badan anda',
            ),
            _buildProfileItem(
              icon: Icons.calendar_today,
              title: 'Seputar Pertanyaan',
              subtitle: '',
            ),
            _buildProfileItem(
              icon: Icons.check_circle_outline,
              title: 'Tentang Aplikasi',
              subtitle: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}