import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

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
            onPressed: () => _showMethodSelectionDialog(),
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
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                            controller.deletePaymentMethod(method.id!);
                          },
                          child: RadioListTile<String>(
                            title: Text(method.name!),
                            subtitle: Text('Biaya: Rp ${method.fee}'),
                            value: method.id!,
                            groupValue: controller.selectedMethod.value,
                            onChanged: (value) {
                              controller.setPaymentMethod(value!);
                            },
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

  void _showMethodSelectionDialog() {
    Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.availableMethods.length,
                itemBuilder: (context, index) {
                  final methodName = controller.availableMethods[index];
                  return ListTile(
                    title: Text(methodName),
                    onTap: () {
                      Get.back();
                      _showFeeInputDialog(methodName);
                    },
                    dense: true,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeeInputDialog(String methodName) {
    final feeController = TextEditingController();
    
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan Biaya untuk $methodName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                      if (feeController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Biaya harus diisi',
                          backgroundColor: Colors.red[100],
                        );
                        return;
                      }
                      
                      final fee = double.tryParse(feeController.text);
                      if (fee == null) {
                        Get.snackbar(
                          'Error',
                          'Biaya tidak valid',
                          backgroundColor: Colors.red[100],
                        );
                        return;
                      }
                      
                      controller.addPaymentMethod(methodName, fee);
                    },
                    child: const Text('Tambah'),
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