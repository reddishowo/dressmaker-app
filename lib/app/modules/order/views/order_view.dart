import 'package:clothing_store/app/data/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class OrderView extends StatelessWidget {
  final List<String> clothingTypes = ['Kemeja', 'Dress', 'Rok', 'Celana'];
  final List<String> fabricTypes = ['Cotton', 'Silk', 'Satin', 'Wool'];

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find();
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final isHalloween = themeController.isHalloweenTheme.value;
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: isHalloween ? ThemeController.halloweenPrimary : Color(0xFF1E88E5),
        brightness: isHalloween ? Brightness.dark : Theme.of(context).brightness,
      );

      return Scaffold(
        backgroundColor: isHalloween ? ThemeController.halloweenBackground : colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(colorScheme, isHalloween),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeaderSection(colorScheme, isHalloween),
                    SizedBox(height: 32),
                    
                    // Clothing Type Selection
                    _buildSectionTitle('Jenis Pakaian', colorScheme, isHalloween),
                    _buildChipGrid(
                      items: clothingTypes,
                      selectedItem: controller.selectedClothingType,
                      onSelected: controller.setClothingType,
                      colorScheme: colorScheme,
                      isHalloween: isHalloween,
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Fabric Type Selection
                    _buildSectionTitle('Jenis Kain', colorScheme, isHalloween),
                    _buildChipGrid(
                      items: fabricTypes,
                      selectedItem: controller.selectedFabricType,
                      onSelected: controller.setFabricType,
                      colorScheme: colorScheme,
                      isHalloween: isHalloween,
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Meeting Date Picker
                    _buildSectionTitle('Tanggal Pertemuan', colorScheme, isHalloween),
                    _buildDatePicker(context, controller, colorScheme, isHalloween),
                    
                    SizedBox(height: 24),
                    
                    // Additional Notes
                    _buildSectionTitle('Catatan Tambahan', colorScheme, isHalloween),
                    _buildNotesField(controller, colorScheme, isHalloween),
                    
                    SizedBox(height: 40),
                    
                    // Submit Button
                    _buildSubmitButton(controller, colorScheme, isHalloween),
                    
                    SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  SliverAppBar _buildSliverAppBar(ColorScheme colorScheme, bool isHalloween) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      backgroundColor: isHalloween ? ThemeController.halloweenBackground : colorScheme.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Jahit Baju',
          style: TextStyle(
            color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 24, bottom: 16),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 24),
          child: Material(
            elevation: 4,
            color: isHalloween ? ThemeController.halloweenCardBg : colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.notifications_none,
                  color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(ColorScheme colorScheme, bool isHalloween) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isHalloween 
                ? ThemeController.halloweenPrimary.withOpacity(0.3)
                : colorScheme.primary.withOpacity(0.1),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buat Pesanan Baru',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tentukan detail pesanan jahitan Anda',
            style: TextStyle(
              fontSize: 16,
              color: isHalloween ? Colors.white70 : colorScheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme, bool isHalloween) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isHalloween ? Colors.white : colorScheme.onSurface,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipGrid({
    required List<String> items,
    required RxString selectedItem,
    required Function(String) onSelected,
    required ColorScheme colorScheme,
    required bool isHalloween,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHalloween 
            ? ThemeController.halloweenCardBg
            : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHalloween 
              ? ThemeController.halloweenPrimary.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((item) {
          return Obx(() {
            final isSelected = selectedItem.value == item;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isSelected 
                    ? (isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary)
                    : (isHalloween ? ThemeController.halloweenCardBg : colorScheme.surface),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? (isHalloween ? ThemeController.halloweenPrimary.withOpacity(0.3) : colorScheme.primary.withOpacity(0.3))
                        : Colors.black.withOpacity(0.1),
                    blurRadius: isSelected ? 12 : 4,
                    offset: Offset(0, isSelected ? 4 : 2),
                    spreadRadius: isSelected ? 1 : 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => onSelected(item),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected 
                            ? (isHalloween ? Colors.white : colorScheme.onPrimary)
                            : (isHalloween ? Colors.white70 : colorScheme.onSurface),
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, OrderController controller, ColorScheme colorScheme, bool isHalloween) {
    return Container(
      decoration: BoxDecoration(
        color: isHalloween 
            ? ThemeController.halloweenCardBg
            : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHalloween 
              ? ThemeController.halloweenPrimary.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.meetingDate.value,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: colorScheme,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) controller.setMeetingDate(picked);
          },
          child: Obx(() => Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 16),
                Text(
                  "${controller.meetingDate.value.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    color: isHalloween ? Colors.white : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildNotesField(OrderController controller, ColorScheme colorScheme, bool isHalloween) {
    return Container(
      decoration: BoxDecoration(
        color: isHalloween 
            ? ThemeController.halloweenCardBg
            : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHalloween 
              ? ThemeController.halloweenPrimary.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller.additionalNotesController,
        maxLines: 4,
        style: TextStyle(
          color: isHalloween ? Colors.white : colorScheme.onSurface,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Tambahkan catatan khusus...',
          hintStyle: TextStyle(
            color: isHalloween ? Colors.white38 : colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isHalloween ? ThemeController.halloweenPrimary : colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(OrderController controller, ColorScheme colorScheme, bool isHalloween) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: isHalloween
              ? [
                  ThemeController.halloweenPrimary,
                  ThemeController.halloweenPrimary.withRed(255),
                ]
              : [
                  colorScheme.primary,
                  colorScheme.primary.withBlue(255),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isHalloween 
                ? ThemeController.halloweenPrimary.withOpacity(0.3)
                : colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            // Logic to handle form submission or theme switch
            controller.submitOrder(); // assuming you have a method for order submission
          },
          child: Center(
            child: Text(
              'Kirim Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isHalloween ? Colors.white : colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
