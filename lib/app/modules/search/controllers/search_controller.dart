import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/feature.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchControllers extends GetxController {
  final RxInt selectedIndex = 1.obs;
  var searchController = TextEditingController();
  var searchResults = <Feature>[].obs;
  var isLoading = false.obs;
  var isListening = false.obs;
  
  late stt.SpeechToText _speech;
  
  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    initSpeechRecognition();
  }
  
  Future<void> initSpeechRecognition() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          isListening.value = false;
        }
      },
      onError: (error) {
        isListening.value = false;
        Get.snackbar(
          'Error',
          'Speech recognition error: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
    
    if (!available) {
      Get.snackbar(
        'Error',
        'Speech recognition not available on this device',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> startListening() async {
    if (!_speech.isAvailable) return;
    
    isListening.value = true;
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          searchController.text = result.recognizedWords;
          performSearch();
          isListening.value = false;
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      partialResults: false,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }
  
  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }


  void performSearch() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    // Filter fitur berdasarkan query
    searchResults.value = appFeatures
        .where((feature) =>
            feature.name.toLowerCase().contains(query) ||
            feature.description.toLowerCase().contains(query))
        .toList();
  }
  void onNavBarTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0: // Home
        Get.offAllNamed('/home');
        break;
      case 1: // Search
         Get.toNamed('/search');
        break;
      case 2: // Orders
        Get.offAllNamed('/check');
        break;
      case 3: // Profile
        Get.offAllNamed('/profile');
        break;
    }
  }
}
