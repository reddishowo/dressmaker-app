import 'package:get/get.dart';

class AboutController extends GetxController {
  final RxString appVersion = "1.0.0".obs;
  final RxString appDescription = '''
  Selamat datang di aplikasi Clothing Store kami!
  
  Aplikasi ini memungkinkan Anda untuk:
  • Memesan pakaian custom sesuai ukuran
  • Melihat katalog design terbaru
  • Melacak status pesanan
  • Menyimpan ukuran badan Anda
  '''
      .obs;

  final RxList<Map<String, String>> developers = [
    {
      'name': 'Farriel Arrianta', 
      'role': 'Lead Developer', 
      'email': 'farrielarrianta@webmail.umm.ac.id'},
    {
      'name': 'Muhammad Eka Nur A.',
      'role': 'UI/UX Designer',
      'email': 'kknurarief@webmail.umm.ac.id'
    },
    {
      'name': 'Ahmad Naufal Lutfan M.',
      'role': 'UI/UX Designer',
      'email': 'ahmadnaufal@webmail.umm.ac.id'
    },
    {
      'name': 'Nizam Avif Anhari',
      'role': 'UI/UX Designer',
      'email': 'nizamanhari@webmail.umm.ac.id'
    },
    {
      'name': 'Andi Fathir',
      'role': 'UI/UX Designer',
      'email': 'andifathirr@webmail.umm.ac.id'
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Add any initialization logic here
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    // Add logic to load app info if needed
    // For example, getting version from package info
    try {
      // You can add PackageInfo implementation here
      // final packageInfo = await PackageInfo.fromPlatform();
      // appVersion.value = packageInfo.version;
    } catch (e) {
      print('Error loading app info: $e');
    }
  }

  void contactSupport() {
    // Add logic to handle support contact
    // For example, launching email or phone
    Get.snackbar(
      'Contact Support',
      'Support email: support@example.com',
      duration: const Duration(seconds: 3),
    );
  }
}
