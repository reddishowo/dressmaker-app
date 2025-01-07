import '../controllers/voucher_controller.dart';
import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoucherView extends GetView<VoucherController> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Voucher Saya",
          style: TextStyle(
            color: themeController.isHalloweenTheme.value
                ? ThemeController.halloweenPrimary
                : Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: themeController.isHalloweenTheme.value
            ? ThemeController.halloweenBackground
            : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeController.isHalloweenTheme.value
              ? ThemeController.halloweenPrimary
              : Colors.black87,
        ),
      ),
      body: Obx(() {
        if (controller.vouchers.isEmpty) {
          return Center(
            child: Text(
              'Belum ada voucher tersedia.',
              style: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? Colors.white70
                    : Colors.black54,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.vouchers.length,
          itemBuilder: (context, index) {
            final voucher = controller.vouchers[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: themeController.isHalloweenTheme.value
                  ? ThemeController.halloweenCardBg
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  voucher['title'] ?? 'judul',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: themeController.isHalloweenTheme.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      voucher['description']?? 'deskripsi',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isHalloweenTheme.value
                            ? Colors.white70
                            : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      voucher['validity']?? 'valid',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.isHalloweenTheme.value
                            ? Colors.orangeAccent
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Colors.red,
                  ),
                  onPressed: () => controller.removeVoucher(index),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan logika untuk menambahkan voucher
          Get.dialog(_addVoucherDialog());
        },
        backgroundColor: themeController.isHalloweenTheme.value
            ? ThemeController.halloweenPrimary
            : Colors.blue[700],
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _addVoucherDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final validityController = TextEditingController();

    return AlertDialog(
      title: Text(
        'Tambah Voucher',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Judul'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Deskripsi'),
          ),
          TextField(
            controller: validityController,
            decoration: InputDecoration(labelText: 'Masa Berlaku'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty &&
                validityController.text.isNotEmpty) {
              controller.addVoucher(
                titleController.text,
                descriptionController.text,
                validityController.text,
              );
              Get.back();
            }
          },
          child: Text('Tambah'),
        ),
      ],
    );
  }
}
