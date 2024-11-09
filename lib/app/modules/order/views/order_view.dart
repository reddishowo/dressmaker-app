import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderView extends StatelessWidget {
  final List<String> clothingTypes = ['Kemeja', 'Dress', 'Rok', 'Celana'];
  final List<String> fabricTypes = ['Cotton', 'Silk', 'Satin', 'Wool'];

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Jahit Baju',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Jenis Pakaian'),
              SizedBox(height: 12),
              _buildChipGrid(
                items: clothingTypes,
                selectedItem: controller.selectedClothingType,
                onSelected: controller.setClothingType,
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Jenis Kain'),
              SizedBox(height: 12),
              _buildChipGrid(
                items: fabricTypes,
                selectedItem: controller.selectedFabricType,
                onSelected: controller.setFabricType,
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Tanggal Pertemuan'),
              SizedBox(height: 12),
              _buildDatePicker(context, controller),
              SizedBox(height: 24),
              _buildSectionTitle('Catatan Tambahan'),
              SizedBox(height: 12),
              _buildNotesField(controller),
              SizedBox(height: 32),
              _buildSubmitButton(controller),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildChipGrid({
    required List<String> items,
    required RxString selectedItem,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Obx(() {
          final isSelected = selectedItem.value == item;
          return InkWell(
            onTap: () => onSelected(item),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF4A44FF) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildDatePicker(BuildContext context, OrderController controller) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.meetingDate.value,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) controller.setMeetingDate(picked);
      },
      child: Obx(() => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            SizedBox(width: 12),
            Text(
              "${controller.meetingDate.value.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildNotesField(OrderController controller) {
    return TextField(
      controller: controller.additionalNotesController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Masukkan catatan tambahan...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildSubmitButton(OrderController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitOrder,
        child: Text(
          'Ajukan Pesanan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A44FF),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.home_outlined, true),
            _buildNavBarItem(Icons.search, false),
            _buildNavBarItem(Icons.shopping_bag_outlined, false),
            _buildNavBarItem(Icons.person_outline, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? Color(0xFF4A44FF) : Colors.grey,
      size: 24,
    );
  }
}