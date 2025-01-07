import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/payment_method_model.dart';
import '../../../data/models/payment_model.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rx<String> selectedMethod = ''.obs;
  final RxBool isLoading = false.obs;
  final RxDouble amount = 0.0.obs;
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final RxList<String> availableMethods = <String>[
    'BCA Virtual Account',
    'Mandiri Virtual Account',
    'BNI Virtual Account',
    'BRI Virtual Account',
    'Permata Virtual Account',
    'OVO',
    'GoPay',
    'DANA',
    'ShopeePay',
    'LinkAja',
    'QRIS',
    'Credit Card',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final snapshot = await _firestore.collection('payment_methods').get();
      final methods = snapshot.docs
          .map((doc) => PaymentMethodModel.fromJson(doc.data()))
          .toList();
      paymentMethods.assignAll(methods);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil metode pembayaran: $e');
    }
  }

  Future<void> addPaymentMethod(String methodName, double fee) async {
    try {
      isLoading.value = true;
      final method = PaymentMethodModel(
        name: methodName,
        fee: fee,
      );
      
      final docRef = _firestore.collection('payment_methods').doc();
      method.id = docRef.id;
      await docRef.set(method.toJson());
      await fetchPaymentMethods();
      Get.back(); // Close dialog
      Get.snackbar('Sukses', 'Metode pembayaran berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan metode pembayaran: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    try {
      isLoading.value = true;
      await _firestore.collection('payment_methods').doc(id).delete();
      await fetchPaymentMethods();
      Get.snackbar('Sukses', 'Metode pembayaran berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus metode pembayaran: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  void setAmount(double value) {
    amount.value = value;
  }

  Future<void> processPayment() async {
    if (selectedMethod.isEmpty) {
      Get.snackbar('Error', 'Pilih metode pembayaran terlebih dahulu');
      return;
    }

    try {
      isLoading.value = true;

      final payment = PaymentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        method: selectedMethod.value,
        amount: amount.value,
        status: 'success',
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('payments')
          .doc(payment.id)
          .set(payment.toJson());

      Get.snackbar('Sukses', 'Pembayaran berhasil diproses');
      
      selectedMethod.value = '';
      amount.value = 0.0;
      Get.offAllNamed('/home');
      
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}