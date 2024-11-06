// order_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var selectedClothingType = ''.obs;
  var selectedFabricType = ''.obs;
  var meetingDate = DateTime.now().obs;
  TextEditingController additionalNotesController = TextEditingController();

  void setClothingType(String type) {
    selectedClothingType.value = type;
  }

  void setFabricType(String type) {
    selectedFabricType.value = type;
  }

  void setMeetingDate(DateTime date) {
    meetingDate.value = date;
  }

  void submitOrder() {
    // Implementasi untuk submit order
    print("Jenis Pakaian: ${selectedClothingType.value}");
    print("Jenis Kain: ${selectedFabricType.value}");
    print("Tanggal Pertemuan: ${meetingDate.value}");
    print("Catatan Tambahan: ${additionalNotesController.text}");
  }
}
