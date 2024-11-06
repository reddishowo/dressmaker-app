// order_view.dart
import 'package:clothing_store/app/modules/jahitbaju/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatelessWidget {
  final List<String> clothingTypes = ['Kemeja', 'Dress', 'Rok', 'Celana'];
  final List<String> fabricTypes = ['Cotton', 'Silk', 'Satin', 'Wool'];

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Jahit Baju'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jenis Pakaian", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: clothingTypes.map((type) {
                return Obx(() => ChoiceChip(
                  label: Text(type),
                  selected: controller.selectedClothingType.value == type,
                  onSelected: (_) => controller.setClothingType(type),
                ));
              }).toList(),
            ),
            SizedBox(height: 16),
            Text("Jenis Kain", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: fabricTypes.map((type) {
                return Obx(() => ChoiceChip(
                  label: Text(type),
                  selected: controller.selectedFabricType.value == type,
                  onSelected: (_) => controller.setFabricType(type),
                ));
              }).toList(),
            ),
            SizedBox(height: 16),
            Text("Tanggal Pertemuan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.meetingDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) controller.setMeetingDate(picked);
              },
              child: Obx(() => Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("${controller.meetingDate.value.toLocal()}".split(' ')[0]),
                  ],
                ),
              )),
            ),
            SizedBox(height: 16),
            Text("Catatan Tambahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: controller.additionalNotesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan catatan tambahan...',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: controller.submitOrder,
                child: Text('Ajukan Pesanan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
