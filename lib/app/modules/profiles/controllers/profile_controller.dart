import 'package:get/get.dart';
import 'package:clothing_store/app/data/services/authentication_controller.dart';
import 'package:clothing_store/app/data/models/profile_model.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  ProfileModel? get currentUser => authController.currentUser.value;

  String get currentUserName => currentUser?.username ?? '';

  void logout() {
    authController.logout();
  }
}