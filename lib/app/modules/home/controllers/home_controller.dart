import 'package:get/get.dart';

class HomeController extends GetxController {
  // Contoh state untuk data pesanan dan ukuran
  var activeOrder = "Dress - Custom #123".obs;
  var activeOrderStatus = "Dalam Proses".obs;
  var userSize = {
    "Lingkar Dada": "88 cm",
    "Lingkar Pinggang": "88 cm",
    "Lingkar Pinggul": "88 cm"
  }.obs;

  // Method untuk memperbarui status pesanan
  void updateOrderStatus(String newStatus) {
    activeOrderStatus.value = newStatus;
  }

  // Method lainnya untuk mengelola data
}
