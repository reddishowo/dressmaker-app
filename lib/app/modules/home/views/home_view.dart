import 'package:clothing_store/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farriel Butik"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Ganti URL sesuai gambar profil
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Back!"),
                    Text(
                      "Bobby",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Pesanan Aktif
            Card(
              child: ListTile(
                title: Text("Pesanan Aktif"),
                subtitle: Text("Dress - Custom #123"),
                trailing: Text(
                  "Dalam Proses",
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  // Aksi lihat semua pesanan aktif
                },
              ),
            ),

            // Pilihan Menu
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuIcon(Icons.cut, "Jahit Baju"),
                _buildMenuIcon(Icons.calendar_today, "Jadwal"),
                _buildMenuIcon(Icons.straighten, "Ukuran"),
                _buildMenuIcon(Icons.shopping_cart, "Pesanan"),
              ],
            ),

            // Ukuran Saya
            SizedBox(height: 16),
            Text("Ukuran Saya", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSizeBox("Lingkar Dada", "88 cm"),
                _buildSizeBox("Lingkar Pinggang", "88 cm"),
                _buildSizeBox("Lingkar Pinggul", "88 cm"),
              ],
            ),

            // Pilihan Desain
            SizedBox(height: 16),
            Text("Pilihan Desain", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                );
              }),
            ),

            // Pesanan Terakhir
            SizedBox(height: 16),
            Text("Pesanan Terakhir", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildOrderCard("Dress - Custom", "#123", "24 Okt 2024", "Dalam Proses"),
            _buildOrderCard("Kemeja Formal", "#122", "21 Sept 2024", "Selesai", isCompleted: true),

            // Jadwal Mendatang
            SizedBox(height: 16),
            Text("Jadwal Mendatang", style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Fitting Dress - Custom"),
                subtitle: Text("Sabtu, 28 Oktober - 10:00"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildMenuIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          child: Icon(icon, size: 20),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _buildSizeBox(String label, String size) {
    return Column(
      children: [
        Text(label),
        Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrderCard(String title, String id, String date, String status, {bool isCompleted = false}) {
    return Card(
      child: ListTile(
        title: Text("$title $id"),
        subtitle: Text(date),
        trailing: Text(
          status,
          style: TextStyle(color: isCompleted ? Colors.grey : Colors.green),
        ),
        onTap: () {
          // Aksi Lihat Detail
        },
      ),
    );
  }
}
