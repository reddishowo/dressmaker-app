import 'package:get/get.dart';

class VoucherController extends GetxController {
  // Contoh data voucher
  var vouchers = [
    {'title': 'Diskon 10%', 'description': 'Dapatkan diskon 10% untuk semua produk.', 'validity': 'Valid hingga 31 Jan 2025'},
    {'title': 'Gratis Ongkir', 'description': 'Gratis ongkir untuk pembelian minimal Rp 100.000.', 'validity': 'Valid hingga 15 Feb 2025'},
    {'title': 'Cashback 20%', 'description': 'Cashback 20% untuk pembayaran dengan e-wallet.', 'validity': 'Valid hingga 28 Feb 2025'},
  ].obs;

  // Function untuk menambahkan voucher baru
  void addVoucher(String title, String description, String validity) {
    vouchers.add({'title': title, 'description': description, 'validity': validity});
  }

  // Function untuk menghapus voucher
  void removeVoucher(int index) {
    vouchers.removeAt(index);
  }
}
