import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';
import '../../../data/models/payment_method_model.dart';
class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPaymentMethodDialog(),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan jumlah pembayaran',
                        prefixText: 'Rp ',
                      ),
                      onChanged: (value) {
                        controller.setAmount(
                          double.tryParse(value) ?? 0.0,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Metode Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = controller.paymentMethods[index];
                        return Dismissible(
                          key: Key(method.id!),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            controller.showdeletePaymentMethod(method.id!);
                          },
                          child: RadioListTile<String>(
                            title: Text(method.name!),
                            subtitle: Text('Biaya: Rp ${method.fee}'),
                            value: method.id!,
                            groupValue: controller.selectedMethod.value,
                            onChanged: (value) {
                              controller.setPaymentMethod(value!);
                            },
                            secondary: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showPaymentMethodDialog(method: method),
                            ),
                          ),
                        );
                      },
                    )),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.selectedMethod.isEmpty
                            ? null
                            : controller.processPayment,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Bayar Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showPaymentMethodDialog({PaymentMethodModel? method}) {
    final isEditing = method != null;
    final nameController = TextEditingController(text: method?.name);
    final feeController = TextEditingController(text: method?.fee?.toString());
    
    // Daftar opsi metode pembayaran yang tersedia
    final List<Map<String, dynamic>> presetMethods = [
      {'name': 'BCA Virtual Account', 'fee': 4000},
      {'name': 'Mandiri Virtual Account', 'fee': 4000},
      {'name': 'BNI Virtual Account', 'fee': 4000},
      {'name': 'BRI Virtual Account', 'fee': 4000},
      {'name': 'Permata Virtual Account', 'fee': 4000},
      {'name': 'OVO', 'fee': 3000},
      {'name': 'GoPay', 'fee': 3000},
      {'name': 'DANA', 'fee': 3000},
      {'name': 'ShopeePay', 'fee': 3000},
      {'name': 'LinkAja', 'fee': 3000},
      {'name': 'QRIS', 'fee': 2000},
      {'name': 'Credit Card', 'fee': 5000},
    ];

    Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Edit Metode Pembayaran' : 'Tambah Metode Pembayaran',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (!isEditing) ...[
                const Text(
                  'Pilih Metode Tersedia:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: presetMethods.length,
                    itemBuilder: (context, index) {
                      final preset = presetMethods[index];
                      return ListTile(
                        title: Text(preset['name']),
                        subtitle: Text('Biaya: Rp ${preset['fee']}'),
                        onTap: () {
                          nameController.text = preset['name'];
                          feeController.text = preset['fee'].toString();
                        },
                        dense: true,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Atau isi manual:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
              ],
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Metode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Biaya',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty || feeController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Nama metode dan biaya harus diisi',
                          backgroundColor: Colors.red[100],
                        );
                        return;
                      }

                      final newMethod = PaymentMethodModel(
                        id: method?.id,
                        name: nameController.text,
                        fee: double.tryParse(feeController.text) ?? 0,
                      );

                      if (isEditing) {
                        controller.updatePaymentMethod(newMethod);
                      } else {
                        controller.addPaymentMethod(newMethod);
                      }
                    },
                    child: Text(isEditing ? 'Simpan' : 'Tambah'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}