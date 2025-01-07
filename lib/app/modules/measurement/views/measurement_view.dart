import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/measurement_controller.dart';
import '../../../data/services/theme_controller.dart';

class MeasurementView extends GetView<MeasurementController> {
  final ThemeController themeController = Get.find<ThemeController>();

  Widget _buildMeasurementField({
    required String label,
    required TextEditingController textController,
    required String hint,
    required IconData icon,
  }) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: themeController.isHalloweenTheme.value
                ? [
                    BoxShadow(
                      color: ThemeController.halloweenPrimary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ] 
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
          ),
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: themeController.isHalloweenTheme.value
                  ? Colors.white
                  : Colors.black87,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.blue,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: themeController.isHalloweenTheme.value
                  ? ThemeController.halloweenCardBg
                  : Colors.white,
              labelStyle: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? Colors.white70
                    : Colors.grey[700],
              ),
              hintStyle: TextStyle(
                color: themeController.isHalloweenTheme.value
                    ? Colors.white30
                    : Colors.grey[400],
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
          ),
        ));
  }

  Widget _buildHeader() {
    return Obx(() => Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeController.isHalloweenTheme.value
                ? ThemeController.halloweenCardBg
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.straighten,
                size: 32,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.blue,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengukuran Pakaian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeController.isHalloweenTheme.value
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Masukkan ukuran dalam satuan centimeter (cm)',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isHalloweenTheme.value
                            ? Colors.white70
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: themeController.currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                themeController.currentTheme.appBarTheme.backgroundColor,
            title: Text(
              'Ukuran Saya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: themeController.isHalloweenTheme.value
                    ? ThemeController.halloweenPrimary
                    : Colors.black,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          body: controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: themeController.isHalloweenTheme.value
                        ? ThemeController.halloweenPrimary
                        : Colors.blue,
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 24),
                      Card(
                        elevation: 0,
                        color: themeController.currentTheme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMeasurementField(
                                label: 'Lebar Bahu',
                                textController: controller.shoulderController,
                                hint: 'Contoh: 40',
                                icon: Icons.accessibility_new,
                              ),
                              _buildMeasurementField(
                                label: 'Lingkar Dada',
                                textController: controller.chestController,
                                hint: 'Contoh: 90',
                                icon: Icons.radar,
                              ),
                              _buildMeasurementField(
                                label: 'Lingkar Pinggang',
                                textController: controller.waistController,
                                hint: 'Contoh: 75',
                                icon: Icons.straighten,
                              ),
                              _buildMeasurementField(
                                label: 'Lingkar Pinggul',
                                textController: controller.hipController,
                                hint: 'Contoh: 95',
                                icon: Icons.shape_line,
                              ),
                              _buildMeasurementField(
                                label: 'Panjang Lengan',
                                textController: controller.sleeveController,
                                hint: 'Contoh: 60',
                                icon: Icons.align_horizontal_left,
                              ),
                              _buildMeasurementField(
                                label: 'Lingkar Lengan',
                                textController: controller.armController,
                                hint: 'Contoh: 30',
                                icon: Icons.fitness_center,
                              ),
                              _buildMeasurementField(
                                label: 'Panjang Badan',
                                textController: controller.bodyController,
                                hint: 'Contoh: 70',
                                icon: Icons.height,
                              ),
                              _buildMeasurementField(
                                label: 'Lingkar Leher',
                                textController: controller.neckController,
                                hint: 'Contoh: 36',
                                icon: Icons.account_circle,
                              ),
                              SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: controller.saveMeasurements,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        themeController.isHalloweenTheme.value
                                            ? ThemeController.halloweenPrimary
                                            : Colors.blue,
                                    elevation: 2,
                                    shadowColor:
                                        themeController.isHalloweenTheme.value
                                            ? ThemeController.halloweenPrimary
                                                .withOpacity(0.4)
                                            : Colors.blue.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save_alt, size: 24),
                                      SizedBox(width: 8),
                                      Text(
                                        'Simpan Ukuran',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}