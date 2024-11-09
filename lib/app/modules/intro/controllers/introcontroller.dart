import 'package:get/get.dart';

class IntroController extends GetxController {
  // Observable untuk track halaman saat ini
  final currentPage = 0.obs;
  
  // Data untuk setiap halaman intro
  final List<Map<String, String>> introPages = [
    {
      'title1': 'Your style',
      'title2': 'speaks for you',
      'description': 'Explore a range of outfits today that perfectly capture who you are',
    },
    {
      'title1': 'Find your',
      'title2': 'perfect match',
      'description': 'Discover exclusive collections that match your unique style and personality',
    },
  ];

  // Method untuk menangani tombol continue
  void handleContinue() {
    if (currentPage.value < introPages.length - 1) {
      // Jika masih ada halaman intro berikutnya
      currentPage.value++;
    } else {
      // Jika sudah di halaman intro terakhir, navigasi ke register
      Get.toNamed('/register');
    }
  }
}